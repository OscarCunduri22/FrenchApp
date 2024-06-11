// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/view_model/numbers/game1/game_viewmodel.dart';

class DisorderedCharactersWidget extends StatelessWidget {
  final String word;
  final VoidCallback onCorrect;

  const DisorderedCharactersWidget({
    Key? key,
    required this.word,
    required this.onCorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        List<String> characters = viewModel.getShuffledCharacters(word);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(characters.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Draggable<String>(
                data: characters[index],
                child: DraggableCharacter(
                  character: characters[index],
                  dragging: false,
                ),
                feedback: DraggableCharacter(
                  character: characters[index],
                  dragging: true,
                ),
                childWhenDragging: DraggableCharacter(
                  character: characters[index],
                  dragging: false,
                  invisible: true,
                ),
                onDragEnd: (details) {},
              ),
            );
          }),
        );
      },
    );
  }
}

class DraggableCharacter extends StatelessWidget {
  final String character;
  final bool dragging;
  final bool invisible;

  const DraggableCharacter({
    Key? key,
    required this.character,
    required this.dragging,
    this.invisible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: invisible
            ? null
            : const DecorationImage(
                image: AssetImage('assets/images/numbers/game1/burbuja.png'),
                fit: BoxFit.cover,
              ),
      ),
      child: Text(
        character,
        style: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'FuzzyBubblesFont',
        ),
      ),
    );
  }
}
