import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/character/gallo.dart';

class ReplayPopup extends StatelessWidget {
  const ReplayPopup({
    Key? key,
    required this.score,
    required this.onReplay,
  }) : super(key: key);

  final int score;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: Row(
        children: [
          const SizedBox(
            width: 100, // Ajusta el ancho según sea necesario
            height: 100, // Ajusta la altura según sea necesario
            child: GalloComponent(),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Toutes nos félicitations!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Ton score: $score',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    onReplay();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Répéter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Quitter'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
