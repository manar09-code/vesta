import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Illustration d'un bien. Les PNG sont extraits des SVG de la maquette ;
/// si l'asset manque, on retombe sur une plaque de couleur theme.
class ListingIllustration extends StatelessWidget {
  const ListingIllustration(
    this.imageKey, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String imageKey;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$imageKey.png',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => Container(
        width: width,
        height: height,
        color: VestaColors.spec,
        alignment: Alignment.center,
        child: const Icon(Icons.home_work_outlined, size: 42, color: VestaColors.muted2),
      ),
    );
  }
}
