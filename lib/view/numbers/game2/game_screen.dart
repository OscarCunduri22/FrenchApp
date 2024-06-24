import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/game_provider.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/view_model/numbers/game2/game_provider.dart';
import 'package:frenc_app/widgets/numbers/game2/numbers_options.dart';
import 'package:frenc_app/widgets/numbers/game2/train_cart.dart';
import 'package:frenc_app/widgets/numbers/game2/train_engine.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/model/game_result.dart';

class TrainWagonNumbersGame extends StatefulWidget {
  @override
  _TrainWagonNumbersGameState createState() => _TrainWagonNumbersGameState();
}

class _TrainWagonNumbersGameState extends State<TrainWagonNumbersGame> {
  bool isOffScreenLeft = false;
  bool isOffScreenRight = false;
  bool isVisible = true;

  void _onGameComplete() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentStudentId = userProvider.currentStudentId;
    final gameProvider =
        Provider.of<GameStatusProvider>(context, listen: false);

    if (currentStudentId != null) {
      DatabaseRepository().saveGameResult(GameResult(
        studentId: currentStudentId,
        category: gameProvider.category,
        gameNumber: gameProvider.gameNumber,
        isCompleted: true,
      ));
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameSelectionScreen(category: 'Nombres'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentStudentId = userProvider.currentStudentId;

    return ChangeNotifierProvider(
      create: (context) => GameStatusProvider(
        studentId: currentStudentId!,
        category: 'Nombres',
        gameNumber: 1,
      ),
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
            // Game Content
            Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                if (gameProvider.isCompleted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      isOffScreenLeft = true;
                      isVisible = false;
                    });
                    Timer(const Duration(seconds: 1), () {
                      setState(() {
                        isVisible = false;
                        isOffScreenLeft = false;
                      });
                      Timer(const Duration(seconds: 1), () {
                        setState(() {
                          isVisible = false;
                          isOffScreenRight = true;
                        });
                        Timer(const Duration(seconds: 1), () {
                          setState(() {
                            isVisible = true;
                            isOffScreenRight = false;
                          });
                          _onGameComplete();
                        });
                      });
                    });
                  });
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProgressBar(
                      backgroundColor: const Color(0xF29B2929).withOpacity(0.8),
                      progressBarColor: const Color(0xFF0BCC6C),
                      headerText: 'Completa la secuencia de números',
                      progressValue: gameProvider.progressValue,
                      onBack: () {
                        Navigator.pop(context);
                      },
                      onVolume: () {},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: gameProvider.options
                          .map((number) => NumberOptionWidget(number: number))
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
                                      ? MediaQuery.of(context).size.width
                                      : 0),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: isVisible ? 1.0 : 0.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                            onComplete: _onGameComplete);
                                      } else {
                                        return TrainCar(
                                            number: number,
                                            onComplete: _onGameComplete);
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
