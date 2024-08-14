import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_tic_tac_toe/screens/game_list_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> signInAnonymously(context,String nickname) async {
  try {
    UserCredential userCredential = await _auth.signInAnonymously();
    User? user = userCredential.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'createdAt': Timestamp.now(),
        'nickname' : nickname
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => GamesListScreen(),));
      print('signing succes');
    }
  } catch (e) {
    print('Error signing : $e');
  }
}
