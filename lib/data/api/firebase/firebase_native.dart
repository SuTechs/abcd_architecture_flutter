import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Raw Firebase operations wrapper (No app-specific models)
class FirebaseNative {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Auth
  User? get currentUser => auth.currentUser;
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<void> verifyPhone({
    required String phone,
    required Function(String, int?) codeSent,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (_) {}, // Handled manually by user typing OTP
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return await auth.signInWithCredential(credential);
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await auth.signInWithCredential(credential);
  }

  /// Sign in with Apple using Firebase's built-in [AppleAuthProvider].
  ///
  /// No external package needed — Firebase Auth handles the Apple OAuth flow.
  /// Requires Apple Sign-In capability in Xcode and Apple Developer Console.
  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');

    return await auth.signInWithProvider(appleProvider);
  }

  Future<void> signOut() async {
    await Future.wait([auth.signOut(), googleSignIn.signOut()]);
  }

  // Firestore
  Future<DocumentSnapshot> getDoc(String collection, String id) {
    return db.collection(collection).doc(id).get();
  }

  Future<void> addDoc(String collection, Map<String, dynamic> data) {
    return db.collection(collection).add(data);
  }

  Future<void> setDoc(String collection, String id, Map<String, dynamic> data) {
    return db.collection(collection).doc(id).set(data, SetOptions(merge: true));
  }

  Future<void> deleteDoc(String collection, String id) {
    return db.collection(collection).doc(id).delete();
  }

  Future<QuerySnapshot> getCollectionWhere(
    String collection,
    String field,
    dynamic isEqualTo,
  ) {
    return db.collection(collection).where(field, isEqualTo: isEqualTo).get();
  }

  // Storage
  Future<String> uploadFile(String localPath, String remotePath) async {
    final file = File(localPath);
    final ref = storage.ref().child(remotePath);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> deleteFile(String remotePath) async {
    await storage.ref().child(remotePath).delete();
  }
}
