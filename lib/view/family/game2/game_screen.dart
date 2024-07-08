// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/button.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/widgets/confetti_animation.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:frenc_app/widgets/replay_popup.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_tracking.dart'; // Importar UserTracking

class GatherFamilyGame extends StatefulWidget {
  const GatherFamilyGame({Key? key}) : super(key: key);

  @override
  State<GatherFamilyGame> createState() => _GatherFamilyGameState();
}

class _GatherFamilyGameState extends State<GatherFamilyGame> {
  final Map<String, String> imageMappings = {
    'mother': 'assets/images/family/game2/mother.png',
    'sister': 'assets/images/family/game2/sister.png',
    'father': 'assets/images/family/game2/father.png',
    'son': 'assets/images/family/game2/brother.png',
    'grandmother': 'assets/images/family/game2/grandmother.png',
    'grandfather': 'assets/images/family/game2/grandfather.png',
  };

  final Map<String, String> siluetImages = {
    'mother': 'assets/images/family/game2/smother.png',
    'sister': 'assets/images/family/game2/ssister.png',
    'father': 'assets/images/family/game2/sfather.png',
    'son': 'assets/images/family/game2/sbrother.png',
    'grandmother': 'assets/images/family/game2/sgrandmother.png',
    'grandfather': 'assets/images/family/game2/sgrandfather.png',
  };

  final Map<String, String> soundMappings = {
    'mother': 'sound/family/mere.m4a',
    'sister': 'sound/family/soeur.m4a',
    'father': 'sound/family/pere.m4a',
    'son': 'sound/family/frere.m4a',
    'grandmother': 'sound/family/grandmere.m4a',
    'grandfather': 'sound/family/grandpere.m4a',
  };

  late List<String> selectedKeys;
  Map<String, String> placedImages = {};
  int score = 0;
  bool _showConfetti = false;
  bool _isPlayingSound = false;

  final databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    newGame();
    AudioManager.playBackground('sound/family/song220.mp3');
    AudioManager.playEffect('sound/family/instruccionJuego2.m4a');
  }

  void _incrementTimesCompleted() {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false)
          .incrementTimesCompleted(studentId, 'gather_family_game');
    }
  }

  @override
  void dispose() {
    super.dispose();
    AudioManager.background().stop();
  }

  void _onGameComplete() async {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;

    if (studentId != null) {
      await databaseRepository
          .updateGameCompletionStatus(studentId, 'Famille', [true, true, true]);
      _incrementTimesCompleted(); // Incrementar contador de juegos completados
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GameSelectionScreen(
                category: 'Famille',
              )),
    );
  }

  void newGame() {
    selectedKeys = imageMappings.keys.toList();
    selectedKeys.shuffle(Random());
    selectedKeys = selectedKeys.take(4).toList();
    placedImages.clear();
    setState(() {
      _showConfetti = false;
    });
  }

  Future<void> playSound(String key, bool correct) async {
    String soundPath;
    if (correct) {
      soundPath = soundMappings[key]!;
    } else {
      soundPath = 'sound/error.mp3';
    }
    await AudioManager.effects().play(soundPath);
  }

  void checkMatch(String key, String data) async {
    bool correct = data == imageMappings[key];
    await playSound(key, correct);
    if (correct) {
      _playCorrectAnswerSounds(key);
      setState(() {
        placedImages[key] = data;
        if (placedImages.length == selectedKeys.length) {
          setState(() {
            score++;
            if (score >= 1) {
              Future.delayed(const Duration(seconds: 8), () {
                _showWinDialog();
              });
            } else {
              Future.delayed(const Duration(seconds: 2), () {
                newGame();
              });
            }
          });
        }
      });
    } else {
      await playSound(key, false);
    }
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
                newGame();
                score = 0;
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

  Future<void> _playCorrectAnswerSounds(String audioFileName) async {
    setState(() {
      _isPlayingSound = true;
    });

    await AudioManager.effects().play('sound/numbers/yeahf.mp3');
    await Future.delayed(const Duration(seconds: 1));
    await AudioManager.effects().play('sound/numbers/repetir.m4a');
    await Future.delayed(const Duration(seconds: 2));
    await playSound(audioFileName, true);
    await Future.delayed(const Duration(seconds: 3));
    await playSound(audioFileName, true);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isPlayingSound = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/family/game2/draganddrop.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                ProgressBar(
                  backgroundColor: const Color(0xFF424141),
                  progressBarColor: const Color(0xFFD67171),
                  headerText: 'Encuentra la ubicación correcta del familiar',
                  progressValue: score / 10,
                  onBack: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameSelectionScreen(
                          category: 'Famille',
                        ),
                      ),
                    );
                  },
                  onVolume: () {
                    // Acción para controlar el volumen
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      buildDragTargetsRow(),
                    ],
                  ),
                ),
              ],
            ),
            ...buildRemainingDraggableImages(),
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
            const MovableButtonScreen(
              spanishAudio: 'sound/family/instruccionJuego2.m4a',
              frenchAudio: 'sound/family/instruccionGame2.m4a',
              rivePath: 'assets/RiveAssets/familygame2.riv',
            )
          ],
        ),
      ),
    );
  }

  Widget buildDragTargetsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 160.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: selectedKeys.map((key) {
          String silueta = siluetImages[key]!;
          double width = 100;
          double height = 160;

          if (key == 'sister' || key == 'son') {
            height = 130;
          }

          if (key == 'grandmother' || key == 'grandfather') {
            height = 150;
          }

          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: buildDragTarget(key,
                silueta: silueta, width: width, height: height),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> buildRemainingDraggableImages() {
    return selectedKeys
        .where((key) => !placedImages.containsValue(imageMappings[key]!))
        .map((key) {
      String image = imageMappings[key]!;
      int index = selectedKeys.indexOf(key);

      double left;
      double top;

      switch (index) {
        case 0:
          left = 0;
          top = 0;
          break;
        case 1:
          left = MediaQuery.of(context).size.width - 120;
          top = 0;
          break;
        case 2:
          left = 0;
          top = MediaQuery.of(context).size.height - 280;
          break;
        case 3:
          left = MediaQuery.of(context).size.width - 120;
          top = MediaQuery.of(context).size.height - 280;
          break;
        default:
          left = 0;
          top = 0;
      }

      return Positioned(
        left: left,
        top: top,
        child: buildDraggable(image),
      );
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

  Widget buildDragTarget(String target,
      {required String silueta,
      required double width,
      required double height}) {
    return DragTarget<String>(
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
      onWillAccept: (data) => true,
      onAccept: (data) {
        checkMatch(target, data);
      },
    );
  }
}
