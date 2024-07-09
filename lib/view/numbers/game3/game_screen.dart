// ignore_for_file: deprecated_member_use, sized_box_for_whitespace, use_build_context_synchronously, unused_element

import 'dart:async';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:frenc_app/utils/dialog_manager.dart';
import 'package:frenc_app/utils/user_tracking.dart';
import 'package:frenc_app/view/button.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:frenc_app/widgets/confetti_animation.dart';

class MemoryNumbersGame extends StatefulWidget {
  const MemoryNumbersGame({super.key});

  @override
  _MemoryNumbersGameState createState() => _MemoryNumbersGameState();
}

class _MemoryNumbersGameState extends State<MemoryNumbersGame>
    with TickerProviderStateMixin {
  List<String> cardImages = [];
  List<bool> cardFlips = [];
  List<bool> cardMatched = [];
  List<int> selectedCards = [];
  bool allowFlip = false;
  int level = 1;
  int pairsFound = 0;
  int maxLevel = 3;
  bool _showConfetti = false;
  bool _isPlayingSound = false;
  bool showReplayPopup = false;
  final databaseRepository = DatabaseRepository();
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6 * maxLevel, (index) {
      return AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(controller);
    }).toList();

    _incrementTimesPlayed();
    startLevel();
  }

  void _incrementTimesPlayed() {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false)
          .incrementTimesPlayed(studentId, 'memory_numbers_game');
    }
  }

  void _incrementTimesCompleted() {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false)
          .incrementTimesCompleted(studentId, 'memory_numbers_game');
    }
  }

  void _onGameComplete() async {
    await Future.delayed(const Duration(seconds: 6));
    setState(() {
      showReplayPopup = true;
    });
  }

  void _replayGame() {
    setState(() {
      showReplayPopup = false;
      level = 1;
      startLevel();
    });
  }

  void _onQuit() async {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;

    if (studentId != null) {
      await databaseRepository.updateGameCompletionStatus(
          studentId, 'Nombres', [true, true, false]);
      _incrementTimesPlayed();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const GameSelectionScreen(
          category: 'Nombres',
        ),
      ),
    );
  }

  void startLevel() {
    setState(() {
      pairsFound = 0;
      allowFlip = false;
      cardImages = generateCardImages(level);
      cardFlips = List<bool>.filled(cardImages.length, false);
      cardMatched = List<bool>.filled(cardImages.length, false);
      selectedCards = [];
    });

    for (var controller in _controllers) {
      controller.reset();
    }

    setState(() {
      cardFlips = List<bool>.filled(cardImages.length, true);
      Timer(const Duration(seconds: 2), () {
        setState(() {
          cardFlips = List<bool>.filled(cardImages.length, false);
          allowFlip = true;
        });
      });
    });
  }

  List<String> generateCardImages(int level) {
    List<String> images = [];
    for (int i = 1; i <= level * 2; i++) {
      images.add('assets/images/numbers/game3/number$i.png');
      images.add('assets/images/numbers/game3/number$i-pair.png');
    }
    images.shuffle(Random());
    return images;
  }

  void onCardTap(int index) async {
    if (allowFlip &&
        !cardFlips[index] &&
        selectedCards.length < 2 &&
        !cardMatched[index]) {
      setState(() {
        cardFlips[index] = true;
        selectedCards.add(index);
        _controllers[index].forward();
      });

      if (selectedCards.length == 2) {
        int firstIndex = selectedCards[0];
        int secondIndex = selectedCards[1];
        String firstImage = cardImages[firstIndex];
        String secondImage = cardImages[secondIndex];

        if (firstImage.replaceFirst('-pair', '') ==
            secondImage.replaceFirst('-pair', '')) {
          setState(() {
            cardMatched[firstIndex] = true;
            cardMatched[secondIndex] = true;
            pairsFound++;
            selectedCards.clear();
            _playCorrectAnswerSounds(firstImage);
            if (pairsFound == cardImages.length ~/ 2) {
              Timer(const Duration(seconds: 2), levelUp);
            }
          });
        } else {
          await AudioManager.effects().play('sound/incorrect.mp3');
          Timer(const Duration(seconds: 1), () {
            setState(() {
              cardFlips[firstIndex] = false;
              cardFlips[secondIndex] = false;
              _controllers[firstIndex].reverse();
              _controllers[secondIndex].reverse();
              selectedCards.clear();
            });
          });
        }
      }
    }
  }

  void levelUp() {
    setState(() {
      if (level < maxLevel) {
        level++;
        startLevel();
      } else {
        _showWinDialog();
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
          ReplayPopupForThreeLevels(
            score: level,
            onReplay: _replayGame,
            onQuit: _onQuit,
          ),
          if (_showConfetti) ConfettiAnimation(animate: _showConfetti),
        ],
      ),
    );
  }

  Future<void> _playCorrectAnswerSounds(String imagePath) async {
    setState(() {
      _isPlayingSound = true;
    });

    String number =
        imagePath.split('/').last.replaceAll(RegExp(r'number|-pair|\.png'), '');

    await AudioManager.effects().stop();
    await AudioManager.effects().play('sound/numbers/yeahf.mp3');
    await Future.delayed(const Duration(seconds: 1));
    await AudioManager.effects().play('sound/numbers/repetir.m4a');
    await Future.delayed(const Duration(seconds: 2));
    await AudioManager.effects().play('sound/numbers/$number.m4a');
    await Future.delayed(const Duration(seconds: 2));
    await AudioManager.effects().play('sound/numbers/$number.m4a');
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isPlayingSound = false;
    });
  }

  List<Widget> buildRows() {
    List<Widget> rows = [];
    int cardsPerRow = level == 3 ? 6 : 4;
    double cardWidth = 150;
    double cardHeight = 122;

    if (level == 3) {
      cardWidth = 120;
      cardHeight = 102;
    }

    for (int i = 0; i < cardImages.length; i += cardsPerRow) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildRow(i, min(cardsPerRow, cardImages.length - i),
              cardWidth, cardHeight),
        ),
      );
      rows.add(const SizedBox(height: 10));
    }
    return rows;
  }

  List<Widget> buildRow(
      int startIndex, int count, double cardWidth, double cardHeight) {
    List<Widget> rowChildren = [];
    for (int i = startIndex; i < startIndex + count; i++) {
      rowChildren.add(
        GestureDetector(
          onTap: () => onCardTap(i),
          child: Container(
            width: cardWidth,
            height: cardHeight,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: AnimatedBuilder(
                animation: _animations[i],
                builder: (context, child) {
                  final angle = _animations[i].value * pi;
                  final isFlipped = angle >= pi / 2;
                  final transform = Matrix4.rotationY(angle);
                  return Transform(
                    transform: transform,
                    alignment: Alignment.center,
                    child: isFlipped
                        ? Image.asset(
                            cardImages[i],
                            key: ValueKey<int>(i),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/numbers/game3/cardback.png',
                            key: ValueKey<int>(i + 100),
                            fit: BoxFit.cover,
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
    return rowChildren;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          DialogManager.showExitGameDialog(
              context,
              const GameSelectionScreen(
                category: 'Nombres',
              ));
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/numbers/game3/gamebg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Stack(
                  children: [
                    Opacity(
                      opacity: _isPlayingSound ? 0.3 : 1.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProgressBar(
                            backgroundColor: const Color(0xFFFF5F01),
                            progressBarColor: const Color(0xFF8DB270),
                            headerText: 'Completa la secuencia de números',
                            progressValue: (level - 1) / maxLevel,
                            onBack: () {
                              Navigator.pop(context);
                            },
                            backgroundMusic: 'sound/family/song1.mp3',
                          ),
                          ...buildRows(),
                        ],
                      ),
                    ),
                    if (!_isPlayingSound)
                      const Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: MovableButtonScreen(
                            spanishAudio: 'sound/numbers/esgame2.m4a',
                            frenchAudio: 'sound/numbers/frgame2.m4a',
                            rivePath: 'assets/RiveAssets/nombresgame3.riv',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (_isPlayingSound)
                Container(
                  color: Colors.black.withOpacity(0.8),
                  child: const Center(
                    child: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              if (showReplayPopup)
                Container(
                  color: Colors.black.withOpacity(0.8),
                  child: ReplayPopupForThreeLevels(
                    score: level,
                    onReplay: _replayGame,
                    onQuit: _onQuit,
                  ),
                ),
            ],
          ),
        ));
  }
}

class ReplayPopupForThreeLevels extends StatelessWidget {
  final int score;
  final VoidCallback onReplay;
  final VoidCallback onQuit;

  const ReplayPopupForThreeLevels({
    Key? key,
    required this.score,
    required this.onReplay,
    required this.onQuit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
                      children: List.generate(3, (index) {
                        return ShakeY(
                          from: 10,
                          infinite: true,
                          child: Star(
                            filled: index < score,
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
                              value: score / 3,
                              backgroundColor: Colors.grey[300],
                              color: Colors.blue,
                              minHeight: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$score/3',
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
                            onReplay();
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
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            onQuit();
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
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
