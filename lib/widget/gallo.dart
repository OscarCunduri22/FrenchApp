import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class GalloComponent extends StatefulWidget {
  const GalloComponent({Key? key}) : super(key: key);

  @override
  State<GalloComponent> createState() => _GalloComponentState();
}

class _GalloComponentState extends State<GalloComponent> {
  Artboard? riveArtboard;
  SMITrigger? isDancing;

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
  Widget build(BuildContext context) {
    return riveArtboard == null
        ? const SizedBox()
        : GestureDetector(
            onTap: () => isDancing?.fire(),
            child: Rive(
              artboard: riveArtboard!,
            ),
          );
  }
}
