import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frenc_app/view/main_menu.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _CardGametState();
}

class _CardGametState extends State<StudentLogin> {
  final Map<String, bool> score = {};
  final Map choices = {
    '🍎': Colors.red,
    '🍋': Colors.yellow,
    '🍏': Colors.green,
    '🍊': Colors.orange,
    '🍇': Colors.purple,
    '🍉': Colors.red.shade200,
  };

  int seed = 0;
  int correctCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Login'),
        backgroundColor: Colors.blue.shade200,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Inserta el codigo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: choices.keys.map((emoji) {
              return Draggable<String>(
                data: emoji,
                feedback: Emoji(emoji: emoji),
                childWhenDragging: const Emoji(emoji: '🌱'),
                child: Emoji(emoji: score[emoji] == true ? '✅' : emoji),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                choices.keys.map((emoji) => _buildDragTarget(emoji)).toList()
                  ..shuffle(Random(seed)),
          ),
        ],
      ),
    );
  }

  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String?> incoming, List rejected) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            height: 80,
            width: 80,
            child: const Text('💥'),
          );
        } else {
          return Container(color: choices[emoji], height: 80, width: 80);
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
          correctCount += 1;
          if (correctCount == 6) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Congratulations!'),
                  content: const Text('Ahora puedes continuar!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainMenu()),
                        );
                      },
                      child: const Text('Continuar...'),
                    )
                  ],
                );
              },
            );
          }
        });
      },
      onLeave: (data) {},
    );
  }
}

class Emoji extends StatelessWidget {
  const Emoji({super.key, required this.emoji});

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          alignment: Alignment.center,
          width: 50,
          padding: const EdgeInsets.all(10),
          child: Text(
            emoji,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 50,
            ),
          )),
    );
  }
}
