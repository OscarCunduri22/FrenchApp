// movable_button.dart

import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/character/gallo.dart';

class MovableButtonScreen extends StatefulWidget {
  const MovableButtonScreen({super.key});

  @override
  _MovableButtonScreenState createState() => _MovableButtonScreenState();
}

class _MovableButtonScreenState extends State<MovableButtonScreen> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    GalloComponent.showPopup(context, '¡Hola! Este es un mensaje emergente.');
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Añade padding si es necesario
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: _isPressed ? 52 : 56,
            height: _isPressed ? 52 : 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: _isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ],
              image: const DecorationImage(
                image: AssetImage('assets/images/icons/GalloButtom.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
