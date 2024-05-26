import 'package:chat_app/models/response_model.dart';
import 'package:chat_app/utils/print.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLogged = false;
  bool _loading = true;

  bool get isLogged => _isLogged;
  bool get loading => _loading;

  User? _loggedUser;
  User? get loggedUser => _loggedUser;

  init() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _loading = false;
      if (user == null) {
        dPrint('User is currently signed out!');
        _isLogged = false;
        notifyListeners();
      } else {
        dPrint('User is signed in!');
        _isLogged = true;
        _loggedUser = user;
        notifyListeners();
      }
    });
  }

  Future<ResponseModel> login(String username, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);

      return ResponseModel(code: 200, data: credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const ResponseModel(
            code: 500, errorText: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return const ResponseModel(
            code: 500, errorText: 'Wrong password provided for that user.');
      }
      return const ResponseModel(code: 500, errorText: 'Can\'t login');
    }
  }

  Future<ResponseModel> registerUser(String username, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      return ResponseModel(code: 200, data: credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return const ResponseModel(
            code: 500, errorText: 'The account already exists for that email.');
      }
      return const ResponseModel(
          code: 500, errorText: 'There was an error register');
    } catch (e) {
      dPrint(e);
      return const ResponseModel(
          code: 500, errorText: 'There was an error register');
    }
  }

  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }
}
