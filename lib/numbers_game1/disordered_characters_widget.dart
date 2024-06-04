import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/numbers_game1/game_viewmodel.dart';

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
            return Draggable<String>(
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
              onDragEnd: (details) {
                if (!details.wasAccepted) {
                  viewModel
                      .resetCharacterSlots(); // Reset slots if character was not accepted
                }
              },
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
      width: 50,
      height: 50,
      margin: const EdgeInsets.all(4.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: invisible ? Colors.transparent : Colors.blueAccent,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: dragging
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(0, 2),
                  blurRadius: 8.0,
                )
              ]
            : null,
      ),
      child: Text(
        character,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
