// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:math';
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
import 'package:frenc_app/utils/user_tracking.dart';
import 'package:frenc_app/utils/reward_manager.dart';
import 'package:frenc_app/utils/dialog_manager.dart';

class VocalMemoryPage extends StatefulWidget {
  const VocalMemoryPage({Key? key}) : super(key: key);

  @override
  State<VocalMemoryPage> createState() => _VocalMemoryPageState();
}

class _VocalMemoryPageState extends State<VocalMemoryPage>
    with TickerProviderStateMixin {
  bool _showConfetti = false;
  bool isBusy = false;
  bool _isPlayingSound = false;

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
    _playInstructionSound();
    _controllers = List.generate(8, (index) {
      return AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(controller);
    }).toList();

    _incrementTimesPlayed();
    _loadGame();
  }

  Future<void> _loadGame() async {
    _newGame();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
    AudioManager.background().stop();
  }

  Future<void> _playInstructionSound() async {
    await AudioManager.playBackground('sound/vocals/esgame2.m4a');
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
          [true, true, true]);
      _incrementTimesCompleted();

      RewardManager().unlockReward(1);
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const GameSelectionScreen(
                  category: 'Voyelles',
                )),
      );
    }
  }

  Future<void> playSound(String card) async {
    String soundPath;
    switch (card) {
      case 'assets/images/vocals/vocal/a.png':
        soundPath = 'sound/vocals/a.mp3';
        break;
      case 'assets/images/vocals/vocal/e.png':
        soundPath = 'sound/vocals/e.mp3';
        break;
      case 'assets/images/vocals/vocal/i.png':
        soundPath = 'sound/vocals/i.mp3';
        break;
      case 'assets/images/vocals/vocal/o.png':
        soundPath = 'sound/vocals/o.mp3';
        break;
      case 'assets/images/vocals/vocal/u.png':
        soundPath = 'sound/vocals/u.mp3';
        break;
      case 'assets/images/vocals/vocal/y.png':
        soundPath = 'sound/vocals/y.mp3';
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
    if (mounted) {
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
              overScore: 4,
              onReplay: () {
                if (mounted) {
                  setState(() {
                    round = 0;
                    score = 0;
                    _newGame();
                  });
                }
              },
              onQuit: () {
                if (mounted) {
                  setState(() {
                    score = 0;
                    round = 0;
                  });
                  _onGameComplete();
                }
              },
            ),
            if (_showConfetti) ConfettiAnimation(animate: _showConfetti),
          ],
        ),
      );
    }
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
            if (mounted) {
              setState(() {
                cardsFlipped[flippedIndices[0]] = false;
                cardsFlipped[flippedIndices[1]] = false;
                _controllers[flippedIndices[0]].reverse();
                _controllers[flippedIndices[1]].reverse();
                flippedIndices.clear();
                AudioManager.effects().play('sound/incorrect.mp3');
                isBusy = false;
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    AudioManager.effects().stop();
                  }
                });
              });
            }
          });
        } else {
          _playCorrectAnswerSounds(cardImages[flippedIndices[0]]);
          isBusy = false;
          flippedIndices.clear();
        }
      }

      if (cardsFlipped.every((flipped) => flipped)) {
        score += 1;
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _newGame();
          }
        });
      }
    });
  }

  Future<void> _playCorrectAnswerSounds(String audioFileName) async {
    if (mounted) {
      setState(() {
        _isPlayingSound = true;
      });
    }

    await AudioManager.effects().stop();
    await AudioManager.effects().play('sound/numbers/yeahf.mp3');
    await Future.delayed(const Duration(seconds: 2));
    await playSound(audioFileName);
    await Future.delayed(const Duration(seconds: 9));

    if (mounted) {
      setState(() {
        _isPlayingSound = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    AudioManager.stopBackground();
    AudioManager.stopEffect();
    DialogManager.showExitGameDialog(
      context,
      const GameSelectionScreen(category: 'Voyelles'),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * 0.1;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/vocals/card_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  ProgressBar(
                    backgroundColor: const Color(0xFF424141),
                    progressBarColor: const Color(0xFF8DB270),
                    headerText: 'Encuentra los pares de vocales',
                    progressValue: round / totalRounds,
                    onBack: () {
                      Navigator.pop(context);
                    },
                    backgroundMusic: 'sound/start_page.mp3',
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
                                          final angle = _animations[index]
                                                  .value *
                                              3.141592653589793;
                                          final isFlipped =
                                              angle >= 3.141592653589793 / 2;
                                          final transform =
                                              Matrix4.rotationY(isFlipped
                                                  ? 3.141592653589793
                                                  : angle);
                                          return Transform(
                                            transform: transform,
                                            alignment: Alignment.center,
                                            child: isFlipped
                                                ? _buildCardImage(index)
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
            if (_isPlayingSound)
              Container(
                color: Colors.black.withOpacity(0.8),
                child: const Center(
                  child: Icon(
                    Icons.volume_up,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            const Positioned(
              bottom: 10,
              right: 10,
              child: MovableButtonScreen(
                spanishAudio: 'sound/vocals/esgame2.m4a',
                frenchAudio: 'sound/vocals/frgame2.m4a',
                rivePath: 'assets/RiveAssets/vocalsgame2.riv',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(int index) {
    final image = cardImages[index];
    if (image == 'assets/images/vocals/vocal/e.png') {
      return Image.asset(
        image,
        fit: BoxFit.fill,
      );
    } else if (image == 'assets/images/vocals/vocal/i.png') {
      return Transform.scale(
        scaleX: 0.7, // Adjust the scale factor as needed
        child: Image.asset(
          image,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Image.asset(
        image,
        fit: BoxFit.fill,
      );
    }
  }
}
