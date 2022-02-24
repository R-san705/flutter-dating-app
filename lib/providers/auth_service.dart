import 'package:firebase_auth/firebase_auth.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserAttributes? _userFromFirebase(User? user) {
    if (user != null && user.emailVerified == true) {
      return UserAttributes(user.uid, user.email);
    }
    return null;
  }

  Stream<UserAttributes?>? get userAttributes {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      throw '${e.message}';
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userCredential;
    } on FirebaseAuthException catch (e) {
      throw '${e.message}';
    }
  }

  Future<bool?> checkEmailVerified(User user) async {
    return user.emailVerified;
  }

  Future<UserAttributes?> sentEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw '${e.message}';
    }
  }
}
