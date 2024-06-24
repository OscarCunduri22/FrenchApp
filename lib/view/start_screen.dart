// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frenc_app/view/auth/login_tutor_screen.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/view/category_selection.dart';
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
    AudioManager.background().play('sound/start_page.mp3');
  }

  @override
  void dispose() {
    AudioManager.background().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: IconButton(
              onPressed: () async {
                if (await AudioManager.background().isPlaying()) {
                  AudioManager.background().pause();
                } else {
                  AudioManager.background().play('sound/start_page.mp3');
                }
              },
              icon: const Icon(Icons.volume_up),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: RiveAnimation.asset(
              'assets/RiveAssets/solofondo.riv',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'FrenchApp',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      AudioManager.background().stop();
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
                      AudioManager.background().stop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CategorySelectionScreen()));
                    },
                    child: const Text('Jugar como Invitado'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
