import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Color backgroundColor;
  final Color progressBarColor;
  final String headerText;
  final double progressValue;
  final VoidCallback onBack;
  final VoidCallback onVolume;

  const ProgressBar({
    required this.backgroundColor,
    required this.progressBarColor,
    required this.headerText,
    required this.progressValue,
    required this.onBack,
    required this.onVolume,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Image.asset(
                    'assets/images/icons/hacia-atras.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(progressBarColor),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onVolume,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Image.asset(
                    'assets/images/icons/sonido.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onVolume,
                child: Container(
                  margin: const EdgeInsets.only(right: 30),
                  child: Image.asset(
                    'assets/images/icons/gallo-galo.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            headerText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
