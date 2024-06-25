import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/character/gallo.dart';

class MovableButtonScreen extends StatefulWidget {
  const MovableButtonScreen({super.key});

  @override
  State<MovableButtonScreen> createState() => _MovableButtonScreenState();
}

class _MovableButtonScreenState extends State<MovableButtonScreen> {
  Offset position = const Offset(0, 0);

  @override
  void initState() {
    super.initState();
    // WidgetsBinding ensures the context is available when calculating the initial position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        position = Offset(size.width - 70, size.height - 120);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
              feedback: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/icons/GalloButtom.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  position = details.offset;
                });
              },
              child: GestureDetector(
                onTap: () {
                  GalloComponent.showPopup(
                      context, '¡Hola! Este es un mensaje emergente.');
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/icons/GalloButtom.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
