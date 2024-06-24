// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';

/* Checked */

class MemoryNumbersGame extends StatefulWidget {
  @override
  _MemoryNumbersGameState createState() => _MemoryNumbersGameState();
}

class _MemoryNumbersGameState extends State<MemoryNumbersGame> {
  List<String> cardImages = [];
  List<bool> cardFlips = [];
  List<bool> cardMatched = [];
  List<int> selectedCards = [];
  bool allowFlip = false;
  int level = 1;
  int pairsFound = 0;
  int maxLevel = 3;
  final databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    startLevel();
  }

  void _onGameComplete() async {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;

    if (studentId != null) {
      await databaseRepository.updateGameCompletionStatus(
          studentId, 'Nombres', [true, true, false]);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GameSelectionScreen(
                category: 'Nombres',
              )),
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

    Timer(Duration(seconds: 2), () {
      setState(() {
        cardFlips = List<bool>.filled(cardImages.length, true);
        Timer(Duration(seconds: 2), () {
          setState(() {
            cardFlips = List<bool>.filled(cardImages.length, false);
            allowFlip = true;
          });
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

  void onCardTap(int index) {
    if (allowFlip &&
        !cardFlips[index] &&
        selectedCards.length < 2 &&
        !cardMatched[index]) {
      setState(() {
        cardFlips[index] = true;
        selectedCards.add(index);
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
            if (pairsFound == cardImages.length ~/ 2) {
              levelUp();
            }
          });
        } else {
          Timer(Duration(seconds: 1), () {
            setState(() {
              cardFlips[firstIndex] = false;
              cardFlips[secondIndex] = false;
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
      } else {
        _onGameComplete();
      }
      startLevel();
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
              child: cardFlips[i] || cardMatched[i]
                  ? Image.asset(cardImages[i], fit: BoxFit.cover)
                  : Image.asset(
                      'assets/images/numbers/game3/cardback.png',
                      fit: BoxFit.cover,
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/numbers/game3/gamebg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
                onVolume: () {},
              ),
              ...buildRows(),
            ],
          ),
        ),
      ),
    );
  }
}
