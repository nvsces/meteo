import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:meteo/models/user.dart';

class AuthService {
  final firebase.FirebaseAuth _fAuth = firebase.FirebaseAuth.instance;

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      var result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      firebase.User user = result.user;
      return User.fromFirebase(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> registrWithEmailAndPassword(
      String email, String password) async {
    try {
      var result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebase.User user = result.user;
      return User.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<User> get currentUser {
    return _fAuth.authStateChanges().map(
        (firebase.User user) => user != null ? User.fromFirebase(user) : null);
  }
}
