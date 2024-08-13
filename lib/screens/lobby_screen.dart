import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/screens/game_screen.dart';

class GameLobbyScreen extends StatelessWidget {
  final String gameId;

  GameLobbyScreen({required this.gameId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Lobby'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameScreen(gameId: gameId),
              ),
            );
          },
          child: Text('Enter Game'),
        ),
      ),
    );
  }
}
