import 'package:flutter/material.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/utils/confetti_animation.dart';
import 'package:frenc_app/utils/replay_popup.dart';
import 'package:frenc_app/widgets/progress_bar.dart';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({Key? key}) : super(key: key);

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage>
    with TickerProviderStateMixin {
  bool _showConfetti = false;

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
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(allImages.length, (index) {
      return AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(controller);
    }).toList();

    _newGame();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _newGame() {
    setState(() {
      cardImages = (allImages..shuffle()).take(4).toList();
      cardImages = List.from(cardImages)..addAll(cardImages);
      cardImages.shuffle();
      cardsFlipped = List<bool>.filled(cardImages.length, false);
      flippedIndices = [];
      _showConfetti = false; // Reset confetti on new game
      for (var controller in _controllers) {
        controller.reset();
      }
    });
  }

  void _showWinDialog() {
    setState(() {
      _showConfetti = true;
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
                _newGame();
              });
            },
          ),
          if (_showConfetti) ConfettiAnimation(animate: _showConfetti),
        ],
      ),
    );
  }

  void onCardTap(int index) {
    if (cardsFlipped[index]) return;

    setState(() {
      cardsFlipped[index] = true;
      flippedIndices.add(index);
      _controllers[index].forward();

      if (flippedIndices.length == 2) {
        if (cardImages[flippedIndices[0]] != cardImages[flippedIndices[1]]) {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              cardsFlipped[flippedIndices[0]] = false;
              cardsFlipped[flippedIndices[1]] = false;
              _controllers[flippedIndices[0]].reverse();
              _controllers[flippedIndices[1]].reverse();
              flippedIndices.clear();
              AudioManager().play('sound/incorrect.mp3');
              Future.delayed(const Duration(seconds: 2), () {
                AudioManager().stop();
              });
            });
          });
        } else {
          AudioManager().play('sound/correct.mp3');
          Future.delayed(const Duration(seconds: 2), () {
            AudioManager().stop();
          });
          flippedIndices.clear();
        }
      }

      if (cardsFlipped.every((flipped) => flipped)) {
        score += 1;
        Future.delayed(const Duration(seconds: 2), () {
          if (score < 1) {
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/family/game3/Verde.png'),
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
                    // Acción para activar/desactivar el sonido
                  },
                ),
                Expanded(
                  child: Center(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          left: widthPadding, right: widthPadding),
                      itemCount: cardImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: size.height * 0.30,
                      ),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: GestureDetector(
                            onTap: () => onCardTap(index),
                            child: AnimatedBuilder(
                              animation: _animations[index],
                              builder: (context, child) {
                                final angle = _animations[index].value *
                                    3.141592653589793;
                                final isFlipped =
                                    angle >= 3.141592653589793 / 2;
                                final transform = Matrix4.rotationY(angle);
                                return Transform(
                                  transform: transform,
                                  alignment: Alignment.center,
                                  child: isFlipped
                                      ? Image.asset(
                                          cardImages[index],
                                          key: ValueKey<int>(index),
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset(
                                          'assets/images/family/game3/Card.png',
                                          key: ValueKey<int>(index + 100),
                                          fit: BoxFit.fill,
                                        ),
                                );
                              },
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
          if (_showConfetti)
            Positioned.fill(
              child: ConfettiAnimation(animate: _showConfetti),
            ),
        ],
      ),
    );
  }
}
