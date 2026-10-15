import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Driver Login
  Future<User?> loginDriver(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('login_time', DateTime.now().millisecondsSinceEpoch);
      }

      return credential.user;
    } catch (e) {
      debugPrint("Login Error: $e");
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_time');
    await _auth.signOut();
  }
}