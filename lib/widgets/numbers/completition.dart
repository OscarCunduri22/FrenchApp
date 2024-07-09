import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frenc_app/widgets/character/gallo.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';

class CompletionPopup extends StatelessWidget {
  final int score;
  final int overScore;
  final VoidCallback onQuit;

  const CompletionPopup({
    Key? key,
    required this.score,
    required this.onQuit,
    required this.overScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int filledStars = (score / overScore * 5).ceil();

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24).copyWith(right: 40),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: Row(
              children: [
                SizedBox(
                    width: 200,
                    height: 200,
                    child: GalloComponent.speakingwithoutsound()),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                        child: CustomTextWidget(
                          text: 'Puntaje final',
                          type: TextType.Title,
                          fontSize: 44,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return ShakeY(
                            from: 10,
                            infinite: true,
                            child: Star(
                              filled: index < filledStars,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: score / overScore,
                                backgroundColor: Colors.grey[300],
                                color: Colors.blue,
                                minHeight: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$score/$overScore',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 54, 54, 54),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          onQuit();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF15E2F),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Salir',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Star extends StatelessWidget {
  final bool filled;

  const Star({Key? key, required this.filled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(
          Icons.star_border,
          color: Colors.black12,
          size: 60,
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Icon(
            Icons.star,
            color: filled ? Colors.yellow[600] : Colors.grey[300],
            size: 58,
          ),
        ),
      ],
    );
  }
}
