// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frenc_app/model/fruit.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/view_model/auth/student_login.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class FruitGameScreen extends StatelessWidget {
  final String studentId;

  FruitGameScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  image: AssetImage('assets/images/auth/fruitsbg2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            Consumer<FruitGameViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.correctAnswers.length ==
                        viewModel.fruits.length &&
                    viewModel.correctAnswers.values
                        .every((isCorrect) => isCorrect)) {
                  Future.delayed(Duration.zero, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameSelectionScreen(),
                      ),
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
                      const Text(
                        'Place the Fruits in the Correct Baskets',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'ShortBabyFont',
                          color: Colors.brown,
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
                                  child: Image.asset(fruit.draggableImagePath,
                                      width: 80),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration interval;

  const ShakeWidget({
    Key? key,
    required this.child,
    this.interval = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _ShakeWidgetState createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );

    _startShake();
  }

  void _startShake() {
    Future.delayed(widget.interval, () {
      if (mounted) {
        _controller.forward(from: 0.0).then((_) {
          _controller.reverse().then((_) {
            _startShake();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: child,
        );
      },
    );
  }
}
