import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'dart:math';

class GatherFamilyGame extends StatefulWidget {
  const GatherFamilyGame({Key? key}) : super(key: key);

  @override
  State<GatherFamilyGame> createState() => _GatherFamilyGameState();
}

class _GatherFamilyGameState extends State<GatherFamilyGame> {
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

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> targets = [
      {
        'target': 'mother',
        'left': 605.0,
        'top': 80.0,
        'silueta': 'assets/images/family/smother.png',
        'width': 100.0,
        'height': 160.0,
      },
      {
        'target': 'father',
        'left': 230.0,
        'top': 80.0,
        'silueta': 'assets/images/family/sfather.png',
        'width': 100.0,
        'height': 160.0,
      },
      {
        'target': 'sister',
        'left': 480.0,
        'top': 120.0,
        'silueta': 'assets/images/family/ssister.png',
        'width': 100.0,
        'height': 130.0,
      },
      {
        'target': 'son',
        'left': 370.0,
        'top': 110.0,
        'silueta': 'assets/images/family/sbrother.png',
        'width': 100.0,
        'height': 130.0,
      },
    ];

    targets.shuffle(random);

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
                  ...targets.map((target) {
                    return buildPositionedDragTarget(
                      target['target'],
                      left: target['left'],
                      top: target['top'],
                      silueta: target['silueta'],
                      width: target['width'],
                      height: target['height'],
                    );
                  }).toList(),
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
