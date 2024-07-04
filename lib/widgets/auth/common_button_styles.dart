import 'package:flutter/material.dart';

class CommonButtonStyles {
  static ButtonStyle get primaryButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF016171),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
