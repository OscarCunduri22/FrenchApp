import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/widgets/animated_button.dart';
import 'package:frenc_app/widgets/animated_rive.dart';
import 'package:rive/rive.dart';
import 'package:audioplayers/audioplayers.dart';

// ignore: must_be_immutable
class GalloComponent extends StatefulWidget {
  final String animationType;
  final EdgeInsetsGeometry padding;
  String? audioPath;

  GalloComponent(
      {Key? key,
      required this.animationType,
      this.padding = const EdgeInsets.all(0),
      this.audioPath})
      : super(key: key);

  @override
  State<GalloComponent> createState() => _GalloComponentState();

  static GalloComponent dancing(
      {EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
    return GalloComponent(animationType: 'Dancing', padding: padding);
  }

  static GalloComponent speaking(
      {EdgeInsetsGeometry padding = const EdgeInsets.all(0),
      String? audioPath}) {
    return GalloComponent(
      animationType: 'Speaking',
      padding: padding,
      audioPath: audioPath,
    );
  }

  static GalloComponent speakingwithoutsound(
      {EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
    return GalloComponent(animationType: 'Speaking1', padding: padding);
  }

  static GalloComponent walking(
      {EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
    return GalloComponent(animationType: 'Walking', padding: padding);
  }

  static GalloComponent jumping(
      {EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
    return GalloComponent(animationType: 'Jumping', padding: padding);
  }

  static void showPopup(BuildContext context, String spanishAudio,
      String frenchAudio, String rivePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 200,
                        height: 200,
                        child: AnimatedRive(rivePath: rivePath)),
                    const SizedBox(width: 30),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedButton(
                            imagePath: 'assets/images/icons/ecuador.png',
                            onTap: () => AudioManager.playEffect(spanishAudio)),
                        const SizedBox(height: 20),
                        AnimatedButton(
                            imagePath: 'assets/images/icons/francia.png',
                            onTap: () => AudioManager.playEffect(frenchAudio)),
                      ],
                    ),
                    const SizedBox(width: 30),
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
                left: 360,
                top: 90,
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
  StreamSubscription? _audioPlayerStateSubscription;

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
    _audioPlayerStateSubscription?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(String? audioPath) async {
    if (audioPath != null) {
      await audioPlayer.play(AssetSource('../assets/sound/$audioPath.m4a'));
    } else {
      await AudioManager.effects().play('sound/Login.m4a');
    }
  }

  void _triggerAnimation() {
    switch (widget.animationType) {
      case 'Dancing':
        isDancing?.fire();
        break;
      case 'Speaking':
        isSpeaking?.fire();
        _playSound(widget.audioPath);
        break;
      case 'Speaking1':
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
  }

  void playCustomSoundAndSpeak(String audioPath) async {
    isSpeaking?.fire();
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        isSpeaking?.fire();
      }
    });

    await AudioManager.effects().play(audioPath);
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
