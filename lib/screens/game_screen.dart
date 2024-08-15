import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/const/text_styles.dart';
import 'package:online_tic_tac_toe/core/game_logic.dart';
import 'package:online_tic_tac_toe/screens/game_list_screen.dart';
import 'package:online_tic_tac_toe/screens/home_screen.dart';
import 'package:online_tic_tac_toe/screens/splash_screen.dart';
import 'package:online_tic_tac_toe/services/game_service.dart';

class GameScreen extends StatefulWidget {
  final String gameId;

  GameScreen({
    required this.gameId,
  });

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
    _confettiController = ConfettiController(
        duration: const Duration(seconds: 3)); // Süreyi ayarla
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    DocumentSnapshot gameData = await _gameService.getGameData(widget.gameId);
    int boardSize = gameData["boardsize"];
    _board =
        _gameLogic.parseBoard(gameData['board'], boardSize); // Boyutu geçiyoruz
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
        String winnerNickname = winner == gameData['player1icon']
            ? gameData['player1nickname']
            : gameData['player2nickname'];

        await _gameService.updateBoard(widget.gameId, _board, _turn, row, col);
        _gameService.gameStream(widget.gameId).first.then((snapshot) {
          snapshot.reference.update({
            'status': 'finished',
            'winner': winnerNickname,
            'winnericon': winner,
          });
        });
      } else if (_gameLogic.isBoardFull(_board)) {
        var board = List.generate(
                gameData["boardsize"],
                (_) =>
                    List.generate(gameData["boardsize"], (_) => '').join(','))
            .join('|');
        _gameService.gameStream(widget.gameId).first.then((snapshot) {
          snapshot.reference.update({'board': board});
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
        title: const Text('Game Over'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamesListScreen(),
                  ));
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  late ConfettiController _confettiController;

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
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
            return const Center(child: CupertinoActivityIndicator());
          }
          var gameData = snapshot.data!.data() as Map<String, dynamic>;
          _board = _gameLogic.parseBoard(
              gameData['board'], gameData['boardsize']); // Boyutu geçiyoruz
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
                  const Text(
                    "The game will start when Player 2 joins.",
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          } else if (gameData['status'] == 'finished') {
            _confettiController.play();
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${gameData['winner']} Win!",
                        style: defaultFontSize,
                      ),
                      Text(
                        "${gameData['winnericon']}",
                        style: const TextStyle(fontSize: 100),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SplashScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text("Back to Home"),
                      ),
                    ],
                  ),
                ),
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  blastDirectionality: BlastDirectionality.explosive,
                )
              ],
            );
          } else if (gameData['status'] == 'cancelled') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Opponent left the game",
                    style: defaultFontSize,
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SplashScreen()),
                            (route) => false);
                      },
                      child: const Text("Back to main"))
                ],
              ),
            );
          } else {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 22.0, horizontal: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "${gameData['player1icon']} :  ${gameData['player1nickname']}",
                      style: defaultFontSize,
                    ),
                  ),
                  Text(
                    "${gameData['player2icon']} :  ${gameData['player2nickname']}",
                    style: defaultFontSize,
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            gameData['boardsize'], // Dinamik board boyutu
                      ),
                      itemCount: gameData['boardsize'] * gameData['boardsize'],
                      itemBuilder: (context, index) {
                        int row = index ~/ gameData['boardsize'];
                        int col = index % gameData['boardsize'] as int;
                        return GestureDetector(
                          onTap: () {
                            _handleMove(row, col, gameData);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Color(gameData['boardColor']),
                            ),
                            child: Center(
                              child: Text(
                                _board[row][col],
                                style: defaultHeaderFontSize,
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
                            title: const Text("Are you sure?"),
                            content: const Text("This will end the game"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel")),
                              ElevatedButton(
                                  onPressed: () {
                                    GameService().cancelGame(widget.gameId);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>  const SplashScreen(
                                          ),
                                        ),
                                        (route) => false);
                                  },
                                  child: const Text("Leave"))
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.cancel_outlined),
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
