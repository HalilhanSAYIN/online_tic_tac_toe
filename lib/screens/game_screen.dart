import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/core/game_logic.dart';
import 'package:online_tic_tac_toe/screens/game_list_screen.dart';
import 'package:online_tic_tac_toe/services/game_service.dart';


class GameScreen extends StatefulWidget {
  final String gameId;

  GameScreen({required this.gameId});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameService _gameService = GameService();
  final GameLogic _gameLogic = GameLogic();

  late List<List<String>> _board;
  late String _playerSymbol;
  late String _turn;


  @override
  void initState() {
    super.initState();
    _initializeGame();
    
  }

  Future<void> _initializeGame() async {
    DocumentSnapshot gameData = await _gameService.getGameData(widget.gameId);
    _board = _gameLogic.parseBoard(gameData['board']);
    _turn = gameData['turn'];

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _playerSymbol = (user.uid == gameData['player1']) ? 'X' : 'O';
    }
  }

  void _handleMove(int row, int col) async {
    if (_board[row][col] == '' && _turn == _getPlayerTurn()) {
      setState(() {
        _board[row][col] = _playerSymbol;
      });

      String winner = _gameLogic.checkWinner(_board);
      if (winner.isNotEmpty) {
        _showGameEndDialog('$winner Winner!');
        await _gameService.updateBoard(widget.gameId, _board, _turn, row, col);
        _gameService.gameStream(widget.gameId).first.then((snapshot) {
          snapshot.reference.update({'status': 'finished'});
        });
      } else if (_gameLogic.isBoardFull(_board)) {
        _showGameEndDialog('Draw!');
        _gameService.gameStream(widget.gameId).first.then((snapshot) {
          snapshot.reference.update({'status': 'draw'});
        });
      } else {
        String nextTurn = _turn == 'player1' ? 'player2' : 'player1';
        await _gameService.updateBoard(widget.gameId, _board, nextTurn, row, col);
      }
    }
  }

  String _getPlayerTurn() {
    return _playerSymbol == 'X' ? 'player1' : 'player2';
  }

  void _showGameEndDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GamesListScreen(),)); // Oyun ekranından çık
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  void checkGameState(gameRef) {
  String winner = _gameLogic.checkWinner(_board);
  if (winner.isNotEmpty) {
    _showGameEndDialog('$winner kazandı!');
    gameRef.update({'status': 'finished'});
  } else if (_gameLogic.isBoardFull(_board)) {
    _showGameEndDialog('Berabere!');
    gameRef.update({'status': 'draw'});
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game ${widget.gameId}'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _gameService.gameStream(widget.gameId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var gameData = snapshot.data!.data() as Map<String, dynamic>;
          _board = _gameLogic.parseBoard(gameData['board']);
          _turn = gameData['turn'];

          return Column(
            children: [
              Text('Current Turn: ${_turn == 'player1' ? 'Player 1' : 'Player 2'}'),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    int row = index ~/ 3;
                    int col = index % 3;

                    return GestureDetector(
                      onTap: () { _handleMove(row, col);
                      checkGameState(widget.gameId);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            _board[row][col],
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}