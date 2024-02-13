import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/shape_widget.dart';

class CardGame extends StatefulWidget {
  const CardGame({super.key});

  @override
  State<CardGame> createState() => _CardGametState();
}

class _CardGametState extends State<CardGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Juego de Cartas'),
        ),
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShapeWidget(shapeType: ShapeType.circle, color: Colors.blue),
              ShapeWidget(shapeType: ShapeType.square, color: Colors.red),
              ShapeWidget(shapeType: ShapeType.star, color: Colors.green),
              ShapeWidget(shapeType: ShapeType.triangle, color: Colors.orange),
            ],
          ),
        ));
  }
}
