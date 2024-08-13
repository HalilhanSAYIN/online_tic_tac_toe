import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> signInAnonymously() async {
  try {
    UserCredential userCredential = await _auth.signInAnonymously();
    User? user = userCredential.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'createdAt': Timestamp.now(),
      });
      print('signing succes');
    }
  } catch (e) {
    print('Error signing : $e');
  }
}
