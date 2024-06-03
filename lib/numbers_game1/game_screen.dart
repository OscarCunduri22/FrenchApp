import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:frenc_app/numbers_game1/character_box_widget.dart';
import 'package:frenc_app/numbers_game1/disordered_characters_widget.dart';
import 'package:frenc_app/numbers_game1/game_viewmodel.dart';
import 'package:frenc_app/numbers_game1/number_image_widget.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _characterBoxController;
  late AnimationController _disorderedCharactersController;
  late AnimationController _wordChangeController;

  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _characterBoxController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _disorderedCharactersController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _wordChangeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // Enforce vertical orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _characterBoxController.dispose();
    _disorderedCharactersController.dispose();
    _wordChangeController.dispose();
    // Revert to the default orientation settings when the view is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _initializeAnimations() {
    if (!_animationsInitialized) {
      _characterBoxController.forward();
      _disorderedCharactersController.forward();
      _wordChangeController.forward();
      _animationsInitialized = true;
    }
  }

  void _resetAnimations() {
    _animationsInitialized = false;
    _characterBoxController.reset();
    _disorderedCharactersController.reset();
    _wordChangeController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Word Game'),
        ),
        body: Consumer<GameViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.currentIndexChanged) {
              _resetAnimations();
              _initializeAnimations();
              viewModel.currentIndexChanged =
                  false; // Reset the flag after handling the animation
            } else {
              _initializeAnimations();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _wordChangeController,
                  child: Column(
                    children: [
                      NumberImageWidget(
                          imagePath: viewModel.images[viewModel.currentIndex]),
                      const SizedBox(height: 20),
                      CharacterBoxWidget(
                          word: viewModel.numbers[viewModel.currentIndex]),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ScaleTransition(
                  scale: _disorderedCharactersController,
                  child: DisorderedCharactersWidget(
                    word: viewModel.numbers[viewModel.currentIndex],
                    onCorrect: () {
                      _confettiController.play();
                      viewModel.onCorrect();
                    },
                  ),
                ),
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  emissionFrequency: 0.05,
                  numberOfParticles: 10,
                  gravity: 0.1,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
