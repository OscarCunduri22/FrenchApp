import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/view_model/numbers/game1/game_viewmodel.dart';

class CharacterBoxWidget extends StatelessWidget {
  final String word;

  const CharacterBoxWidget({
    Key? key,
    required this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.characterSlots.length != word.length) {
          viewModel.characterSlots = List<String?>.filled(word.length, null);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(word.length, (index) {
            return DragTarget<String>(
              onWillAccept: (character) => true,
              onAccept: (character) {
                if (character == word[index]) {
                  viewModel.addCharacter(index, character);
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/numbers/game1/bg_box.png'),
                      fit: BoxFit.cover,
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: viewModel.characterSlots[index] != null
                      ? Text(
                          viewModel.characterSlots[index]!,
                          style: const TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            fontFamily:
                                'Arial', // Use a different font if desired
                          ),
                        )
                      : null,
                );
              },
            );
          }),
        );
      },
    );
  }
}
