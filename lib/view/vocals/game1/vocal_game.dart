import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:frenc_app/utils/user_tracking.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/widgets/confetti_animation.dart';
import 'package:frenc_app/widgets/replay_popup.dart';
import 'package:frenc_app/view/button.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/utils/reward_manager.dart';

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

  final List<String> vocalAudios = [
    'sound/vocals/a.mp3',
    'sound/vocals/e.mp3',
    'sound/vocals/i.mp3',
    'sound/vocals/o.mp3',
    'sound/vocals/u.mp3',
    'sound/vocals/y.mp3',
  ];

  int foundVowels = 0;
  String currentBackground = "";
  double vowelPositionX = 0;
  double vowelPositionY = 0;
  bool _showConfetti = false;
  bool _isPlayingSound = false;

  final databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    _incrementTimesPlayed();
    _loadNewScene();
    _playInstructionSound();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadNewScene();
  }

  @override
  void dispose() {
    super.dispose();
    AudioManager.background().stop();
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

      // Unlock the reward using RewardManager
      Provider.of<RewardManager>(context, listen: false).unlockReward(0); // Unlocks Voyelles_reward_1.pdf
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GameSelectionScreen(category: 'Voyelles'),
        ),
      );
    }
  }

  void _loadNewScene() {
    final random = Random();
    currentBackground = backgrounds[random.nextInt(backgrounds.length)];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      const vocalSize = 100.0;

      if (mounted) {
        setState(() {
          vowelPositionX = random.nextDouble() * (screenWidth - vocalSize);
          vowelPositionY = random.nextDouble() * (screenHeight - vocalSize - 100);
        });
      }
    });
  }

  Future<void> _playInstructionSound() async {
    await AudioManager.playBackground('sound/vocals/esgame1.m4a');
  }

  Future<void> playSound(String soundPath) async {
    await AudioManager.effects().play(soundPath);
  }

  Future<void> _playVowelSound(int index) async {
    if (mounted) {
      setState(() {
        _isPlayingSound = true;
      });
    }

    await AudioManager.effects().stop();
    await AudioManager.effects().play('sound/numbers/yeahf.mp3');
    await Future.delayed(const Duration(seconds: 2));
    await playSound(vocalAudios[index]);
    await Future.delayed(const Duration(seconds: 3));
    await playSound(vocalAudios[index]);
    await Future.delayed(const Duration(seconds: 7));

    if (mounted) {
      setState(() {
        _isPlayingSound = false;
      });
    }
  }

  void _onVowelTapped() async {
    if (mounted) {
      setState(() {
        _isPlayingSound = true;
      });
    }

    await _playVowelSound(foundVowels);

    if (mounted) {
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
  }

  void _showWinDialog() {
    if (mounted) {
      setState(() {
        _showConfetti = true;
      });
      showDialog(
        context: context,
        builder: (context) => Stack(
          children: [
            ReplayPopup(
              score: foundVowels,
              onReplay: () {
                if (mounted) {
                  setState(() {
                    foundVowels = 0;
                    _loadNewScene();
                    Navigator.of(context).pop();
                  });
                }
              },
              onQuit: () {
                foundVowels = 0;
                _onGameComplete();
              }, overScore: 6,
            ),
            if (_showConfetti) ConfettiAnimation(animate: _showConfetti),
          ],
        ),
      );
    }
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
                headerText: 'Encuentra la vocal',
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
          if (_isPlayingSound)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: const Center(
                child: Icon(
                  Icons.volume_up,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          const Positioned(
            bottom: 10,
            right: 10,
            child: MovableButtonScreen(
              spanishAudio: 'sound/vocals/esgame1.m4a',
              frenchAudio: 'sound/vocals/frgame1.m4a',
              rivePath: 'assets/RiveAssets/vocalsgame1.riv',
            ),
          ),
        ],
      ),
    );
  }
}
