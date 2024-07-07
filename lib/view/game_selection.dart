// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/game_navigator.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/category_selection.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';
import 'package:frenc_app/widgets/game_selection_card.dart';
import 'package:provider/provider.dart';

class GameSelectionScreen extends StatefulWidget {
  final String category;

  const GameSelectionScreen({
    super.key,
    required this.category,
  });

  @override
  _GameSelectionScreenState createState() => _GameSelectionScreenState();
}

class _GameSelectionScreenState extends State<GameSelectionScreen> {
  List<bool> gameCompletionStatus = [false, false, false];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchGameCompletionStatus();
  }

  Future<void> _fetchGameCompletionStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentStudentId = userProvider.currentStudentId;

    if (currentStudentId != null) {
      try {
        List<bool> status = await DatabaseRepository()
            .getGameCompletionStatusByCategory(
                currentStudentId, widget.category);

        if (status.isEmpty) {
          status = [false, false, false];
        }

        setState(() {
          gameCompletionStatus = status;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          errorMessage = 'Error loading game results';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'No student selected';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CategorySelectionScreen(),
          ),
        );
        return false;
      },
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/global/cloudsbg.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    'assets/images/icons/hacia-atras.png',
                                    width: 32,
                                    height: 32,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CategorySelectionScreen(),
                                      ),
                                    );
                                  },
                                ),
                                CustomTextWidget(
                                  text: widget.category,
                                  type: TextType.Subtitle,
                                  fontSize: 48,
                                  color: ColorType.Secondary,
                                ),
                                const SizedBox(width: 32),
                              ],
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double cardWidth =
                                    (constraints.maxWidth - 128) / 3;
                                double cardHeight = constraints.maxHeight - 64;

                                return Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: List.generate(3, (index) {
                                      bool isUnlocked = (index == 0) ||
                                          (index == 1 &&
                                              gameCompletionStatus[0]) ||
                                          (index == 2 &&
                                              gameCompletionStatus[0] &&
                                              gameCompletionStatus[1]);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: GameCard(
                                          category: widget.category,
                                          gameNumber: index + 1,
                                          isUnlocked: isUnlocked,
                                          onPlayPressed: () async {
                                            if (isUnlocked) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return getGameScreen(
                                                        widget.category,
                                                        index + 1);
                                                  },
                                                ),
                                              );
                                            }
                                          },
                                          width: cardWidth,
                                          height: cardHeight,
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}
