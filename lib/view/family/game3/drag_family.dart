import 'package:flutter/material.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/utils/replay_popup.dart';
import 'package:frenc_app/widgets/progress_bar.dart';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({Key? key}) : super(key: key);

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  final AudioManager _audioManager = AudioManager();

  List<String> allImages = [
    'assets/images/family/game3/aunt.jpg',
    'assets/images/family/game3/baby.jpg',
    'assets/images/family/game3/brother.jpg',
    'assets/images/family/game3/cousin.jpg',
    'assets/images/family/game3/cousinw.jpg',
    'assets/images/family/game3/father.jpg',
    'assets/images/family/game3/grandfather.jpg',
    'assets/images/family/game3/grandmother.jpg',
    'assets/images/family/game3/mother.jpg',
    'assets/images/family/game3/sister.jpg',
    'assets/images/family/game3/uncle.jpg',
  ];

  late List<String> cardImages;
  List<bool> cardsFlipped = [];
  List<int> flippedIndices = [];
  int score = 0;
  int gamesCompleted = 0;

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    setState(() {
      cardImages = (allImages..shuffle()).take(3).toList();
      cardImages = List.from(cardImages)..addAll(cardImages);
      cardImages.shuffle();
      cardsFlipped = List<bool>.filled(cardImages.length, false);
      flippedIndices = [];
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => ReplayPopup(
        score: score,
        onReplay: () {
          setState(() {
            score = 0;
            gamesCompleted = 0;
            _newGame();
          });
        },
      ),
    );
  }

  void onCardTap(int index) {
    setState(() {
      if (cardsFlipped[index]) return;
      cardsFlipped[index] = true;
      flippedIndices.add(index);

      if (flippedIndices.length == 2) {
        if (cardImages[flippedIndices[0]] != cardImages[flippedIndices[1]]) {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              cardsFlipped[flippedIndices[0]] = false;
              cardsFlipped[flippedIndices[1]] = false;
              flippedIndices.clear();
              _audioManager.play('sound/incorrect.mp3');
            });
          });
        } else {
          _audioManager.play('sound/correct.mp3');
          flippedIndices.clear();
        }
      }

      if (cardsFlipped.every((flipped) => flipped)) {
        score += 1;
        Future.delayed(const Duration(seconds: 2), () {
          if (gamesCompleted <= 10) {
            _newGame();
          } else {
            _showWinDialog();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * 0.1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/family/game3/Verde.png'), // Reemplaza con la ruta de tu imagen de fondo
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
            Expanded(
              child: Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.only(left: widthPadding, right: widthPadding),
                  itemCount: cardImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 70,
                    mainAxisSpacing: 10,
                    mainAxisExtent: size.height * 0.30,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: cardsFlipped[index]
                          ? Image.asset(
                              cardImages[index],
                              fit: BoxFit.fill,
                            )
                          : GestureDetector(
                              onTap: () => onCardTap(index),
                              child: Image.asset(
                                'assets/images/family/game3/Card.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
