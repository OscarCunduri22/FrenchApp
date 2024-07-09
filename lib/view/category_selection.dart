import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frenc_app/view/rewards/rewards_popup.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/widgets/character/button.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/view/auth/tutor_dashboard.dart';
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/view/montessori/montessori_screen.dart';
import 'package:frenc_app/widgets/auth/security_code_box.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';
import 'package:frenc_app/utils/reward_manager.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';// Importar RewardsScreen

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  void _showSecurityCodeDialog(Function onSuccess) {
    FocusScope.of(context).unfocus(); // Dismiss the keyboard
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SecurityCodeDialog(onSuccess: onSuccess);
      },
    );
  }

  Future<void> _saveFile(String assetPath) async {
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
          content: Text('Error al descargar el archivo: $e'),
        ),
      );
    }
  }

  void _navigateToRewardsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RewardsScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Tutor? currentUser = Provider.of<UserProvider>(context).currentUser;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return WillPopScope(
      onWillPop: () async {
        _showSecurityCodeDialog(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TutorDashboardScreen(tutorName: currentUser!.name),
            ),
          );
        });
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomTextWidget(
                          text: 'Escoge un juego',
                          type: TextType.Title,
                          fontSize: 44,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 1.0,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF016171),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.person),
                                iconSize: 36,
                                color: Colors.white,
                                onPressed: () {
                                  _showSecurityCodeDialog(() {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TutorDashboardScreen(
                                          tutorName: currentUser!.name,
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF016171),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.info),
                                iconSize: 36,
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MontessoriScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF016171),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.card_giftcard),
                                iconSize: 36,
                                color: Colors.white,
                                onPressed: () {
                                  _navigateToRewardsScreen(context);
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double cardWidth = (constraints.maxWidth - 96) / 3;
                        double cardHeight = constraints.maxHeight - 100;

                        return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GameOption(
                                title: 'Voyelles',
                                imagePath:
                                    'assets/images/gameSelection/voyelles.jpg',
                                targetView: const GameSelectionScreen(
                                  category: 'Voyelles',
                                ),
                                width: cardWidth,
                                height: cardHeight,
                              ),
                              GameOption(
                                title: 'Nombres',
                                imagePath:
                                    'assets/images/gameSelection/nombres.jpg',
                                targetView: const GameSelectionScreen(
                                  category: 'Nombres',
                                ),
                                width: cardWidth,
                                height: cardHeight,
                              ),
                              GameOption(
                                title: 'Famille',
                                imagePath:
                                    'assets/images/gameSelection/famille.jpg',
                                targetView: const GameSelectionScreen(
                                  category: 'Famille',
                                ),
                                width: cardWidth,
                                height: cardHeight,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameOption extends StatelessWidget {
  final String title;
  final String imagePath;
  final Widget targetView;
  final double width;
  final double height;

  const GameOption({
    super.key,
    required this.title,
    required this.imagePath,
    required this.targetView,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = Colors.white,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF44B09),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: width,
          height: height * 0.6,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        CustomButton(
          text: '   Jugar   ',
          color: const Color(0xFF321158),
          targetView: targetView,
          textStyle: const TextStyle(
            fontSize: 20,
            color: Color(0xFFFFE600),
          ),
          borderSide: const BorderSide(
            color: Color(0xFFFFE600),
            width: 2,
          ),
        ),
      ],
    );
  }
}
