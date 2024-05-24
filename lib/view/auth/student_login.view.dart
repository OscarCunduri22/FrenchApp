import 'package:flutter/material.dart';

class ColorMatchingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Map<String, bool> score = {};
  final Map<String, Color> fruitColors = {
    'banana': Colors.yellow,
    'pear': Colors.green,
    'strawberry': Colors.red,
    'watermelon': Colors.lightGreen,
    'orange': Colors.orange,
  };

  final List<String> fruits = [
    'banana',
    'pear',
    'strawberry',
    'watermelon',
    'orange',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserta el código'),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: fruits.map((fruit) {
              return Draggable<String>(
                data: fruit,
                child: FruitImage(
                  fruit: fruit,
                  score: score,
                ),
                feedback: FruitImage(
                  fruit: fruit,
                  score: score,
                  isDragging: true,
                ),
                childWhenDragging: FruitImage(
                  fruit: fruit,
                  score: score,
                  isDragging: false,
                ),
              );
            }).toList(),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: fruitColors.keys.map((fruit) {
              return DragTarget<String>(
                builder: (context, incoming, rejected) {
                  return Container(
                    height: 100,
                    width: 100,
                    color: fruitColors[fruit]!.withOpacity(0.5),
                    child: Center(
                      child: score[fruit] == true
                          ? Icon(Icons.check, color: Colors.white, size: 50)
                          : null,
                    ),
                  );
                },
                onWillAccept: (data) => data == fruit,
                onAccept: (data) {
                  setState(() {
                    score[fruit] = true;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

class FruitImage extends StatelessWidget {
  final String fruit;
  final bool isDragging;
  final Map<String, bool> score;

  const FruitImage({
    super.key,
    required this.fruit,
    required this.score,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDragging ? 0.5 : 1.0,
      child: Image.asset(
        'assets/images/auth/$fruit.png',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        color: score[fruit] == true ? Colors.grey : null,
        colorBlendMode: BlendMode.saturation,
      ),
    );
  }
}
