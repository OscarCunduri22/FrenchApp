// ignore_for_file: deprecated_member_use

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(word.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: DragTarget<String>(
                onWillAccept: (character) => true,
                onAccept: (character) {
                  if (character == word[index]) {
                    viewModel.addCharacter(index, character);
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xD9D9D9D9).withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (viewModel.characterSlots[index] != null)
                          Image.asset(
                            'assets/images/numbers/game1/burbuja.png',
                            width: 80,
                            height: 80,
                          ),
                        if (viewModel.characterSlots[index] != null)
                          Text(
                            viewModel.characterSlots[index]!,
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'FuzzyBubblesFont',
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }
}
