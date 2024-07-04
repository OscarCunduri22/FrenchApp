import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_tracking.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/widgets/confetti_animation.dart';
import 'package:frenc_app/widgets/replay_popup.dart';
import 'package:frenc_app/view/button.dart';

class AnimalNameGame extends StatefulWidget {
  const AnimalNameGame({Key? key}) : super(key: key);

  @override
  State<AnimalNameGame> createState() => _AnimalNameGameState();
}

class _AnimalNameGameState extends State<AnimalNameGame> {
  final List<Map<String, String>> animals = [
    {'name': 'che_n', 'image': 'dog.png', 'targetVowel': 'I'},
    {'name': 'ch_t', 'image': 'cat.png', 'targetVowel': 'A'},
    {'name': 'ch_chon', 'image': 'pig.png', 'targetVowel': 'O'},
    {'name': 'vach_', 'image': 'cow.png', 'targetVowel': 'E'},
    {'name': '_urs', 'image': 'bear.png', 'targetVowel': 'O'},
    {'name': 'l_nx', 'image': 'lynx.png', 'targetVowel': 'Y'},
  ];

  final List<String> vowels = ['A', 'E', 'I', 'O', 'U', 'Y'];
  final List<String> vowelImages = [
    'assets/images/vocals/vocal/a.png',
    'assets/images/vocals/vocal/e.png',
    'assets/images/vocals/vocal/i.png',
    'assets/images/vocals/vocal/o.png',
    'assets/images/vocals/vocal/u.png',
    'assets/images/vocals/vocal/y.png',
  ];

  int currentAnimalIndex = 0;
  String missingVowel = "_";
  bool isCorrect = false;
  bool _showConfetti = false;
  late List<String> currentVowelChoices;

  final databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    _incrementTimesPlayed();
    _loadNewVowelChoices();
  }

  void _incrementTimesPlayed() {
    String? studentId = Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false).incrementTimesPlayed(studentId, 'animal_name_game');
    }
  }

  void _incrementTimesCompleted() {
    String? studentId = Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false).incrementTimesCompleted(studentId, 'animal_name_game');
    }
  }

  void _onGameComplete() async {
    String? studentId = Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      await databaseRepository.updateGameCompletionStatus(
          studentId, 'Voyelles', [true, true, true]);
      _incrementTimesCompleted(); 
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GameSelectionScreen(
                category: 'Voyelles',
              )),
    );
  }

  void _loadNewVowelChoices() {
    final random = Random();
    final targetVowel = animals[currentAnimalIndex]['targetVowel']!;
    List<String> choices = [targetVowel];

    while (choices.length < 3) {
      String randomVowel = vowels[random.nextInt(vowels.length)];
      if (!choices.contains(randomVowel)) {
        choices.add(randomVowel);
      }
    }

    choices.shuffle();
    currentVowelChoices = choices;
  }

  @override
  Widget build(BuildContext context) {
    final currentAnimal = animals[currentAnimalIndex];
    final animalName = currentAnimal['name']!;
    final animalImage = currentAnimal['image']!;
    final targetVowel = currentAnimal['targetVowel']!;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ProgressBar(
                backgroundColor: const Color(0xF2005BA7).withOpacity(0.8),
                progressBarColor: const Color(0xFF0BCC6C),
                headerText: "Completa el juego",
                progressValue: (currentAnimalIndex + 1) / animals.length,
                onBack: () {
                  Navigator.pop(context);
                },
                onVolume: () {},
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/vocals/game3/background/bg_game3.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            width: 90,
                            height: 110,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/vocals/game3/animals/$animalImage'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildOutlinedText(animalName.split('_')[0]),
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
                                    child: _buildOutlinedText(missingVowel),
                                  );
                                },
                                onWillAccept: (data) => true,
                                onAccept: (data) {
                                  setState(() {
                                    missingVowel = data!;
                                    isCorrect = (data == targetVowel);
                                    if (isCorrect) {
                                      Future.delayed(const Duration(seconds: 1), () {
                                        setState(() {
                                          if (currentAnimalIndex < animals.length - 1) {
                                            currentAnimalIndex++;
                                            missingVowel = "_";
                                            isCorrect = false;
                                            _loadNewVowelChoices();
                                          } else {
                                            _showWinDialog();
                                          }
                                        });
                                      });
                                    }
                                  });
                                },
                              ),
                              _buildOutlinedText(animalName.split('_')[1]),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 30,
                            alignment: WrapAlignment.center,
                            children: currentVowelChoices.map((vowel) {
                              final vowelImage = vowelImages[vowels.indexOf(vowel)];
                              return VowelTile(
                                letter: vowel,
                                imagePath: vowelImage,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: MovableButtonScreen(
              spanishAudio: 'sound/family/instruccionGame1.m4a',
              frenchAudio: 'sound/family/instruccionGame1.m4a',
              rivePath: 'assets/RiveAssets/vocalsgame1.riv',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedText(String text) {
    List<Widget> letters = [];
    for (var i = 0; i < text.length; i++) {
      letters.add(Text(
        text[i],
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFFC700),
          shadows: [
            Shadow(
              offset: Offset(-1.5, -1.5),
              color: Colors.black,
            ),
            Shadow(
              offset: Offset(1.5, -1.5),
              color: Colors.black,
            ),
            Shadow(
              offset: Offset(1.5, 1.5),
              color: Colors.black,
            ),
            Shadow(
              offset: Offset(-1.5, 1.5),
              color: Colors.black,
            ),
          ],
        ),
      ));
      letters.add(const SizedBox(width: 5)); // Espaciado entre letras
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: letters,
    );
  }

  void _showWinDialog() {
    setState(() {
      _showConfetti = true;
    });
    showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          ReplayPopup(
            score: currentAnimalIndex + 1,
            onReplay: () {
              setState(() {
                currentAnimalIndex = 0;
                missingVowel = "_";
                isCorrect = false;
                _loadNewVowelChoices();
                Navigator.of(context).pop();
              });
            },
            onQuit: () {
              currentAnimalIndex = 0;
              _onGameComplete();
            },
          ),
          if (_showConfetti) ConfettiAnimation(animate: _showConfetti),
        ],
      ),
    );
  }
}

class VowelTile extends StatelessWidget {
  final String letter;
  final String imagePath;

  const VowelTile({required this.letter, required this.imagePath, Key? key}) : super(key: key);

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
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(imagePath),
        ),
      ),
      childWhenDragging: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Image.asset(imagePath),
        ),
      ),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Aumentar espaciado horizontal
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
}
