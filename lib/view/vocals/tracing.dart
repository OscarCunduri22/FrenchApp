// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';

class TracingGame extends StatefulWidget {
  final String letter;
  final String imageAssetPath;
  final String imageObjectName;

  TracingGame(
      {super.key,
      required this.letter,
      required this.imageAssetPath,
      required this.imageObjectName});

  @override
  _TracingGameState createState() => _TracingGameState();
}

class _TracingGameState extends State<TracingGame> {
  List<Offset?> points = [];
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/vocals/bg.jpg"), // Change to your background image asset
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Row(
            children: [
              // Canvas on the left, centered vertically
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        points.add(details.localPosition);
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        points.add(null);
                        isCompleted = checkCompletion();
                      });
                    },
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter:
                          LetterPainter(points: points, letter: widget.letter),
                    ),
                  ),
                ),
              ),
              // Display image or placeholder on the right
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: isCompleted
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Good Job!',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Image.asset(widget.imageAssetPath,
                                height: 200, width: 200),
                            Text(
                              widget.imageObjectName,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      : const SizedBox(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: Text(
                              'Trace the letter',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.black),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkCompletion() {
    const int gridSize = 200; // Define the grid size
    Set<Offset> coveredCells = {};

    for (Offset? point in points) {
      if (point != null) {
        int cellX = (point.dx / gridSize).floor();
        int cellY = (point.dy / gridSize).floor();
        coveredCells.add(Offset(cellX.toDouble(), cellY.toDouble()));
      }
    }

    int totalCells = (300 / gridSize).ceil() * (300 / gridSize).ceil();
    int coveredCellCount = coveredCells.length;

    // Define completion threshold (e.g., 80% coverage)
    double coverageThreshold = 0.5;

    return (coveredCellCount / totalCells) >= coverageThreshold;
  }
}

class LetterPainter extends CustomPainter {
  final List<Offset?> points;
  final String letter;

  LetterPainter({required this.points, required this.letter});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }

    // Draw the letter outline (simplified example)
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
            fontSize: 200,
            color: const Color.fromARGB(255, 77, 75, 75).withOpacity(0.3)),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(canvas, Offset(size.width / 8, size.height / 8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
