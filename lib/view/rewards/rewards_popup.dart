import 'package:flutter/material.dart';
import 'package:frenc_app/utils/reward_service.dart';

class RewardsPopup extends StatelessWidget {
  const RewardsPopup({Key? key}) : super(key: key);

  Future<void> _saveFile(BuildContext context, String assetPath) async {
    try {
      await RewardService().saveFile(assetPath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Descargando ${assetPath.split('/').last}...'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al descargar $assetPath: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RewardService().initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error al cargar las recompensas: ${snapshot.error}'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }

        return AlertDialog(
          title: const Text('Recompensas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(RewardService.totalRewards, (index) {
              bool isUnlocked = RewardService().isRewardUnlocked('reward_$index');
              return ListTile(
                title: Text('Recompensa ${index + 1}'),
                trailing: isUnlocked
                    ? IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          String path = RewardService().getRewardPath(index);
                          _saveFile(context, path);
                        },
                      )
                    : const Icon(Icons.lock),
              );
            }),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
