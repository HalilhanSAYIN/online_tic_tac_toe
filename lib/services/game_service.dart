import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> joinGame(String gameId) async {
    User? user = _auth.currentUser;
    if (user != null) {
       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        String nickName = userDoc['nickname'];
      await _firestore.collection('games').doc(gameId).update({
        'player2': user.uid,
        'player2Nickname' : nickName,
        'status': 'in_progress',
      });
    }
  }

  Future<void> updateBoard(String gameId, List<List<String>> board, String nextTurn, int row, int col) async {
    User? user = _auth.currentUser;
    if (user != null) {
      
      String boardString = board.map((row) => row.join(',')).join('|');
      await _firestore.collection('games').doc(gameId).update({
        'board': boardString,
        'turn': nextTurn,
        'lastMove': {
          'player': user.uid,
          'row': row,
          'col': col,
        },
      });
    }
  }

  Future<DocumentSnapshot> getGameData(String gameId) async {
    return await _firestore.collection('games').doc(gameId).get();
  }

  Stream<DocumentSnapshot> gameStream(String gameId) {
    return _firestore.collection('games').doc(gameId).snapshots();
  }
}