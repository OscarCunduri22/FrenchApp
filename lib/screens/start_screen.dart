import 'package:flutter/material.dart';
import 'package:frenc_app/screens/login_tutor_screen.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:rive/rive.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return const RiveAnimation.asset(
                'assets/RiveAssets/solofondo.riv',
                fit: BoxFit.cover,
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    AudioManager().play('sound/start_page.mp3');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TutorLoginScreen()),
                    );
                  },
                  child: const Text('Iniciar Sesión'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    AudioManager().stop();
                  },
                  child: const Text('Jugar como Invitado'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
