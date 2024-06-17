import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/progress_bar.dart';

class DragAndDropGame extends StatefulWidget {
  const DragAndDropGame({Key? key}) : super(key: key);

  @override
  State<DragAndDropGame> createState() => _DragAndDropGameState();
}

class _DragAndDropGameState extends State<DragAndDropGame> {
  final List<String> images = [
    'assets/images/family/siluetmother.png',
    'assets/images/family/siluetsister.png',
    'assets/images/family/siluetfather.png',
    'assets/images/family/siluetson.png',
  ];

  final Map<String, String> targetToImage = {
    'mother': 'assets/images/family/siluetmother.png',
    'sister': 'assets/images/family/siluetsister.png',
    'father': 'assets/images/family/siluetfather.png',
    'son': 'assets/images/family/siluetson.png',
  };

  Map<String, String> placedImages = {};

  double score = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/family/redbackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            ProgressBar(
              backgroundColor: const Color(0xFF424141),
              progressBarColor: const Color(0xFFD67171),
              headerText:
                  'Sélectionnez l\'image qui ressemble à celle ci-dessus',
              progressValue: score,
              onBack: () {
                // Acción para retroceder
              },
              onVolume: () {
                // Acción para controlar el volumen
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  buildPositionedDragTarget(
                    'mother',
                    left: 605,
                    top: 80,
                    silueta: 'assets/images/family/smother.png',
                    width: 100,
                    height: 160,
                  ),
                  buildPositionedDragTarget(
                    'father',
                    left: 230,
                    top: 80,
                    silueta: 'assets/images/family/sfather.png',
                    width: 100,
                    height: 160,
                  ),
                  buildPositionedDragTarget(
                    'sister',
                    left: 480,
                    top: 120,
                    silueta: 'assets/images/family/ssister.png',
                    width: 100,
                    height: 130,
                  ),
                  buildPositionedDragTarget(
                    'son',
                    left: 370,
                    top: 110,
                    silueta: 'assets/images/family/sbrother.png',
                    width: 100,
                    height: 130,
                  ),
                  // Draggable images in specific squares
                  ...buildRemainingDraggableImages(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRemainingDraggableImages() {
    return images
        .where((image) => !placedImages.containsValue(image))
        .map((image) {
      int index = images.indexOf(image);
      double? left = index.isEven ? 10 : null;
      double? right = index.isOdd ? 10 : null;
      double top =
          index.isEven ? 5 + (index ~/ 2) * 155 : 5 + ((index - 1) ~/ 2) * 155;
      return buildPositionedDraggable(image,
          left: left, right: right, top: top);
    }).toList();
  }

  Widget buildDraggable(String image) {
    return Draggable<String>(
      data: image,
      feedback: Image.asset(image, width: 100, height: 100),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: Image.asset(image, width: 100, height: 100),
      ),
      child: Image.asset(image, width: 100, height: 100),
    );
  }

  Widget buildPositionedDraggable(String image,
      {double? left, double? right, required double top}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: buildDraggable(image),
    );
  }

  Widget buildPositionedDragTarget(
    String target, {
    required double left,
    required double top,
    required String silueta,
    required double width,
    required double height,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: DragTarget<String>(
        builder: (context, candidateData, rejectedData) {
          bool isPlaced = placedImages.containsKey(target);
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isPlaced ? placedImages[target]! : silueta),
                fit: BoxFit.contain,
              ),
            ),
          );
        },
        onWillAccept: (data) => data == targetToImage[target],
        onAccept: (data) {
          setState(() {
            placedImages[target] = data;
            score = placedImages.length / images.length;
          });
        },
      ),
    );
  }
}
