import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:audioplayers/audioplayers.dart';

class GalloComponent extends StatefulWidget {
  final String animationType;
  final EdgeInsetsGeometry padding;

  const GalloComponent(
      {Key? key,
      required this.animationType,
      this.padding = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  State<GalloComponent> createState() => _GalloComponentState();

  static GalloComponent dancing(
      {EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
    return GalloComponent(animationType: 'Dancing', padding: padding);
  }

  static GalloComponent speaking(
      {EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
    return GalloComponent(animationType: 'Speaking', padding: padding);
  }

  static GalloComponent walking(
      {EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
    return GalloComponent(animationType: 'Walking', padding: padding);
  }

  static GalloComponent jumping(
      {EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
    return GalloComponent(animationType: 'Jumping', padding: padding);
  }

  static void showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 90.0, top: 20.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cerrar'),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  painter: TrianglePainter(),
                ),
              ),
              Positioned(
                left: 420,
                top: 50,
                child: Image.asset(
                  'assets/images/gallo.png',
                  height: 250,
                  width: 250,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GalloComponentState extends State<GalloComponent> {
  Artboard? riveArtboard;
  SMITrigger? isDancing;
  SMITrigger? isSpeaking;
  SMITrigger? isWalking;
  SMITrigger? isJumping;

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/RiveAssets/gallindoFinal.riv').then(
      (data) async {
        final file =
            await RiveFile.asset('assets/RiveAssets/gallindoFinal.riv');
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'State Machine 1');
        if (controller != null) {
          artboard.addController(controller);
          isDancing = controller.findSMI('Dancing');
          isSpeaking = controller.findSMI('Speaking');
          isWalking = controller.findSMI('Walking');
          isJumping = controller.findSMI('Jumping');
        }
        setState(() => riveArtboard = artboard);
      },
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _playSound() async {
    await audioPlayer.play(AssetSource('../assets/sound/Login.m4a'));
  }

  void _triggerAnimation() {
    switch (widget.animationType) {
      case 'Dancing':
        isDancing?.fire();
        break;
      case 'Speaking':
        isSpeaking?.fire();
        break;
      case 'Walking':
        isWalking?.fire();
        break;
      case 'Jumping':
        isJumping?.fire();
        break;
      default:
        break;
    }
    _playSound();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: riveArtboard == null
          ? const SizedBox()
          : GestureDetector(
              onTap: _triggerAnimation,
              child: Rive(
                artboard: riveArtboard!,
              ),
            ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width + 40, size.height);
    path.lineTo(size.width, size.height - 30);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
