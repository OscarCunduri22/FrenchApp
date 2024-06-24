import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/numbers/game2/game_screen.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';
import 'package:frenc_app/widgets/game_selection_card.dart';
import 'package:frenc_app/model/game_result.dart';
import 'package:provider/provider.dart';

class GameSelectionScreen extends StatelessWidget {
  final String category;

  GameSelectionScreen({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentStudentId = userProvider.currentStudentId;

    return Scaffold(
      body: currentStudentId == null
          ? Center(child: Text('No student selected'))
          : FutureBuilder<List<bool>>(
              future: _getGameCompletionStatus(currentStudentId, category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error loading game results'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No game data found'));
                }

                List<bool> gameCompletionStatus = snapshot.data!;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/global/cloudsbg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: Image.asset(
                                    'assets/images/icons/hacia-atras.png',
                                    width: 32,
                                    height: 32,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: CustomTextWidget(
                                  text: category,
                                  type: TextType.Subtitle,
                                  fontSize: 48,
                                  color: ColorType.Secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0),
                                    child: GameCard(
                                      gameNumber: index + 1,
                                      isUnlocked: gameCompletionStatus[index],
                                      onPlayPressed: () {
                                        if (index == 0 ||
                                            gameCompletionStatus[index - 1]) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return TrainWagonNumbersGame();
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }

  Future<List<bool>> _getGameCompletionStatus(
      String studentId, String category) async {
    List<bool> gameCompletionStatus = [true, false, false];

    QuerySnapshot snapshot =
        await DatabaseRepository().getGameResults(studentId, category).first;

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        GameResult gameResult =
            GameResult.fromJson(doc.data() as Map<String, dynamic>);
        if (gameResult.isCompleted) {
          gameCompletionStatus[gameResult.gameNumber - 1] = true;
          if (gameResult.gameNumber < 3) {
            gameCompletionStatus[gameResult.gameNumber] = true;
          }
        }
      }
    }

    return gameCompletionStatus;
  }
}
