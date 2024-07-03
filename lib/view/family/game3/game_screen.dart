import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/view/button.dart';
import 'package:frenc_app/widgets/confetti_animation.dart';
import 'package:frenc_app/widgets/replay_popup.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_tracking.dart'; // Importar UserTracking

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({Key? key}) : super(key: key);

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage>
    with TickerProviderStateMixin {
  bool _showConfetti = false;
  bool isBusy = false;

  List<String> allImages = [
    'assets/images/family/game3/aunt.jpg',
    'assets/images/family/game3/baby.jpg',
    'assets/images/family/game3/brother.jpg',
    'assets/images/family/game3/cousin.jpg',
    'assets/images/family/game3/cousinw.jpg',
    'assets/images/family/game3/father.jpg',
    'assets/images/family/game3/grandfather.jpg',
    'assets/images/family/game3/grandmother.jpg',
    'assets/images/family/game3/mother.jpg',
    'assets/images/family/game3/sister.jpg',
    'assets/images/family/game3/uncle.jpg',
  ];

  late List<String> cardImages;
  List<bool> cardsFlipped = [];
  List<int> flippedIndices = [];
  int score = 0;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _isLoading = true;

  final databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(allImages.length, (index) {
      return AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(controller);
    }).toList();

    _loadGame();
    _incrementTimesPlayed(); // Incrementar contador de juegos jugados
  }

  void _incrementTimesPlayed() {
    String? studentId = Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false).incrementTimesPlayed(studentId, 'memory_game');
    }
  }

  void _incrementTimesCompleted() {
    String? studentId = Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false).incrementTimesCompleted(studentId, 'memory_game');
    }
  }

  Future<void> _loadGame() async {
    await AudioManager.effects().play('sound/family/instruccionGame3.m4a');
    _newGame();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
    AudioManager.background().stop();
  }

  void _onGameComplete() async {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;

    if (studentId != null) {
      await databaseRepository
          .updateGameCompletionStatus(studentId, 'Famille', [true, true, true]);
      _incrementTimesCompleted(); // Incrementar contador de juegos completados
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GameSelectionScreen(
                category: 'Famille',
              )),
    );
  }

  Future<void> playSound(String card) async {
    String soundPath;
    switch (card) {
      case 'assets/images/family/game3/mother.jpg':
        soundPath = 'sound/family/mere.m4a';
        break;
      case 'assets/images/family/game3/father.jpg':
        soundPath = 'sound/family/pere.m4a';
        break;
      case 'assets/images/family/game3/brother.jpg':
        soundPath = 'sound/family/frere.m4a';
        break;
      case 'assets/images/family/game3/grandfather.jpg':
        soundPath = 'sound/family/grandpere.m4a';
        break;
      case 'assets/images/family/game3/grandmother.jpg':
        soundPath = 'sound/family/grandmere.m4a';
        break;
      case 'assets/images/family/game3/sister.jpg':
        soundPath = 'sound/family/soeur.m4a';
        break;
      case 'assets/images/family/game3/uncle.jpg':
        soundPath = 'sound/family/oncle.m4a';
        break;
      case 'assets/images/family/game3/aunt.jpg':
        soundPath = 'sound/family/tante.m4a';
        break;
      case 'assets/images/family/game3/baby.jpg':
        soundPath = 'sound/family/bebe.m4a';
        break;
      case 'assets/images/family/game3/cousin.jpg':
        soundPath = 'sound/family/cousin.m4a';
        break;
      case 'assets/images/family/game3/cousinw.jpg':
        soundPath = 'sound/family/cousine.m4a';
        break;
      default:
        soundPath = 'sound/correct.mp3';
    }
    await AudioManager.effects().play(soundPath);
  }

  void _newGame() {
    setState(() {
      cardImages = (allImages..shuffle()).take(4).toList();
      cardImages = List.from(cardImages)..addAll(cardImages);
      cardImages.shuffle();
      cardsFlipped = List<bool>.filled(cardImages.length, false);
      flippedIndices = [];
      _showConfetti = false;
      isBusy = false;
      for (var controller in _controllers) {
        controller.reset();
      }
    });
  }

  void _showWinDialog() {
    setState(() {
      _showConfetti = true;
      AudioManager.effects().play('sound/family/level_win.mp3');
    });
    showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          ReplayPopup(
            score: score,
            onReplay: () {
              setState(() {
                _newGame();
                score = 0;
              });
            },
            onQuit: () {
              score = 0;
              _onGameComplete();
            },
          ),
          if (_showConfetti) ConfettiAnimation(animate: _showConfetti),
        ],
      ),
    );
  }

  void onCardTap(int index) {
    if (cardsFlipped[index] || isBusy) return;

    setState(() {
      cardsFlipped[index] = true;
      flippedIndices.add(index);
      _controllers[index].forward();

      if (flippedIndices.length == 2) {
        isBusy = true;
        if (cardImages[flippedIndices[0]] != cardImages[flippedIndices[1]]) {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              cardsFlipped[flippedIndices[0]] = false;
              cardsFlipped[flippedIndices[1]] = false;
              _controllers[flippedIndices[0]].reverse();
              _controllers[flippedIndices[1]].reverse();
              flippedIndices.clear();
              AudioManager.effects().play('sound/incorrect.mp3');
              isBusy = false;
              Future.delayed(const Duration(seconds: 2), () {
                AudioManager.effects().stop();
              });
            });
          });
        } else {
          playSound(cardImages[flippedIndices[0]]);
          Future.delayed(const Duration(seconds: 2), () {
            AudioManager.effects().stop();
            isBusy = false;
          });
          flippedIndices.clear();
        }
      }

      if (cardsFlipped.every((flipped) => flipped)) {
        score += 1;
        Future.delayed(const Duration(seconds: 2), () {
          if (score < 10) {
            _newGame();
          } else {
            _showWinDialog();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * 0.1;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/family/game3/Verde.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                ProgressBar(
                  backgroundColor: const Color(0xFF424141),
                  progressBarColor: const Color(0xFF8DB270),
                  headerText: 'Retournez les cartes et trouvez les paires',
                  progressValue: score / 10,
                  onBack: () {
                    Navigator.pop(context);
                  },
                  onVolume: () {
                    // Acción para activar/desactivar el sonido
                  },
                ),
                _isLoading
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                                left: widthPadding, right: widthPadding),
                            itemCount: cardImages.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              mainAxisExtent: size.height * 0.30,
                            ),
                            itemBuilder: (context, index) {
                              return FadeInUp(
                                duration: const Duration(milliseconds: 500),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: GestureDetector(
                                    onTap: () => onCardTap(index),
                                    child: AnimatedBuilder(
                                      animation: _animations[index],
                                      builder: (context, child) {
                                        final angle = _animations[index].value *
                                            3.141592653589793;
                                        final isFlipped =
                                            angle >= 3.141592653589793 / 2;
                                        final transform =
                                            Matrix4.rotationY(angle);
                                        return Transform(
                                          transform: transform,
                                          alignment: Alignment.center,
                                          child: isFlipped
                                              ? Image.asset(
                                                  cardImages[index],
                                                  key: ValueKey<int>(index),
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.asset(
                                                  'assets/images/family/game3/Card.png',
                                                  key: ValueKey<int>(
                                                      index + 100),
                                                  fit: BoxFit.fill,
                                                ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ),
          const MovableButtonScreen(
            spanishAudio: 'sound/family/instruccionGame1.m4a',
            frenchAudio: 'sound/family/instruccionGame1.m4a',
            rivePath: 'assets/RiveAssets/familygame3.riv',
          )
        ],
      ),
    );
  }
}
