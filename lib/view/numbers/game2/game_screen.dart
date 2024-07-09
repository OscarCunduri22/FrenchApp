// ignore_for_file: deprecated_member_use, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/utils/dialog_manager.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/utils/user_tracking.dart';
import 'package:frenc_app/view/button.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/view_model/numbers/game2/game_provider.dart';
import 'package:frenc_app/widgets/numbers/game2/numbers_options.dart';
import 'package:frenc_app/widgets/numbers/game2/train_cart.dart';
import 'package:frenc_app/widgets/numbers/game2/train_engine.dart';
import 'package:frenc_app/widgets/numbers/replay.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';

class TrainWagonNumbersGame extends StatefulWidget {
  const TrainWagonNumbersGame({super.key});

  @override
  _TrainWagonNumbersGameState createState() => _TrainWagonNumbersGameState();
}

class _TrainWagonNumbersGameState extends State<TrainWagonNumbersGame> {
  bool isOffScreenLeft = false;
  bool isOffScreenRight = false;
  bool isVisible = true;
  String soundInPath = 'assets/sound/in1.mp3';
  String soundOutPath = 'assets/sound/out.mp3';

  final databaseRepository = DatabaseRepository();
  Timer? _completionTimer;
  bool showReplayPopup = false;

  void _onGameComplete() async {
    AudioManager.effects().play('sound/level_win.mp3');
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;

    if (studentId != null) {
      await databaseRepository.updateGameCompletionStatus(
          studentId, 'Nombres', [true, false, false]);
    }

    setState(() {
      showReplayPopup = true;
    });
  }

  void _onQuit() async {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;

    if (studentId != null) {
      await databaseRepository.updateGameCompletionStatus(
          studentId, 'Nombres', [true, false, false]);
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

  @override
  void dispose() {
    _completionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? studentId = Provider.of<UserProvider>(context).currentStudentId;

    return ChangeNotifierProvider(
        create: (context) => GameProvider(
              Provider.of<UserTracking>(context, listen: false),
              studentId!,
            ),
        child: WillPopScope(
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
                      image: AssetImage(
                          'assets/images/numbers/game2/trainstation_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Consumer<GameProvider>(
                  builder: (context, gameProvider, child) {
                    if (gameProvider.isCompleted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _handleGameCompletion();
                      });
                    }
                    return Stack(
                      children: [
                        Opacity(
                          opacity: gameProvider.isPlayingSound ? 0.3 : 1.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProgressBar(
                                backgroundColor:
                                    const Color(0xF29B2929).withOpacity(0.8),
                                progressBarColor: const Color(0xFF0BCC6C),
                                headerText: 'Completa la secuencia de números',
                                progressValue: gameProvider.progressValue,
                                onBack: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return const GameSelectionScreen(
                                        category: 'Nombres',
                                      );
                                    },
                                  ));
                                },
                                backgroundMusic: 'sound/family/song2.mp3',
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: gameProvider.options
                                    .map((number) =>
                                        NumberOptionWidget(number: number))
                                    .toList(),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 160,
                                  alignment: Alignment.bottomCenter,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedPositioned(
                                        duration: const Duration(seconds: 1),
                                        left: isOffScreenLeft
                                            ? -MediaQuery.of(context).size.width
                                            : (isOffScreenRight
                                                ? MediaQuery.of(context)
                                                    .size
                                                    .width
                                                : 0),
                                        child: AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: isVisible ? 1.0 : 0.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              TrainEngine(),
                                              ...gameProvider.sequence
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                int idx = entry.key;
                                                int? number = entry.value;
                                                if (idx == 1) {
                                                  return TrainCar(
                                                      number: number,
                                                      isMiddle: true,
                                                      onComplete:
                                                          _onGameComplete);
                                                } else {
                                                  return TrainCar(
                                                      number: number,
                                                      onComplete:
                                                          _onGameComplete);
                                                }
                                              }).toList(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (gameProvider.isPlayingSound)
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
                            child: ReplayPopupForTrainGame(
                              score: gameProvider.currentLevel,
                              onQuit: _onQuit,
                            ),
                          ),
                        if (!gameProvider.isPlayingSound)
                          const MovableButtonScreen(
                            spanishAudio: 'sound/numbers/esgame1.m4a',
                            frenchAudio: 'sound/numbers/frgame1.m4a',
                            rivePath: 'assets/RiveAssets/nombresgame2.riv',
                          )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void _handleGameCompletion() async {
    await Future.delayed(const Duration(seconds: 7));
    if (!mounted) return;
    setState(() {
      isOffScreenLeft = true;
      isVisible = false;
    });
    _completionTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        isVisible = false;
        isOffScreenLeft = false;
      });
      _completionTimer = Timer(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          isVisible = false;
          isOffScreenRight = true;
        });
        _completionTimer = Timer(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() {
            isVisible = true;
            isOffScreenRight = false;
          });
        });
      });
    });
  }
}
