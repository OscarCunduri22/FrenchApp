import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frenc_app/widgets/confetti_animation.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:frenc_app/widgets/replay_popup.dart';
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
  String? selectedIncorrectCard;
  bool showBounceAnimation = true;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    newGame();
    AudioManager.effects().play('sound/family/instruccionGame1.m4a');
  }

  @override
  void dispose() {
    super.dispose();
    AudioManager.background().stop();
  }

  void newGame() {
    selectedIncorrectCard = null;
    showBounceAnimation = true;
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
    cardsDown = images.where((image) => image != cardUp).toList();
    cardsDown.shuffle();
    cardsDown = cardsDown.take(3).toList();
    cardsDown.add(cardUp);
    cardsDown.shuffle();

    setState(() {
      _showConfetti = false;
    });
  }

  void checkMatch(String selectedCard) async {
    if (selectedCard == cardUp) {
      await playSound(selectedCard);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          score++;
          if (score >= 10) {
            _showWinDialog();
          } else {
            newGame();
          }
        });
      });
    } else {
      await playSound(selectedCard);
      Future.delayed(const Duration(seconds: 2), () {
        AudioManager.effects().stop();
      });
      setState(() {
        selectedIncorrectCard = selectedCard;
        showBounceAnimation = false;
      });
    }
  }

  Future<void> playSound(String card) async {
    String soundPath;
    switch (card) {
      case 'assets/images/family/game1/mother.jpg':
        soundPath = 'sound/family/mere.m4a';
        break;
      case 'assets/images/family/game1/father.jpg':
        soundPath = 'sound/family/pere.m4a';
        break;
      case 'assets/images/family/game1/parents.jpg':
        soundPath = 'sound/family/parentes.m4a';
        break;
      case 'assets/images/family/game1/parents2.jpg':
        soundPath = 'sound/family/parentes.m4a';
        break;
      case 'assets/images/family/game1/brother.jpg':
        soundPath = 'sound/family/frere.m4a';
        break;
      case 'assets/images/family/game1/brothers.jpg':
        soundPath = 'sound/family/freres.m4a';
        break;
      case 'assets/images/family/game1/grandfather.jpg':
        soundPath = 'sound/family/grandpere.m4a';
        break;
      case 'assets/images/family/game1/grandmother.jpg':
        soundPath = 'sound/family/grandmere.m4a';
        break;
      case 'assets/images/family/game1/grandparents.jpg':
        soundPath = 'sound/family/grandsparents.m4a';
        break;
      case 'assets/images/family/game1/sister.jpg':
        soundPath = 'sound/family/soeur.m4a';
        break;
      case 'assets/images/family/game1/sisters.jpg':
        soundPath = 'sound/family/soeurs.m4a';
        break;
      case 'assets/images/family/game1/siblings.jpg':
        soundPath = 'sound/family/freresetsoeurs.m4a';
        break;
      default:
        soundPath = 'sound/correct.mp3';
    }
    await AudioManager.effects().play(soundPath);
  }

  void _showWinDialog() {
    setState(() {
      _showConfetti = true;
      AudioManager.effects().play('sound/family/level_win.mp3');
    });
    showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          ReplayPopup(
            score: score,
            onReplay: () {
              setState(() {
                score = 0;
                newGame();
              });
            },
          ),
          if (_showConfetti) ConfettiAnimation(animate: _showConfetti),
        ],
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
              backgroundColor: const Color.fromARGB(255, 36, 18, 58),
              progressBarColor: const Color.fromARGB(255, 90, 65, 156),
              headerText:
                  'Sélectionnez la photo de famille comme celle ci-dessus',
              progressValue: score / 10,
              onBack: () {
                // Acción para retroceder
              },
              onVolume: () {
                // Acción para controlar el volumen
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedIncorrectCard == null)
                  JelloIn(
                    key: UniqueKey(),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(cardUp),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(cardUp),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(width: 20),
                PlayButton(
                  onPressed: () async {
                    await playSound(cardUp);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cardsDown.map((image) {
                Widget animatedImage;

                if (selectedIncorrectCard == image) {
                  animatedImage = ShakeX(
                    key: UniqueKey(),
                    duration: const Duration(milliseconds: 500),
                    from: Checkbox.width / 2,
                    child: buildImageCard(image),
                  );
                } else {
                  animatedImage = showBounceAnimation
                      ? JelloIn(
                          key: UniqueKey(),
                          child: buildImageCard(image),
                        )
                      : buildImageCard(image);
                }

                return GestureDetector(
                  onTap: () => checkMatch(image),
                  child: animatedImage,
                );
              }).toList(),
            ),
            if (_showConfetti)
              Positioned.fill(
                child: ConfettiAnimation(animate: _showConfetti),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildImageCard(String image) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  final VoidCallback onPressed;

  const PlayButton({super.key, required this.onPressed});

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: _isPressed ? 55 : 60,
        height: _isPressed ? 55 : 60,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 218, 218, 218),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/images/icons/sonido.png',
            width: 50, // Ajusta el tamaño de la imagen según sea necesario
            height: 50,
          ),
        ),
      ),
    );
  }
}
