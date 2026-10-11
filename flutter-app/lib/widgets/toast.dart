import 'dart:async';

import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Toast façon maquette : bandeau vert foncé, centré au-dessus du menu.
class VestaToast {
  VestaToast._();

  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(BuildContext context, String message) {
    _entry?.remove();
    _timer?.cancel();

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 98,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 365),
            margin: const EdgeInsets.symmetric(horizontal: 22),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: VestaColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Color(0x40153B35), blurRadius: 22, offset: Offset(0, 8)),
              ],
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: VestaFonts.sans,
                fontSize: 12,
                height: 1.4,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);
    _entry = entry;
    _timer = Timer(const Duration(milliseconds: 3500), () {
      entry.remove();
      if (_entry == entry) _entry = null;
    });
  }
}
