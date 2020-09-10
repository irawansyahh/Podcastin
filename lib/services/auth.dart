import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _fb = FirebaseAuth.instance;

  currentUser() async {
    return await _fb.currentUser();
  }

  Future registerWithEmail(String email, String password) async {
    return await _fb.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future loginWithEmail(String email, String password) async {
    return await _fb.signInWithEmailAndPassword(
        email: email, password: password);
  }

  signOut() async {
    await _fb.signOut();
  }
}
