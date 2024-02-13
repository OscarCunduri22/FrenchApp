// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frenc_app/screens/auth/login_tutor_screen.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:rive/rive.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    AudioManager().play('sound/start_page.mp3');
  }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TutorLoginScreen()),
                    );
                  },
                  child: const Text('Iniciar Sesión'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Jugar como Invitado'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (await AudioManager().isPlaying()) {
                      AudioManager().pause();
                    } else {
                      AudioManager().play('sound/start_page.mp3');
                    }
                  },
                  child: const Text('Pausar Audio'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
