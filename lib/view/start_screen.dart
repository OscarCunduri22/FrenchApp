import 'package:flutter/material.dart';
import 'package:frenc_app/utils/dialog_manager.dart';
import 'package:frenc_app/view/auth/login_tutor_screen.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';

import 'package:rive/rive.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    AudioManager.background().play('sound/start_page.mp3');
  }

  @override
  void dispose() {
    AudioManager.background().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DialogManager.showExitConfirmationDialog(context);
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: <Widget>[
            const Positioned.fill(
              child: RiveAnimation.asset(
                'assets/RiveAssets/firstscreen.riv',
                fit: BoxFit.fill,
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinea al inicio
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomTextWidget(
                            text: 'LudoFrench',
                            type: TextType.Title,
                            fontSize: 70,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1.0,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/EPN.png',
                                height: 80,
                                width: 80,
                              ),
                              SizedBox(width: 16),
                              Image.asset(
                                'assets/images/ludolab.png',
                                height: 50,
                                width: 50,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF016171),
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          animationDuration: const Duration(milliseconds: 200),
                        ),
                        onPressed: () {
                          AudioManager.background().stop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TutorLoginScreen()),
                          );
                        },
                        child: const Text('Iniciar Sesión'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16.0,
              bottom: 16.0,
              child: IconButton(
                onPressed: () async {
                  if (await AudioManager.background().isPlaying()) {
                    AudioManager.background().pause();
                  } else {
                    AudioManager.background().play('sound/start_page.mp3');
                  }
                },
                icon: Image.asset(
                  'assets/images/icons/sonido.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
