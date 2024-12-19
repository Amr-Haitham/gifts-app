import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'auth_utility_functions.dart';

class FirebaseAuthServices {
  // a private constructor and a static instance (Singleton pattern).
  FirebaseAuthServices._privateConstructor();
  static final FirebaseAuthServices instance =
      FirebaseAuthServices._privateConstructor();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      AuthUtilityFunctions.setAccessToken(userCredential.user!.uid);
      debugPrint(
          "\n\n\n\n\n userCredential.user.uid: ${userCredential.user!.toString()}\n\n\n\n\n");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToMessage(e);
    }
  }

  Future<User?> register(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      AuthUtilityFunctions.setAccessToken(userCredential.user!.uid);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToMessage(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    AuthUtilityFunctions.resetAccessToken();
  }

  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToMessage(e);
    }
    AuthUtilityFunctions.resetAccessToken();
    AuthUtilityFunctions.resetStorage();
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToMessage(e);
    }
  }

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> updateEmail({required String newEmail}) async {
    try {
      await _firebaseAuth.currentUser!.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToMessage(e);
    }
  }

  Future<void> updatePassword({required String newPassword}) async {
    try {
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthExceptionToMessage(e);
    }
  }

  String _mapFirebaseAuthExceptionToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return 'An unknown error occurred.';
    }
  }
}
