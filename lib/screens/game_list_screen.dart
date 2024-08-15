import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/const/text_styles.dart';
import 'package:online_tic_tac_toe/screens/game_create_screen.dart';
import 'package:online_tic_tac_toe/screens/game_screen.dart';

class GamesListScreen extends StatefulWidget {
  @override
  _GamesListScreenState createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _joinGame(String gameId) async {
    try {
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              gameId: gameId,
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error joining game: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateGameScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Playable games are listed here. If you don't have a game yet, you can create it yourself.",
              style: defaultFontSize,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('games')
                  .where('status', isEqualTo: 'waiting')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CupertinoActivityIndicator());
                }
                final games = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      final gameId = game.id;
                      return ListTile(
                        title: Text('Game ID: $gameId'),
                        subtitle:
                            Text('Created by: ${game['player1nickname']}'),
                        trailing: ElevatedButton(
                          onPressed: () => _joinGame(gameId),
                          child: const Text('Join Game'),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
