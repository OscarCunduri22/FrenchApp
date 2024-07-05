import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_tracking.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userTracking = Provider.of<UserTracking>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados del Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Veces jugadas:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...userTracking.timesPlayed.entries.map((entry) => ListTile(
                  title: Text(entry.key),
                  trailing: Text('${entry.value}'),
                )),
            const SizedBox(height: 16),
            const Text(
              'Veces completadas:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...userTracking.timesCompleted.entries.map((entry) => ListTile(
                  title: Text(entry.key),
                  trailing: Text('${entry.value}'),
                )),
          ],
        ),
      ),
    );
  }
}
