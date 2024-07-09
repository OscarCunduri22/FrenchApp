// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';

class GameCard extends StatelessWidget {
  final String category;
  final int gameNumber;
  final bool isUnlocked;
  final VoidCallback onPlayPressed;
  final double width;
  final double height;
  String gameName;

  GameCard({
    super.key,
    required this.category,
    required this.gameNumber,
    required this.isUnlocked,
    required this.onPlayPressed,
    required this.width,
    required this.height,
    this.gameName = '',
  });

  String _getGameName() {
    switch (category) {
      case 'Nombres':
        if (gameNumber == 1) return 'Vagones numericos';
        if (gameNumber == 2) return 'Memoria de numeros';
        if (gameNumber == 3) return 'Burbujas';
      case 'Voyelles':
        if (gameNumber == 1) return 'Encuentra la vocal';
        if (gameNumber == 2) return 'Memoria de vocales';
        if (gameNumber == 3) return 'Completa el animal';
      case 'Famille':
        if (gameNumber == 1) return 'Encuentra a la familia';
        if (gameNumber == 2) return 'Reune a la familia';
        if (gameNumber == 3) return 'Empareja a la familia';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final imagePath =
        'assets/images/gameSelection/${category}_game_$gameNumber.jpg';

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  text: _getGameName(),
                  type: TextType.Subtitle,
                  fontSize: 24,
                  color: ColorType.Secondary,
                  shadowColor: ShadowType.Light,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  width: width * 0.9,
                  height: height * 0.5,
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
                width: width,
                height: height,
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
