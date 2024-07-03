import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_tracking.dart';
import 'package:frenc_app/utils/user_provider.dart'; // Importar UserProvider

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

  int currentAnimalIndex = 0;
  String missingVowel = "_";
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _incrementTimesPlayed();
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

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¡Felicidades!"),
        content: const Text("Has completado el juego."),
        actions: [
          TextButton(
            onPressed: () {
              _incrementTimesCompleted(); // Incrementar contador de juegos completados
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
                  progressValue: (currentAnimalIndex + 1) / animals.length,
                  onBack: () {
                    Navigator.pop(context);
                  },
                  onVolume: () {},
                ),
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
                    Text(
                      animalName.split('_')[0],
                      style: const TextStyle(
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
                          missingVowel = data!;
                          isCorrect = (data == targetVowel);
                          if (isCorrect) {
                            Future.delayed(const Duration(seconds: 1), () {
                              setState(() {
                                if (currentAnimalIndex < animals.length - 1) {
                                  currentAnimalIndex++;
                                  missingVowel = "_";
                                  isCorrect = false;
                                } else {
                                  _showWinDialog(); // Juego completado, mostrar mensaje de victoria
                                }
                              });
                            });
                          }
                        });
                      },
                    ),
                    Text(
                      animalName.split('_')[1],
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Wrap(
                  spacing: 20, // Ajustar el espaciado según sea necesario
                  alignment: WrapAlignment.center,
                  children: [
                    VowelTile(letter: 'A'),
                    VowelTile(letter: 'E'),
                    VowelTile(letter: 'I'),
                    VowelTile(letter: 'O'),
                    VowelTile(letter: 'U'),
                    VowelTile(letter: 'Y'),
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
