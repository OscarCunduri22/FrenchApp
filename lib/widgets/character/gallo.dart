import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:audioplayers/audioplayers.dart';

class GalloComponent extends StatefulWidget {
  final EdgeInsetsGeometry padding;

  const GalloComponent({Key? key, this.padding = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  State<GalloComponent> createState() => _GalloComponentState();
}

class _GalloComponentState extends State<GalloComponent> {
  Artboard? riveArtboard;
  SMITrigger? isDancing;

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/RiveAssets/gallindo.riv').then(
      (data) async {
        final file = await RiveFile.asset('assets/RiveAssets/gallindo.riv');
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'State Machine 1');
        if (controller != null) {
          artboard.addController(controller);
          isDancing = controller.findSMI('pressed');
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: riveArtboard == null
          ? const SizedBox()
          : GestureDetector(
              onTap: () {
                isDancing?.fire();
                _playSound();
              },
              child: Rive(
                artboard: riveArtboard!,
              ),
            ),
    );
  }
  // return Center(
  //   child: Rive(artboard: riveArtboard!),
  //);
}
