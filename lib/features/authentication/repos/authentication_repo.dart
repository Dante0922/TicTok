import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  //main에서 Firebase.initializeApp가 끝나면 다이렉트로 firebase와 연결이 된다.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //getter.. 좀 더 공부해보자.
  User? get user => _firebaseAuth.currentUser;
  bool get isLoggedIn => user != null;

  // 백엔드와 UI를 연결해주는 Stream. 로그인 상태 등을 실시간으로 알 수 있다.
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<UserCredential> emailSignUp(
    String email,
    String password,
  ) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> githubSignIn() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());

final authState = StreamProvider((ref) {
  final repo = ref.read(authRepo);
  return repo.authStateChanges();
});
