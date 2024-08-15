import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/const/general_consts.dart';
import 'package:online_tic_tac_toe/const/text_styles.dart';
import 'package:online_tic_tac_toe/services/create_game.dart';


var selectedBoardColor = colors[0];
var player1SelectedIcon = icons[0];
var player2SelectedIcon = icons[1];
bool gameCreateLoadingController = false ; 

class CreateGameScreen extends StatefulWidget {
  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}
int boardSize = 3;
class _CreateGameScreenState extends State<CreateGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "You can choose the color of the board and the icon of the first and second user as you wish.",
            textAlign: TextAlign.center,
            style: defaultFontSize,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Board Color : ",
                      style: defaultFontSize,
                    ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Player 1 Icon : ",
                      style: defaultFontSize,
                    ),
                    DropdownButton<String>(
                      value: player1SelectedIcon,
                      items: icons.map((String icon) {
                        return DropdownMenuItem<String>(
                          value: icon,
                          child: Text(icon, style: defaultFontSize),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Player 2 Icon : ",
                      style: defaultFontSize,
                    ),
                    DropdownButton<String>(
                      value: player2SelectedIcon,
                      items: icons.map((String icon) {
                        return DropdownMenuItem<String>(
                          value: icon,
                          child: Text(icon, style: defaultFontSize),
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
              ],
            ),
          ),
          Column(
            children: [
              RadioListTile<int>(
                title: const Text('3 x 3'),
                subtitle: const Text('Classic X O X'),
                value: 3,
                groupValue: boardSize,
                onChanged: (value) {
                  setState(() {
                    boardSize = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: const Text('4 x 4'),
                subtitle: const Text('Little bit harder'),
                value: 4,
                groupValue: boardSize,
                onChanged: (value) {
                  setState(() {
                    boardSize = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: const Text('5 x 5'),
                subtitle: const Text('Hardest'),
                value: 5,
                groupValue: boardSize,
                onChanged: (value) {
                  setState(() {
                    boardSize = value!;
                  });
                },
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (player1SelectedIcon != player2SelectedIcon) {
                setState(() {
                  gameCreateLoadingController = true;
                });
                 createGame(context, selectedBoardColor, player1SelectedIcon,
                  player2SelectedIcon, boardSize);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Icons must be different!!")));
              }
             
            },
            child:  Padding(
              padding: const EdgeInsets.all(16.0),
              child: 
              gameCreateLoadingController == false ? 
            const  Column(
                children: [
                  Icon(Icons.add, size: 70),
                  Text(
                    'Create \nNew Game',
                    textAlign: TextAlign.center,
                  ),
                ],
              ) : const CupertinoActivityIndicator()
            ),
          ),
        ],
      ),
    );
  }
}
