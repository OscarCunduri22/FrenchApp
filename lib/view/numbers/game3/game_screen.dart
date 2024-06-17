import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    startLevel();
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
      level++;
      if (level > 3) {
        level = 1;
      }
      startLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = 100; // Manually set card width
    final double cardHeight = 150; // Manually set card height

    List<Widget> buildRow(int startIndex, int count) {
      List<Widget> rowChildren = [];
      for (int i = startIndex; i < startIndex + count; i++) {
        rowChildren.add(
          GestureDetector(
            onTap: () => onCardTap(i),
            child: Card(
              child: cardFlips[i] || cardMatched[i]
                  ? Image.asset(cardImages[i], fit: BoxFit.cover)
                  : Image.asset(
                      'assets/images/numbers/game3/cardback.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        );
      }
      return rowChildren;
    }

    final int totalCards = cardImages.length;
    final int halfCards = (totalCards / 2).ceil();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Level $level',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildRow(0, halfCards),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildRow(halfCards, totalCards - halfCards),
            ),
          ],
        ),
      ),
    );
  }
}
