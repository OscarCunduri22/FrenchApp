import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class AnimatedRive extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final String rivePath;

  const AnimatedRive({
    Key? key,
    required this.rivePath,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  State<AnimatedRive> createState() => _AnimatedRiveState();
}

class _AnimatedRiveState extends State<AnimatedRive> {
  Artboard? riveArtboard;
  SMITrigger? isPlaying;

  @override
  void initState() {
    super.initState();
    rootBundle.load(widget.rivePath).then(
      (data) async {
        final file = await RiveFile.asset(widget.rivePath);
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'State Machine 1');
        if (controller != null) {
          artboard.addController(controller);
          isPlaying = controller.findSMI('playing');
        }
        setState(() {
          riveArtboard = artboard;
          isPlaying?.fire();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: riveArtboard == null
          ? const SizedBox()
          : ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Rive(
                  artboard: riveArtboard!,
                ),
              ),
            ),
    );
  }
}
