import 'dart:convert';

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