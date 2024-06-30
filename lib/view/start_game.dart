import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/character/button.dart';
import 'package:frenc_app/widgets/character/gallo.dart';

class StartGame extends StatelessWidget {
  final String title;
  final List<ButtonData> buttons;

  const StartGame({Key? key, required this.title, required this.buttons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/global/cloudsbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 30),
                              child: Image.asset(
                                'assets/images/icons/hacia-atras.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Stack(
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 75,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 10
                                  ..color = Colors.white,
                              ),
                            ),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 75,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF44B09),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: buttons.map((buttonData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: SizedBox(
                                  width: 200,
                                  child: CustomButton(
                                    text: buttonData.text,
                                    color: const Color(0xFF321158),
                                    textStyle: const TextStyle(
                                      fontSize: 25,
                                      color: Color(0xFFFFE600),
                                    ),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFFFE600),
                                      width: 2,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              buttonData.widget,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  GalloComponent.jumping();
                                },
                                child: Text('Mostrar Popup'),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.all(0),
                  child: Image.asset(
                    'assets/images/icons/sonido.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonData {
  final String text;
  final Widget widget;

  ButtonData({required this.text, required this.widget});
}
