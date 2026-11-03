import 'dart:convert';

import 'package:flutter/material.dart';

/// Round profile photo. Shows a default icon when there is no photo
/// (or when the stored base64 cannot be decoded).
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.photoBase64, this.radius = 48});

  final String? photoBase64;
  final double radius;

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    final data = photoBase64;
    if (data != null && data.isNotEmpty) {
      try {
        image = MemoryImage(base64Decode(data));
      } catch (_) {
        image = null;
      }
    }
    return CircleAvatar(
      radius: radius,
      backgroundImage: image,
      child: image == null ? Icon(Icons.person, size: radius) : null,
    );
  }
}
