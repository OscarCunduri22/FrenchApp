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
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                    'assets/images/icons/exit.png',
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 25,
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
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            headerText,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontFamily: 'TitanOneFont'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
