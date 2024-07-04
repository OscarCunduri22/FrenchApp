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
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Image.asset(
                    'assets/images/icons/hacia-atras.png',
                    width: 50,
                    height: 50,
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
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 10
                                    ..color = Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Text with tomato color
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF44B09),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
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
                            right: 200,
                            top: 120,
                            width: 250,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Cliquez sur jouer pour commencer à vous amuser.',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 150,
                            right: 210,
                            child: CustomPaint(
                              painter: TrianglePainter(),
                            ),
                          ),
                          Positioned(
                            right: -80,
                            bottom: 0,
                            child: SizedBox(
                              width: 350,
                              height: 350,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: GalloComponent.dancing(),
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
