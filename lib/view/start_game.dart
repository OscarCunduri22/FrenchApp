import 'package:flutter/material.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/widgets/animated_button.dart';
import 'package:frenc_app/widgets/character/button.dart';
import 'package:frenc_app/widgets/character/gallo.dart';

class StartGame extends StatelessWidget {
  final String title;
  final List<ButtonData> buttons;

  const StartGame({Key? key, required this.title, required this.buttons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.03,
                  ),
                  child: Image.asset(
                    'assets/images/icons/hacia-atras.png',
                    width: size.width * 0.04,
                    height: size.width * 0.04,
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = size.width * 0.02
                                    ..color = Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Text with tomato color
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: size.width * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFF44B09),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.1),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: buttons.map((buttonData) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: SizedBox(
                                width: size.width * 0.3,
                                child: CustomButton(
                                  text: buttonData.text,
                                  color: Colors.purple[900]!,
                                  textStyle: TextStyle(
                                    fontSize: size.width * 0.05,
                                    color: const Color(0xFFFFE600),
                                  ),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFFE600),
                                    width: 4,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => buttonData.widget,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: size.height * 0.05,
                            left: size.width * 0.18,
                            child: SizedBox(
                              width: size.width * 0.4,
                              height: size.width * 0.4,
                              child: GalloComponent.dancing(),
                            ),
                          ),
                          Positioned(
                            bottom: size.height * 0.4,
                            right: size.width * 0.23,
                            child: CustomPaint(
                              painter: TrianglePainter(),
                            ),
                          ),
                          Positioned(
                            top: size.height * 0.2,
                            width: size.width * 0.3,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          width: size.width * 0.07,
                                          height: size.width * 0.07,
                                          'assets/images/icons/ecuador.png',
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(width: size.width * 0.05),
                                        AnimatedButton(
                                            imagePath:
                                                'assets/images/icons/sonido.png',
                                            onTap: () => AudioManager.playEffect(
                                                'sound/empezarJuegoES.m4a')),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          width: size.width * 0.07,
                                          height: size.width * 0.07,
                                          'assets/images/icons/francia.png',
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(width: size.width * 0.05),
                                        AnimatedButton(
                                            imagePath:
                                                'assets/images/icons/sonido.png',
                                            onTap: () => AudioManager.playEffect(
                                                'sound/empezarJuegoFR.m4a')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width + 40, size.height);
    path.lineTo(size.width, size.height - 30);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
