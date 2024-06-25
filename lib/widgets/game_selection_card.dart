import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';

class GameCard extends StatelessWidget {
  final String category;
  final int gameNumber;
  final bool isUnlocked;
  final VoidCallback onPlayPressed;

  GameCard({
    required this.category,
    required this.gameNumber,
    required this.isUnlocked,
    required this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath =
        'assets/images/gameSelection/${category}_game_$gameNumber.jpg';

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 160,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  text: 'Juego $gameNumber',
                  type: TextType.Subtitle,
                  fontSize: 24,
                  color: ColorType.Secondary,
                  shadowColor: ShadowType.Light,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 144,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: isUnlocked ? onPlayPressed : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFFFE600),
                    backgroundColor: const Color(0xFF321158),
                    side: const BorderSide(color: Color(0xFFFFE600)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Jugar',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isUnlocked)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                width: 160,
                height: 220,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
        if (!isUnlocked)
          Positioned.fill(
            child: Center(
              child: Image.asset(
                'assets/images/icons/candado.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
      ],
    );
  }
}
