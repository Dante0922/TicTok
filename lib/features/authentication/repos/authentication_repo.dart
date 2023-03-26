import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  //main에서 Firebase.initializeApp가 끝나면 다이렉트로 firebase와 연결이 된다.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //getter.. 좀 더 공부해보자.
  User? get user => _firebaseAuth.currentUser;
  bool get isLoggedIn => user != null;

  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());
