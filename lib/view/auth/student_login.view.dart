// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/view/auth/tutor_dashboard.dart';
import 'package:frenc_app/view_model/auth/student_login.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/model/fruit.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/utils/dialog_manager.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/category_selection.dart';
import 'package:frenc_app/widgets/animations/shake.dart';
import 'package:frenc_app/widgets/character/gallo.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';
import 'package:frenc_app/widgets/confetti_animation.dart';
import 'dart:math';

class FruitGameScreen extends StatefulWidget {
  final String studentId;

  // ignore: prefer_const_constructors_in_immutables
  FruitGameScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  _FruitGameScreenState createState() => _FruitGameScreenState();
}

class _FruitGameScreenState extends State<FruitGameScreen>
    with SingleTickerProviderStateMixin {
  bool _showExplanation = true;
  late AnimationController _animationController;

  void _setStudentIdInProvider(BuildContext context) async {
    final repository = DatabaseRepository();
    final student = await repository.getStudentById(widget.studentId);

    if (student != null) {
      Provider.of<UserProvider>(context, listen: false)
          .setCurrentStudent(widget.studentId, student);
    }
  }

  @override
  void initState() {
    super.initState();
    _setStudentIdInProvider(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    AudioManager.background().play('sound/family/song1.mp3');
  }

  @override
  void dispose() {
    _animationController.dispose();
    AudioManager.background().stop();
    AudioManager.effects().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    final buttonHeight = MediaQuery.of(context).size.height * 0.07;
    final buttonWidth = MediaQuery.of(context).size.width * 0.25;
    return ChangeNotifierProvider(
      create: (_) => FruitGameViewModel(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/onlyBg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Consumer<FruitGameViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isAllCorrect()) {
                  Future.delayed(Duration.zero, () {
                    AudioManager.playEffect('sound/numbers/yeahf.mp3');
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: AlertDialog(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const ConfettiAnimation(animate: true),
                                const CustomTextWidget(
                                  text: 'Felicidades',
                                  type: TextType.Title,
                                  fontSize: 44,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 1.0,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Container(
                                        child: GalloComponent.dancing()),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Has completado el juego con éxito.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(seconds: 1),
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const CategorySelectionScreen(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: TweenSequence([
                                              TweenSequenceItem(
                                                tween:
                                                    Tween(begin: 0.0, end: 1.0),
                                                weight: 50.0,
                                              ),
                                            ]).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF016171),
                                  ),
                                  child: const Text(
                                    'Continuar',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  });
                }

                final draggableFruits = List<Fruit>.from(viewModel.fruits)
                  ..shuffle(Random());
                final targetFruits = List<Fruit>.from(viewModel.fruits)
                  ..shuffle(Random());

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 32),
                      const CustomTextWidget(
                        text: 'Busca la silueta correcta',
                        type: TextType.Subtitle,
                        fontSize: 36,
                        color: ColorType.Secondary,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: draggableFruits.map((fruit) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ShakeWidget(
                                interval:
                                    Duration(seconds: 2 + Random().nextInt(3)),
                                child: Draggable<Fruit>(
                                  data: fruit,
                                  feedback: Image.asset(
                                      fruit.draggableImagePath,
                                      width: 80),
                                  childWhenDragging: Opacity(
                                    opacity: 0.5,
                                    child: Image.asset(fruit.draggableImagePath,
                                        width: 80),
                                  ),
                                  child: Image.asset(
                                    fruit.draggableImagePath,
                                    width: 80,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: targetFruits.map((fruit) {
                            return DragTarget<Fruit>(
                              onAccept: (receivedFruit) {
                                if (receivedFruit.name == fruit.name) {
                                  viewModel.setCorrectAnswer(fruit.name);
                                  AudioManager.effects()
                                      .play('sound/correct1.mp3');
                                } else {
                                  AudioManager.effects()
                                      .play('sound/error.mp3');
                                }
                              },
                              builder: (context, candidateData, rejectedData) {
                                final isCorrect =
                                    viewModel.correctAnswers[fruit.name] ??
                                        false;
                                return Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(isCorrect
                                          ? fruit.correctTargetImagePath
                                          : fruit.targetImagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (_showExplanation)
              Stack(
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Container(
                                    width: 300,
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: const Column(
                                      children: [
                                        Text(
                                          'Desafio diario',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'FuzzyBubblesFont',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Asigna la fruta a la silueta correcta',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'FuzzyBubblesFont',
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Buena Suerte!',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'FuzzyBubblesFont',
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              const SizedBox(width: 8.0),
                              Flexible(
                                child: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: Stack(
                                    children: [
                                      GalloComponent.speaking(
                                          audioPath: 'codigofrutasES'),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        top: 0,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                                  begin: const Offset(0, 0.3),
                                                  end: const Offset(0, 0.25))
                                              .animate(_animationController),
                                          child: const Icon(
                                            Icons.touch_app,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showExplanation = false;
                              });
                            },
                            label: const Text(
                              'Saltar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                            icon: const Icon(Icons.skip_next,
                                color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(buttonWidth, buttonHeight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: const Color(0xFF016171),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Image.asset(
                  'assets/images/icons/exit.png',
                  width: 32,
                  height: 32,
                ),
                onPressed: () {
                  Tutor? tutor =
                      Provider.of<UserProvider>(context, listen: false)
                          .currentUser;
                  DialogManager.showExitGameDialog(
                      context, TutorDashboardScreen(tutorName: tutor!.name));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
