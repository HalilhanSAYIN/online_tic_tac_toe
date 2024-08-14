import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/services/create_game.dart';

List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
List<String> icons = [
  'X',
  'O',
  '😂',
  '😡',
  '😆',
  '😊',
  '😍',
  '🥳',
  '😎',
  '🤩',
  '🌙',
  '⭐️',
  '🎯',
  '🔥',
  '💦'
];
var selectedBoardColor = colors[0];
var player1SelectedIcon = icons[0];
var player2SelectedIcon = icons[1];

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Board Color",style: TextStyle(fontSize: 24),),
              DropdownButton<Color>(
                value: selectedBoardColor,
                items: colors.map((Color color) {
                  return DropdownMenuItem<Color>(
                    value: color,
                    child: Container(
                      width: 24,
                      height: 24,
                      color: color,
                    ),
                  );
                }).toList(),
                onChanged: (Color? newColor) {
                  setState(() {
                    selectedBoardColor = newColor!;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Player 1 Icon : ",
                style: TextStyle(fontSize: 24),
              ),
              DropdownButton<String>(
                value: player1SelectedIcon,
                items: icons.map((String icon) {
                  return DropdownMenuItem<String>(
                    value: icon,
                    child: Text(icon, style: TextStyle(fontSize: 24)),
                  );
                }).toList(),
                onChanged: (String? newIcon) {
                  setState(() {
                    player1SelectedIcon = newIcon!;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Player 2 Icon : ",
                style: TextStyle(fontSize: 24),
              ),
              DropdownButton<String>(
                value: player2SelectedIcon,
                items: icons.map((String icon) {
                  return DropdownMenuItem<String>(
                    value: icon,
                    child: Text(icon, style: TextStyle(fontSize: 24)),
                  );
                }).toList(),
                onChanged: (String? newIcon) {
                  setState(() {
                    player2SelectedIcon = newIcon!;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              createGame(context,selectedBoardColor,player1SelectedIcon,player2SelectedIcon );
            },
            child: const Text('Create Tic Tac Toe Game'),
          ),
        ],
      ),
    );
  }
}
