import 'package:flutter/material.dart';
import 'package:frenc_app/utils/reward_service.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart'; // Importar CustomTextWidget

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key}) : super(key: key);

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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/onlyBg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CustomTextWidget(
                  text: 'Recompensas',
                  type: TextType.Subtitle,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorType.Primary,
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: RewardService().initialize(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Error al cargar las recompensas'),
                            Text('${snapshot.error}'),
                            TextButton(
                              child: const Text('Cerrar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.all(10.0),
                      width: double.maxFinite,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Número de columnas
                          crossAxisSpacing: 10.0, // Espacio entre columnas
                          mainAxisSpacing: 10.0, // Espacio entre filas
                          childAspectRatio: 1, // Proporción del tamaño de los hijos
                        ),
                        itemCount: RewardService.totalRewards,
                        itemBuilder: (context, index) {
                          bool isUnlocked = RewardService().isRewardUnlocked('reward_$index');
                          return Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Recompensa ${index + 1}'),
                                const SizedBox(height: 10),
                                isUnlocked
                                    ? IconButton(
                                        icon: const Icon(Icons.download),
                                        onPressed: () {
                                          String path = RewardService().getRewardPath(index);
                                          _saveFile(context, path);
                                        },
                                      )
                                    : const Icon(Icons.lock),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
