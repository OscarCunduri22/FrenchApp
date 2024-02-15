import 'dart:math';
import 'package:flutter/material.dart';

class FamilyGame extends StatefulWidget {
  const FamilyGame({super.key});

  @override
  State<FamilyGame> createState() => _FamilyGameState();
}

class _FamilyGameState extends State<FamilyGame> {
  late String cardUp;
  late String cardsDown;

  @override
  void initState() {
    super.initState();
    newGame();
  }

  void newGame() {
    List<String> images = [
      'assets/images/brother_caucasian.png',
      'assets/images/father_caucasian.png',
      'assets/images/sister_caucasian.png',
      'assets/images/mother_caucasian.png'
    ];

    cardUp = images[Random().nextInt(images.length)];

    cardsDown = images[Random().nextInt(images.length)];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color.fromARGB(255, 118, 207, 191);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Game'),
        backgroundColor: backgroundColor,
        toolbarHeight: 40,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: backgroundColor,
        ),
        // Code for the card goes up
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(cardUp),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            const SizedBox(height: 20),
            // Code for the cards goes down
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (String image in [
                  'assets/images/brother_caucasian.png',
                  'assets/images/father_caucasian.png',
                  'assets/images/sister_caucasian.png',
                  'assets/images/mother_caucasian.png'
                ])
                  GestureDetector(
                    child: Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
