import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/services/create_game.dart';


class CreateGameScreen extends StatefulWidget {
  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Game'),
      ),
      body:  const Center(
        child: ElevatedButton(
          onPressed: createGame,
          child: Text('Create Tic Tac Toe Game'),
        ),
      ),
    );
  }
}