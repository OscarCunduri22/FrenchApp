import 'package:flutter/material.dart';

class TrainEngine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/numbers/game2/tren1-removebg-preview.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
