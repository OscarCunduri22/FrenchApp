import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/character/button.dart';
import 'package:frenc_app/widgets/character/gallo.dart';

class StartGame extends StatelessWidget {
  const StartGame({Key? key}) : super(key: key);

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
                              'Famille',
                              style: TextStyle(
                                fontSize: 75,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 10
                                  ..color = Colors.white,
                              ),
                            ),
                            const Text(
                              'Famille',
                              style: TextStyle(
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
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200,
                                child: CustomButton(
                                  text: 'Jugar',
                                  color: Color(0xFF321158),
                                  textStyle: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xFFFFE600),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color(0xFFFFE600),
                                    width: 2,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 200,
                                child: CustomButton(
                                  text: 'Ajustes',
                                  color: Color(0xFF321158),
                                  textStyle: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xFFFFE600),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color(0xFFFFE600),
                                    width: 2,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 200,
                                child: CustomButton(
                                  text: 'Instrucciones',
                                  color: Color(0xFF321158),
                                  textStyle: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xFFFFE600),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color(0xFFFFE600),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(child: GalloComponent()),
                              ),
                              SizedBox(height: 10),
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
