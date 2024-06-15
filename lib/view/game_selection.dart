import 'package:flutter/material.dart';
import 'package:frenc_app/view/numbers/game1/game_screen.dart';
import 'package:frenc_app/view/vocals/tracing.dart';
import 'package:frenc_app/widgets/character/button.dart';
import 'package:frenc_app/view/start_screen.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/GameSelectionBg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF016171),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.person),
                        iconSize: 36,
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF016171),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.person),
                        iconSize: 36,
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GameOption(
                        title: 'Voyelles',
                        imagePath: 'assets/images/gameSelection/voyelles.jpg',
                        targetView: TracingGame(
                            imageAssetPath: 'assets/images/vocals/bee.jpg',
                            letter: 'A',
                            imageObjectName: 'Abellie'),
                      ),
                      const GameOption(
                        title: 'Nombres',
                        imagePath: 'assets/images/gameSelection/nombres.jpg',
                        targetView: BubbleNumbersGame(),
                      ),
                      const GameOption(
                        title: 'Famille',
                        imagePath: 'assets/images/gameSelection/famille.jpg',
                        targetView: StartScreen(),
                      ),
                    ],
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

class GameOption extends StatelessWidget {
  final String title;
  final String imagePath;
  final Widget targetView;

  const GameOption({
    super.key,
    required this.title,
    required this.imagePath,
    required this.targetView,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // Contorno del texto (stroke)
            Text(
              title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = Colors.white,
              ),
            ),
            // Texto con color de relleno
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF44B09),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // Color del borde
              width: 2.0, // Ancho del borde
            ),
            borderRadius:
                BorderRadius.circular(18.0), // Radio del borde redondeado
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0), // Mismo radio del borde
            child: Image.asset(
              imagePath,
              width: 150,
              height: 150,
            ),
          ),
        ),
        const SizedBox(height: 10),
        CustomButton(
          text: '   Jugar   ',
          color: const Color(0xFF321158),
          targetView: targetView,
          textStyle: const TextStyle(
            fontSize: 20,
            color: Color(0xFFFFE600),
          ),
          borderSide: const BorderSide(
            color: Color(0xFFFFE600),
            width: 2,
          ),
        ),
      ],
    );
  }
}
