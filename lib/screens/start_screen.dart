import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return const RiveAnimation.asset(
                'assets/RiveAssets/main-animated.riv',
                fit: BoxFit.cover,
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'FrenchApp',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Acción para iniciar sesión
                  },
                  child: const Text('Iniciar Sesión'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Acción para jugar como invitado
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
