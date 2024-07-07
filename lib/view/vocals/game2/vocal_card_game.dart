// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/view/button.dart';
import 'package:frenc_app/widgets/confetti_animation.dart';
import 'package:frenc_app/widgets/replay_popup.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:frenc_app/utils/user_tracking.dart'; // Importar UserTracking

class VocalMemoryPage extends StatefulWidget {
  const VocalMemoryPage({Key? key}) : super(key: key);

  @override
  State<VocalMemoryPage> createState() => _VocalMemoryPageState();
}

class _VocalMemoryPageState extends State<VocalMemoryPage>
    with TickerProviderStateMixin {
  bool _showConfetti = false;
  bool isBusy = false;

  List<String> allImages = [
    'assets/images/vocals/vocal/a.png',
    'assets/images/vocals/vocal/e.png',
    'assets/images/vocals/vocal/i.png',
    'assets/images/vocals/vocal/o.png',
    'assets/images/vocals/vocal/u.png',
    'assets/images/vocals/vocal/y.png',
  ];

  late List<String> cardImages;
  List<bool> cardsFlipped = [];
  List<int> flippedIndices = [];
  int score = 0;
  int round = 0;
  static const int totalRounds = 4;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _isLoading = true;

  final databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(8, (index) {
      return AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(controller);
    }).toList();

    _incrementTimesPlayed(); // Incrementar contador de juegos jugados
    _loadGame();
  }

  Future<void> _loadGame() async {
    _newGame();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
    AudioManager.background().stop();
  }

  void _incrementTimesPlayed() {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false)
          .incrementTimesPlayed(studentId, 'vocal_memory');
    }
  }

  void _incrementTimesCompleted() {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false)
          .incrementTimesCompleted(studentId, 'vocal_memory');
    }
  }

  void _onGameComplete() async {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      await databaseRepository.updateGameCompletionStatus(studentId, 'Voyelles',
          [true, true, false]); // Actualizar estado de juego
      _incrementTimesCompleted(); // Incrementar contador de juegos completados
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GameSelectionScreen(
                category: 'Voyelles',
              )),
    );
  }

  Future<void> playSound(String card) async {
    String soundPath;
    switch (card) {
      case 'assets/images/vocals/vocal/a.png':
        soundPath = 'sound/family/mere.m4a';
        break;
      case 'assets/images/vocals/vocal/e.png':
        soundPath = 'sound/family/mere.m4a';
        break;
      case 'assets/images/vocals/vocal/i.png':
        soundPath = 'sound/family/mere.m4a';
        break;
      case 'assets/images/vocals/vocal/o.png':
        soundPath = 'sound/family/mere.m4a';
        break;
      case 'assets/images/vocals/vocal/u.png':
        soundPath = 'sound/family/mere.m4a';
        break;
      case 'assets/images/vocals/vocal/y.png':
        soundPath = 'sound/family/mere.m4a';
        break;
      default:
        soundPath = 'sound/correct.mp3';
    }
    await AudioManager.effects().play(soundPath);
  }

  void _newGame() {
    setState(() {
      if (round < totalRounds) {
        round++;
        cardImages = _getRandomImages();
        cardImages.shuffle();
        cardsFlipped = List<bool>.filled(cardImages.length, false);
        flippedIndices = [];
        _showConfetti = false;
        isBusy = false;
        for (var controller in _controllers) {
          controller.reset();
        }
      } else {
        _showWinDialog();
      }
    });
  }

  List<String> _getRandomImages() {
    final random = Random();
    final selectedImages =
        (allImages.toList()..shuffle(random)).take(4).toList();
    return List.from(selectedImages)..addAll(selectedImages);
  }

  void _showWinDialog() {
    setState(() {
      _showConfetti = true;
      AudioManager.effects().play('sound/vocals/level_win.mp3');
    });
    showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          ReplayPopup(
            score: score,
            onReplay: () {
              setState(() {
                round = 0;
                score = 0;
                _newGame();
              });
            },
            onQuit: () {
              score = 0;
              _onGameComplete();
            },
          ),
          if (_showConfetti) ConfettiAnimation(animate: _showConfetti),
        ],
      ),
    );
  }

  void onCardTap(int index) {
    if (cardsFlipped[index] || isBusy) return;

    setState(() {
      cardsFlipped[index] = true;
      flippedIndices.add(index);
      _controllers[index].forward();

      if (flippedIndices.length == 2) {
        isBusy = true;
        if (cardImages[flippedIndices[0]] != cardImages[flippedIndices[1]]) {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              cardsFlipped[flippedIndices[0]] = false;
              cardsFlipped[flippedIndices[1]] = false;
              _controllers[flippedIndices[0]].reverse();
              _controllers[flippedIndices[1]].reverse();
              flippedIndices.clear();
              AudioManager.effects().play('sound/incorrect.mp3');
              isBusy = false;
              Future.delayed(const Duration(seconds: 2), () {
                AudioManager.effects().stop();
              });
            });
          });
        } else {
          playSound(cardImages[flippedIndices[0]]);
          Future.delayed(const Duration(seconds: 2), () {
            AudioManager.effects().stop();
            isBusy = false;
          });
          flippedIndices.clear();
        }
      }

      if (cardsFlipped.every((flipped) => flipped)) {
        score += 1;
        Future.delayed(const Duration(seconds: 2), () {
          _newGame();
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
                  headerText: 'Retournez les cartes et trouvez les paires',
                  progressValue: round / totalRounds,
                  onBack: () {
                    Navigator.pop(context);
                  },
                  onVolume: () {
                    // Acción para activar/desactivar el sonido
                  },
                ),
                _isLoading
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                                left: widthPadding, right: widthPadding),
                            itemCount: cardImages.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              mainAxisExtent: size.height * 0.30,
                            ),
                            itemBuilder: (context, index) {
                              return FadeInUp(
                                duration: const Duration(milliseconds: 500),
                                child: ClipRRect(
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
                                        final transform =
                                            Matrix4.rotationY(angle);
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
                                                  key: ValueKey<int>(
                                                      index + 100),
                                                  fit: BoxFit.fill,
                                                ),
                                        );
                                      },
                                    ),
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
          const Positioned(
            bottom: 10,
            right: 10,
            child: MovableButtonScreen(
              spanishAudio: 'sound/family/instruccionGame1.m4a',
              frenchAudio: 'sound/family/instruccionGame1.m4a',
              rivePath: 'assets/RiveAssets/vocalsgame2.riv',
            ),
          ),
        ],
      ),
    );
  }
}
