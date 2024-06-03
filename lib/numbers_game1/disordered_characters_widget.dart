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
    final viewModel = Provider.of<GameViewModel>(context, listen: false);
    final characters = viewModel.getShuffledCharacters(word);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: characters.map((character) {
          return Draggable<String>(
            data: character,
            feedback: _buildCharacter(character),
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: _buildCharacter(character),
            ),
            child: _buildCharacter(character),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCharacter(String character) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        character,
        style: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial', // Use a different font if desired
        ),
      ),
    );
  }
}
