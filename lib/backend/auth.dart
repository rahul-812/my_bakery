import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> signInWithEmailAndPassword(
    String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    // Storing user login status, name and email id for future use.
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool('logged_in', true);

    return null;
  } on FirebaseAuthException catch (e) {
    return e.code;
  }
}
