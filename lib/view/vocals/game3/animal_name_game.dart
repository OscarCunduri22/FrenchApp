import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/progress_bar.dart';

class AnimalNameGame extends StatefulWidget {
  const AnimalNameGame({Key? key}) : super(key: key);

  @override
  State<AnimalNameGame> createState() => _AnimalNameGameState();
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
                image: AssetImage('assets/images/vocals/game3/background/bg_game3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                ProgressBar(
                  backgroundColor: const Color(0xF2005BA7).withOpacity(0.8),
                  progressBarColor: const Color(0xFF0BCC6C),
                  headerText: "Completa el juego",
                  progressValue: 1.0,
                  onBack: () {
                    Navigator.pop(context);
                  },
                  onVolume: () {},
                ),
                const SizedBox(height: 20),
                Container(
                  width: 90,
                  height: 110,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/vocals/game3/animals/dog.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'CH',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DragTarget<String>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 40,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            missingVowel,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      onWillAccept: (data) => true,
                      onAccept: (data) {
                        setState(() {
                          missingVowel = data;
                          isCorrect = (data == targetVowel);
                        });
                      },
                    ),
                    const Text(
                      'N',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Wrap(
                  spacing: 20, // Adjust the spacing as needed
                  alignment: WrapAlignment.center,
                  children: [
                    VowelTile(letter: 'A'),
                    VowelTile(letter: 'E'),
                    VowelTile(letter: 'I'),
                    VowelTile(letter: 'O'),
                    VowelTile(letter: 'U'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VowelTile extends StatelessWidget {
  final String letter;

  const VowelTile({required this.letter, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: letter,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(fontSize: 24, color: Colors.grey),
          ),
        ),
      ),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
