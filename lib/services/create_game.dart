import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/screens/game_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> createGame(context,selectedBoardColor,player1SelectedIcon,player2SelectedIcon,boardSize) async {
  try {
    User? user = _auth.currentUser;
    if (user != null) {
      String board =
          List.generate(boardSize, (_) => List.generate(boardSize, (_) => '').join(','))
              .join('|');
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String nickName = userDoc['nickname'];

      DocumentReference gameRef = await _firestore.collection('games').add({
        'player1': user.uid,
        'player2': null,
        'status': 'waiting',
        'board': board,
        'createdAt': Timestamp.now(),
        'currentPlayer': user.uid,
        'turn': 'player1',
        'player1nickname': nickName,
        'player2nickname': null,
        'boardColor': selectedBoardColor.value, // Renk kaydetme
        'player1icon': player1SelectedIcon, // X için ikon kaydetme
        'player2icon': player2SelectedIcon,
        'boardsize' : boardSize,
        'winner' : null,
        'winnericon' : null
      });

      print('Game created successfully with ID: ${gameRef.id}');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              gameId: gameRef.id,
            ),
          ),(route) => false,);
    }
  } catch (e) {
    print('Error creating game: $e');
  }
}
