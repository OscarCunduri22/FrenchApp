// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frenc_app/view/button.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:frenc_app/utils/user_tracking.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/widgets/confetti_animation.dart';
import 'package:frenc_app/widgets/replay_popup.dart';
import 'package:frenc_app/repository/global.repository.dart';

class VocalGame extends StatefulWidget {
  const VocalGame({Key? key}) : super(key: key);

  @override
  _VocalGameState createState() => _VocalGameState();
}

class _VocalGameState extends State<VocalGame> {
  final List<String> backgrounds = [
    'assets/images/vocals/game1/background/background1.webp',
    'assets/images/vocals/game1/background/background2.webp',
    'assets/images/vocals/game1/background/background3.webp',
    // Añade más imágenes de fondo según sea necesario
  ];

  final List<String> vocals = [
    'assets/images/vocals/vocal/a.png',
    'assets/images/vocals/vocal/e.png',
    'assets/images/vocals/vocal/i.png',
    'assets/images/vocals/vocal/o.png',
    'assets/images/vocals/vocal/u.png',
    'assets/images/vocals/vocal/y.png',
  ];

  int foundVowels = 0;
  String currentBackground = "";
  double vowelPositionX = 0;
  double vowelPositionY = 0;
  bool _showConfetti = false;

  final databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    _incrementTimesPlayed();
    _loadNewScene();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadNewScene();
  }

  void _incrementTimesPlayed() {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false)
          .incrementTimesPlayed(studentId, 'vocal_game');
    }
  }

  void _incrementTimesCompleted() {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;
    if (studentId != null) {
      Provider.of<UserTracking>(context, listen: false)
          .incrementTimesCompleted(studentId, 'vocal_game');
    }
  }

  Future<void> _onGameComplete() async {
    String? studentId =
        Provider.of<UserProvider>(context, listen: false).currentStudentId;

    if (studentId != null) {
      await databaseRepository.updateGameCompletionStatus(studentId, 'Voyelles',
          [true, false, false]); // Actualizar estado de juego
      _incrementTimesCompleted(); // Incrementar contador de juegos completados
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GameSelectionScreen(
                category: 'Voyelles',
              )),
    );
  }

  void _loadNewScene() {
    final random = Random();
    currentBackground = backgrounds[random.nextInt(backgrounds.length)];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      const vocalSize = 100.0;

      setState(() {
        vowelPositionX = random.nextDouble() * (screenWidth - vocalSize);
        vowelPositionY = random.nextDouble() * (screenHeight - vocalSize - 100);
      });
    });
  }

  void _onVowelTapped() {
    setState(() {
      foundVowels++;
      if (foundVowels >= 6) {
        _incrementTimesCompleted();
        _showWinDialog();
      } else {
        _loadNewScene();
      }
    });
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
            score: foundVowels,
            overScore: 5,
            onReplay: () {
              setState(() {
                foundVowels = 0;
                _loadNewScene();
                Navigator.of(context).pop();
              });
            },
            onQuit: () {
              foundVowels = 0;
              _onGameComplete();
            },
          ),
          if (_showConfetti) ConfettiAnimation(animate: _showConfetti),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ProgressBar(
                backgroundColor: const Color(0xFF424141),
                progressBarColor: const Color(0xFFD67171),
                headerText:
                    'Sélectionnez l\'image qui ressemble à celle ci-dessus',
                progressValue: foundVowels / 6,
                onBack: () {
                  Navigator.pop(context);
                },
                backgroundMusic: 'sound/start_page.mp3',
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        currentBackground,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (foundVowels < vocals.length)
                      Positioned(
                        left: vowelPositionX,
                        top: vowelPositionY,
                        child: GestureDetector(
                          onTap: _onVowelTapped,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(vocals[foundVowels]),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Positioned(
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
}
