import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'dart:async';

class PezComponent extends StatefulWidget {
  final EdgeInsetsGeometry padding;

  const PezComponent({Key? key, this.padding = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  State<PezComponent> createState() => _PezComponentState();
}

class _PezComponentState extends State<PezComponent> {
  Artboard? riveArtboard;
  SMITrigger? isDancing;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/RiveAssets/test_pez.riv').then(
      (data) async {
        final file = await RiveFile.asset('assets/RiveAssets/test_pez.riv');
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'State Machine 1');
        print('PEZ LISTO VAAAAAAAAR');
        if (controller != null) {
          artboard.addController(controller);
          isDancing = controller.findSMI('Trigger 1');
          print('PEZ LISTO');
          isDancing?.fire();
          _timer = Timer.periodic(Duration(seconds: 5), (timer) {
            isDancing?.fire();
          });
        }
        setState(() => riveArtboard = artboard);
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
              },
              child: Rive(
                artboard: riveArtboard!,
              ),
            ),
    );
  }
}
