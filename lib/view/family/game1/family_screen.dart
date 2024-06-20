import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:frenc_app/utils/replay_popup.dart';
import 'package:frenc_app/utils/audio_manager.dart';

class FindFamilyGame extends StatefulWidget {
  const FindFamilyGame({super.key});

  @override
  State<FindFamilyGame> createState() => _FindFamilyGameState();
}

class _FindFamilyGameState extends State<FindFamilyGame> {
  late String cardUp;
  late List<String> cardsDown;
  int score = 0;
  bool roundCompleted = false;
  final AudioManager _audioManager = AudioManager();

  @override
  void initState() {
    super.initState();
    newGame();
  }

  @override
  void dispose() {
    _audioManager.dispose();
    super.dispose();
  }

  void newGame() {
    List<String> images = [
      'assets/images/family/game1/mother.jpg',
      'assets/images/family/game1/father.jpg',
      'assets/images/family/game1/parents.jpg',
      'assets/images/family/game1/parents2.jpg',
      'assets/images/family/game1/brother.jpg',
      'assets/images/family/game1/brothers.jpg',
      'assets/images/family/game1/grandfather.jpg',
      'assets/images/family/game1/grandmother.jpg',
      'assets/images/family/game1/grandparents.jpg',
      'assets/images/family/game1/sister.jpg',
      'assets/images/family/game1/sisters.jpg',
      'assets/images/family/game1/siblings.jpg',
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

  void checkMatch(String selectedCard) async {
    if (selectedCard == cardUp) {
      await _audioManager.play('sound/correct.mp3');
      // await playSound(selectedCard);
      setState(() {
        score++;
        if (score >= 10) {
          _showWinDialog();
        } else {
          newGame();
        }
      });
    } else {
      await _audioManager.play('sound/incorrect.mp3');
    }
  }

  Future<void> playSound(String card) async {
    String soundPath;
    switch (card) {
      case 'assets/images/family/mother.jpg':
        soundPath = 'assets/sounds/mother.mp3';
        break;
      case 'assets/images/family/father.jpg':
        soundPath = 'assets/sounds/father.mp3';
        break;
      case 'assets/images/family/parents.jpg':
        soundPath = 'assets/sounds/parents.mp3';
        break;
      case 'assets/images/family/parents2.jpg':
        soundPath = 'assets/sounds/parents.mp3';
        break;
      case 'assets/images/family/brother.jpg':
        soundPath = 'assets/sounds/brother.mp3';
        break;
      case 'assets/images/family/brothers.jpg':
        soundPath = 'assets/sounds/brothers.mp3';
        break;
      case 'assets/images/family/grandfather.jpg':
        soundPath = 'assets/sounds/grandfather.mp3';
        break;
      case 'assets/images/family/grandmother.jpg':
        soundPath = 'assets/sounds/grandmother.mp3';
        break;
      case 'assets/images/family/grandparents.jpg':
        soundPath = 'assets/sounds/grandparents.mp3';
        break;
      case 'assets/images/family/sister.jpg':
        soundPath = 'assets/sounds/sister.mp3';
        break;
      case 'assets/images/family/sisters.jpg':
        soundPath = 'assets/sounds/sisters.mp3';
        break;
      case 'assets/images/family/siblings.jpg':
        soundPath = 'assets/sounds/siblings.mp3';
        break;
      default:
        soundPath = 'assets/sounds/error.mp3';
    }

    await _audioManager.play(soundPath);
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
          image: DecorationImage(
            image: AssetImage('assets/images/family/game1/Morado.png'),
            fit: BoxFit.cover,
          ),
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
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cardsDown.asMap().entries.map((entry) {
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
      width: 90,
      height: 110,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
