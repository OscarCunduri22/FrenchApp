import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frenc_app/utils/progress_bar.dart';
import 'package:frenc_app/view_model/numbers/game1/numbersgame1_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:frenc_app/widgets/numbers/game1/character_box_widget.dart';
import 'package:frenc_app/widgets/numbers/game1/disordered_characters_widget.dart';
import 'package:frenc_app/widgets/numbers/game1/number_image_widget.dart';
import 'dart:math';

class BubbleNumbersGame extends StatefulWidget {
  const BubbleNumbersGame({Key? key}) : super(key: key);

  @override
  _BubbleNumbersGameState createState() => _BubbleNumbersGameState();
}

class _BubbleNumbersGameState extends State<BubbleNumbersGame>
    with TickerProviderStateMixin {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _characterBoxController.dispose();
    _disorderedCharactersController.dispose();
    _wordChangeController.dispose();
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
        body: Consumer<GameViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.currentIndexChanged) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _resetAnimations();
                _initializeAnimations();
                viewModel.currentIndexChanged = false;
              });
            } else {
              _initializeAnimations();
            }
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/numbers/game1/fondo-marino.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Foreground Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProgressBar(
                        backgroundColor:
                            const Color(0xF2005BA7).withOpacity(0.8),
                        progressBarColor: const Color(0xFF0BCC6C),
                        headerText: 'Completa la secuencia de números',
                        progressValue: viewModel.currentIndex / 10.0,
                        onBack: () {
                          Navigator.pop(context);
                        },
                        onVolume: () {},
                      ),
                      ScaleTransition(
                        scale: _wordChangeController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NumberImageWidget(
                              imagePath:
                                  viewModel.images[viewModel.currentIndex],
                            ),
                            const SizedBox(height: 20),
                            CharacterBoxWidget(
                              word: viewModel.numbers[viewModel.currentIndex],
                            ),
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
