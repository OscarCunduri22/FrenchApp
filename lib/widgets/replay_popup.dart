import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';

class ReplayPopup extends StatefulWidget {
  const ReplayPopup({
    Key? key,
    required this.score,
    required this.onReplay,
    required this.onQuit,
  }) : super(key: key);

  final int score;
  final VoidCallback onReplay;
  final VoidCallback onQuit;

  @override
  State<ReplayPopup> createState() => _ReplayPopupState();
}

class _ReplayPopupState extends State<ReplayPopup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Image.asset(
                    'assets/images/gallo.png',
                    fit: BoxFit.cover,
                  ),
                ),
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
                              filled: index < (widget.score / 2).ceil(),
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
                                value: widget.score / 10,
                                backgroundColor: Colors.grey[300],
                                color: Colors.blue,
                                minHeight: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${widget.score}/10',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 54, 54, 54),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              widget.onReplay();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF016171),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Repetir',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              widget.onQuit();
                              Navigator.of(context).pop();
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ],
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
