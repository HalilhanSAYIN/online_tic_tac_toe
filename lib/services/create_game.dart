import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createGame() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String board =
            List.generate(3, (_) => List.generate(3, (_) => '').join(','))
                .join('|');

        DocumentReference gameRef = await _firestore.collection('games').add({
          'player1': user.uid,
          'player2': null,
          'status': 'waiting',
          'board': board, 
          'createdAt': Timestamp.now(),
          'currentPlayer': user.uid, 
          'turn': 'player1',
        });

        print('Game created successfully with ID: ${gameRef.id}');
        /**
         nav to game screen
         */
      }
    } catch (e) {
      print('Error creating game: $e');
    }
  }