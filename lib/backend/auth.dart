import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> signInWithEmailAndPassword(
    String email, String password) async {
  try {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    // Getting user data from firebase admins' collection.
    final document = await FirebaseFirestore.instance
        .collection('admins')
        .doc(userCredential.user!.uid)
        .get();

    // Storing user login status, name and email id for future use.
    final preferences = await SharedPreferences.getInstance();
    preferences
      ..setBool('logged_in', true)
      ..setString('name', document['name'] as String)
      ..setString('email', document['email']);
    return null;
  } on FirebaseAuthException catch (e) {
    return e.code;
  }
}
