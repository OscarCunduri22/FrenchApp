import 'package:flutter/material.dart';
import 'package:frenc_app/model/fruit.dart';
import 'package:frenc_app/view_model/auth/student_login.dart';
import 'package:provider/provider.dart';

class FruitGameScreen extends StatelessWidget {
  final String studentId;

  FruitGameScreen({Key? key, required this.studentId}) : super(key: key);

  final Map<String, Color> fruitColors = {
    'banana': Colors.yellow,
    'orange': Colors.orange,
    'pear': Colors.green,
    'strawberry': Colors.red,
    'watermelon': Colors.green[800]!,
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FruitGameViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fruit Drag and Drop Game welcome $studentId'),
        ),
        body: Consumer<FruitGameViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Drag targets row
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: viewModel.fruits.map((fruit) {
                      return DragTarget<Fruit>(
                        onAccept: (receivedFruit) {
                          if (receivedFruit.name == fruit.name) {
                            viewModel.setCorrectAnswer(fruit.name);
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          final isCorrect =
                              viewModel.correctAnswers[fruit.name] ?? false;
                          return Container(
                            width: 100,
                            height: 100,
                            color: isCorrect
                                ? Colors.green
                                : fruitColors[fruit.name],
                            child: Center(
                              child: isCorrect
                                  ? Icon(Icons.check, color: Colors.white)
                                  : null,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                // Draggable fruits row
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: viewModel.fruits.map((fruit) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Draggable<Fruit>(
                          data: fruit,
                          feedback: Image.asset(fruit.imagePath, width: 80),
                          childWhenDragging: Opacity(
                            opacity: 0.5,
                            child: Image.asset(fruit.imagePath, width: 80),
                          ),
                          child: Image.asset(fruit.imagePath, width: 80),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
