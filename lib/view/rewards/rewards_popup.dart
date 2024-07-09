import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/reward_manager.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RewardsPopup extends StatelessWidget {
  const RewardsPopup({Key? key}) : super(key: key);

  Future<void> _saveFile(BuildContext context, String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final fileName = assetPath.split('/').last;
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/$fileName';

      final file = File(tempPath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      final params = SaveFileDialogParams(sourceFilePath: tempPath);
      await FlutterFileDialog.saveFile(params: params);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Descargando $fileName...'),
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
    return AlertDialog(
      title: const Text('Recompensas'),
      content: Consumer<RewardManager>(
        builder: (context, rewardManager, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(RewardManager.totalRewards, (index) {
              bool isUnlocked = rewardManager.isRewardUnlocked(index);
              return ListTile(
                title: Text('Recompensa ${index + 1}'),
                trailing: isUnlocked
                    ? IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          String path = rewardManager.getRewardPath(index);
                          _saveFile(context, path);
                        },
                      )
                    : const Icon(Icons.lock),
              );
            }),
          );
        },
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
  }
}
