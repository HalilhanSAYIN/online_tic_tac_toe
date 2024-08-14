import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameService {
  Future<void> updateBoard(String gameId, List<List<String>> board, String turn,
      int row, int col) async {
    String boardString = board.map((row) => row.join(',')).join('|');
    await FirebaseFirestore.instance.collection('games').doc(gameId).update({
      'board': boardString,
      'turn': turn,
      'lastMove': [row, col],
    });
  }

  Stream<DocumentSnapshot> gameStream(String gameId) {
    return FirebaseFirestore.instance
        .collection('games')
        .doc(gameId)
        .snapshots();
  }

  Future<DocumentSnapshot> getGameData(String gameId) async {
    return await FirebaseFirestore.instance
        .collection('games')
        .doc(gameId)
        .get();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> joinGame(String gameId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String nickName = userDoc['nickname'];
      await _firestore.collection('games').doc(gameId).update({
        'player2': user.uid,
        'player2nickname': nickName,
        'status': 'in_progress',
      });
    }
  }

  Future<void> cancelGame(String gameId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('games').doc(gameId).update({
        'status': 'cancelled',
      });
    }
  }
}
