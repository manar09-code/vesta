import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Logo Vesta : maison dorée dessinée + « Vesta » + mention « IMMOBILIER ».
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.light = false, this.fontSize = 28});

  final bool light;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final textColor = light ? Colors.white : VestaColors.ink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(fontSize * 1.35, fontSize * 1.35),
          painter: HouseLogoPainter(
            color: VestaColors.gold,
            strokeWidth: fontSize * 0.1,
          ),
        ),
        SizedBox(width: fontSize * 0.4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vesta',
              style: TextStyle(
                fontFamily: VestaFonts.serif,
                fontSize: fontSize,
                letterSpacing: -0.5,
                color: textColor,
                height: 1,
              ),
            ),
            SizedBox(height: fontSize * 0.14),
            Text(
              'IMMOBILIER',
              style: TextStyle(
                fontFamily: VestaFonts.sans,
                fontSize: fontSize * 0.31,
                fontWeight: FontWeight.w700,
                letterSpacing: fontSize * 0.16,
                color: VestaColors.goldEm,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Maison (toit + porte en arc) tracée à la main, comme la maquette.
class HouseLogoPainter extends CustomPainter {
  const HouseLogoPainter({required this.color, this.strokeWidth = 3});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final house = Path()
      ..moveTo(w * 0.06, h * 0.46)
      ..lineTo(w * 0.5, h * 0.07)
      ..lineTo(w * 0.94, h * 0.46)
      ..lineTo(w * 0.94, h * 0.93)
      ..lineTo(w * 0.06, h * 0.93)
      ..close();
    canvas.drawPath(house, paint);

    // Porte en arc.
    final door = Path()
      ..moveTo(w * 0.33, h * 0.93)
      ..lineTo(w * 0.33, h * 0.68)
      ..arcTo(
        Rect.fromCircle(center: Offset(w * 0.5, h * 0.68), radius: w * 0.17),
        3.14159,
        3.14159,
        false,
      )
      ..lineTo(w * 0.67, h * 0.93);
    canvas.drawPath(door, paint);
  }

  @override
  bool shouldRepaint(HouseLogoPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// Eyebrow : petit libellé capitales espacées.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: VestaFonts.sans,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: color ?? VestaColors.goldDeep,
      ),
    );
  }
}
