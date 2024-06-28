import 'package:flutter/material.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/widgets/character/button.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/onlyBg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: screenWidth *
                          0.5, // La mitad del ancho de la pantalla
                      alignment: Alignment.center,
                      child: const CustomTextWidget(
                        text: 'Escoge un juego',
                        type: TextType.Title,
                        fontSize: 44,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 1.0,
                      ),
                    ),
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
                const SizedBox(height: 15),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GameOption(
                          title: 'Voyelles',
                          imagePath: 'assets/images/gameSelection/voyelles.jpg',
                          targetView:
                              GameSelectionScreen(category: 'Voyelles')),
                      GameOption(
                        title: 'Nombres',
                        imagePath: 'assets/images/gameSelection/nombres.jpg',
                        targetView: GameSelectionScreen(category: 'Nombres'),
                      ),
                      GameOption(
                        title: 'Famille',
                        imagePath: 'assets/images/gameSelection/famille.jpg',
                        targetView: GameSelectionScreen(category: 'Famille'),
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
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
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
