import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

/// Errors the UI can show. Screens turn them into translated messages.
enum PhotoError { tooManyPhotos, tooLarge, readFailed }

class PhotoFailure implements Exception {
  const PhotoFailure(this.error);

  final PhotoError error;
}

/// Firestore rules accept at most 280000 characters of base64 per photo.
/// We stay a little below to keep a safety margin.
const int maxBase64Chars = 270000;

/// Profile photo: square of 200 px, JPEG, under 100 KB (ticket VST-48).
const int profilePhotoSide = 200;
const int maxProfilePhotoBytes = 100 * 1024;

class PhotoService {
  final ImagePicker _picker = ImagePicker();

  /// Picks one photo, compresses it, and returns it as a base64 string.
  /// Returns null if the user cancels.
  /// [currentCount] is the number of photos already chosen:
  /// a 6th photo is refused before opening the picker.
  Future<String?> pickPhoto({
    required ImageSource source,
    required int currentCount,
    int maxPhotos = 5,
  }) async {
    if (currentCount >= maxPhotos) {
      throw const PhotoFailure(PhotoError.tooManyPhotos);
    }

    final picked = await _picker.pickImage(source: source);
    if (picked == null) return null; // user cancelled

    return _compressToBase64(picked.path);
  }

  /// Picks one photo and returns a small square JPEG as base64.
  /// Returns null if the user cancels.
  Future<String?> pickProfilePhoto({required ImageSource source}) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (picked == null) return null; // user cancelled

    try {
      final square = await _cropSquarePng(
        await picked.readAsBytes(),
        profilePhotoSide,
      );
      for (final quality in [85, 70, 55, 40]) {
        final bytes = await FlutterImageCompress.compressWithList(
          square,
          minWidth: profilePhotoSide,
          minHeight: profilePhotoSide,
          quality: quality,
          format: CompressFormat.jpeg,
        );
        if (bytes.length <= maxProfilePhotoBytes) return base64Encode(bytes);
      }
    } catch (_) {
      throw const PhotoFailure(PhotoError.readFailed);
    }
    throw const PhotoFailure(PhotoError.tooLarge);
  }

  /// Centre crop to a square, resized to [side] px, returned as PNG bytes.
  Future<Uint8List> _cropSquarePng(Uint8List source, int side) async {
    final codec = await ui.instantiateImageCodec(source);
    final image = (await codec.getNextFrame()).image;

    final shortSide = math.min(image.width, image.height).toDouble();
    final from = ui.Rect.fromLTWH(
      (image.width - shortSide) / 2,
      (image.height - shortSide) / 2,
      shortSide,
      shortSide,
    );
    final to = ui.Rect.fromLTWH(0, 0, side.toDouble(), side.toDouble());

    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder).drawImageRect(
      image,
      from,
      to,
      ui.Paint()..filterQuality = ui.FilterQuality.high,
    );
    final cropped = await recorder.endRecording().toImage(side, side);
    final data = await cropped.toByteData(format: ui.ImageByteFormat.png);

    image.dispose();
    cropped.dispose();
    codec.dispose();

    if (data == null) throw const PhotoFailure(PhotoError.readFailed);
    return data.buffer.asUint8List();
  }

  /// About 800 px wide, JPEG. If the base64 is still too long,
  /// we retry with a lower quality before giving up.
  Future<String> _compressToBase64(String path) async {
    for (final quality in [80, 65, 50, 35]) {
      final bytes = await FlutterImageCompress.compressWithFile(
        path,
        minWidth: 800,
        minHeight: 800,
        quality: quality,
        format: CompressFormat.jpeg,
      );
      if (bytes == null) throw const PhotoFailure(PhotoError.readFailed);

      final encoded = base64Encode(bytes);
      if (encoded.length <= maxBase64Chars) return encoded;
    }
    throw const PhotoFailure(PhotoError.tooLarge);
  }
}