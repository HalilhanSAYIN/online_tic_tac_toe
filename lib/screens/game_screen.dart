import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_tic_tac_toe/core/game_logic.dart';
import 'package:online_tic_tac_toe/screens/game_list_screen.dart';
import 'package:online_tic_tac_toe/screens/home_screen.dart';
import 'package:online_tic_tac_toe/screens/splash_screen.dart';
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
      _playerSymbol = (user.uid == gameData['player1'])
          ? gameData['player1icon']
          : gameData['player2icon'];
    }
  }

  void _handleMove(int row, int col, gameData) async {
    if (_board[row][col] == '' && _turn == _getPlayerTurn(gameData)) {
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
        await _gameService.updateBoard(
            widget.gameId, _board, nextTurn, row, col);
      }
    }
  }

  String _getPlayerTurn(gameData) {
    return _playerSymbol == gameData['player1icon'] ? 'player1' : 'player2';
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
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamesListScreen(),
                  )); // Oyun ekranından çık
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
          String player1Nickname = gameData['player1nickname'] ?? 'Player 1';
          String player2Nickname = gameData['player2nickname'] ?? 'Player 2';
          if (gameData['player2nickname'] == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/loading.gif",
                    width: 250,
                    height: 250,
                  ),
                  Text(
                    "The game will start when Player 2 joins.",
                    style: TextStyle(fontSize: 22),
                  )
                ],
              ),
            );
          } else if (gameData['status'] == 'cancelled') {
            return Center(
              child: Column(
                children: [
                  Text("Rakip Oyundan ayrıldı"),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SplashScreen()),
                            (route) => false);
                      },
                      child: Text("Back to main"))
                ],
              ),
            );
          } else {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 22.0, horizontal: 8.0),
              child: Column(
                children: [
                  Text(
                    'Current Turn: ${_turn == player1Nickname ? player1Nickname : player2Nickname}',
                    style: TextStyle(fontSize: 24),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "${gameData['player1icon']} :  ${gameData['player1nickname']}",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Text(
                    "${gameData['player2icon']} :  ${gameData['player2nickname']}",
                    style: TextStyle(fontSize: 24),
                  ),
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
                          onTap: () {
                            _handleMove(row, col, gameData);
                            checkGameState(widget.gameId);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Color(gameData['boardColor']),
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
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Are you sure"),
                            content: Text("You will be lost"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel")),
                              ElevatedButton(
                                  onPressed: () {
                                    GameService().cancelGame(widget.gameId);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                            gameData['player1nickname'],
                                          ),
                                        ),
                                        (route) => false);
                                  },
                                  child: Text("Leave"))
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.cancel_outlined),
                    iconSize: 40,
                    color: Colors.red,
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
