import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/progress_bar.dart';

class AnimalNameGame extends StatefulWidget {
  @override
  _AnimalNameGameState createState() => _AnimalNameGameState();
}

class _AnimalNameGameState extends State<AnimalNameGame> {
  String missingVowel = "_";
  String targetVowel = "I";
  bool isCorrect = false;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/vocals/game3/background/bg_game3.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProgressBar(
                  backgroundColor: const Color(0xF2005BA7).withOpacity(0.8), 
                  progressBarColor: const Color(0xFF0BCC6C), 
                  headerText: "Completa el juego", 
                  progressValue: 1.0, 
                  onBack: () {
                    Navigator.pop(context);
                  }, 
                  onVolume: (){}),
                  Text(
                    'CH${missingVowel}N',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VowelTile(letter: 'A'),
                      VowelTile(letter: 'E'),
                      VowelTile(letter: 'I', dragging: true),
                      VowelTile(letter: 'O'),
                      VowelTile(letter: 'U'
                  ),
                    
          ],),
        ],
      )
    )
    ],
    ),
    );
  }
}

class VowelTile extends StatelessWidget {
  final String letter;
  final bool dragging;

  VowelTile({required this.letter, this.dragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(fontSize: 24, color: dragging ? Colors.grey : Colors.black),
        ),
      ),
      decoration: BoxDecoration(
        color: dragging ? Colors.white : Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          if (!dragging)
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
        ],
      ),
    );
  }
}
