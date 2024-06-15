import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frenc_app/utils/progress_bar.dart';
import 'package:frenc_app/utils/replay_popup.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Game',
      theme: ThemeData.light(useMaterial3: true),
      home: const FamilyGame(),
    );
  }
}

class FamilyGame extends StatefulWidget {
  const FamilyGame({super.key});

  @override
  State<FamilyGame> createState() => _FamilyGameState();
}

class _FamilyGameState extends State<FamilyGame> {
  late String cardUp;
  late List<String> cardsDown;
  int score = 0;
  bool roundCompleted = false;

  @override
  void initState() {
    super.initState();
    newGame();
  }

  void newGame() {
    List<String> images = [
      'assets/images/family/brother_caucasian.png',
      'assets/images/family/father_caucasian.png',
      'assets/images/family/sister_caucasian.png',
      'assets/images/family/mother_caucasian.png'
    ];

    cardUp = images[Random().nextInt(images.length)];

    // Ensure all cards are different and only one matches the cardUp
    cardsDown = images.where((image) => image != cardUp).toList();
    cardsDown.shuffle();
    cardsDown = cardsDown.take(3).toList();
    cardsDown.add(cardUp);
    cardsDown.shuffle();

    setState(() {});
  }

  void checkMatch(String selectedCard) {
    if (selectedCard == cardUp) {
      setState(() {
        score++;
        if (score >= 10) {
          _showWinDialog();
        } else {
          newGame();
        }
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => ReplayPopup(
        score: score,
        onReplay: () {
          setState(() {
            score = 0;
            newGame();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 118, 207, 191),
        ),
        child: Column(
          children: [
            ProgressBar(
              backgroundColor: const Color(0xFF424141),
              progressBarColor: const Color(0xFF8DB270),
              headerText:
                  'Sélectionnez l\'image qui ressemble à celle ci-dessus',
              progressValue: score / 10,
              onBack: () {
                // Acción para retroceder
              },
              onVolume: () {
                // Acción para controlar el volumen
              },
            ),
            const SizedBox(height: 20),
            BounceInDown(
              key: UniqueKey(), // Unique key to force rebuild
              child: Container(
                width: 90,
                height: 110,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(cardUp),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cardsDown.asMap().entries.map((entry) {
                int index = entry.key;
                String image = entry.value;
                Widget animatedImage;

                animatedImage = BounceInUp(
                  key: UniqueKey(),
                  child: buildImageCard(image),
                );

                return GestureDetector(
                  onTap: () => checkMatch(image),
                  child: animatedImage,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageCard(String image) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}
