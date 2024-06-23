import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:frenc_app/utils/user_tracking.dart';

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
    // Añade más vocales según sea necesario
  ];

  int foundVowels = 0;
  String currentBackground = "";
  String currentVowel = "";
  double vowelPositionX = 0;
  double vowelPositionY = 0;

  @override
  void initState() {
    super.initState();
    //_incrementTimesPlayed();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadNewScene();
  }

  void _incrementTimesPlayed() {
    Provider.of<UserTracking>(context, listen: false).incrementTimesPlayed('vocal_game');
  }

  void _incrementTimesCompleted() {
    Provider.of<UserTracking>(context, listen: false).incrementTimesCompleted('vocal_game');
  }

  void _loadNewScene() {
    final random = Random();
    currentBackground = backgrounds[random.nextInt(backgrounds.length)];
    currentVowel = vocals[random.nextInt(vocals.length)];
    setState(() {
      // Tamaño máximo de la pantalla
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      // Tamaño de la imagen de la vocal
      final vocalSize = 100.0;

      // Posiciones aleatorias teniendo en cuenta el tamaño de la pantalla y la imagen
      vowelPositionX = random.nextDouble() * (screenWidth - vocalSize);
      vowelPositionY = random.nextDouble() * (screenHeight - vocalSize - 100); // Restando 100 para dejar espacio para la ProgressBar
    });
  }

  void _onVowelTapped() {
    setState(() {
      foundVowels++;
      if (foundVowels >= 3) {
        _incrementTimesCompleted();
        _showWinDialog();
      } else {
        _loadNewScene();
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Ganaste!'),
        content: Text('Has encontrado 3 vocales.'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                foundVowels = 0;
                _loadNewScene();
                Navigator.of(context).pop();
              });
            },
            child: Text('Jugar de nuevo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProgressBar(
            backgroundColor: const Color(0xFF424141),
            progressBarColor: const Color(0xFFD67171),
            headerText: 'Sélectionnez l\'image qui ressemble à celle ci-dessus',
            progressValue: foundVowels / 3,
            onBack: () {
              // Acción para retroceder
            },
            onVolume: () {
              // Acción para controlar el volumen
            },
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
                Positioned(
                  left: vowelPositionX,
                  top: vowelPositionY,
                  child: GestureDetector(
                    onTap: _onVowelTapped,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(currentVowel),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
