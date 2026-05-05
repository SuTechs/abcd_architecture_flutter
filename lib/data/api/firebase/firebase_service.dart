import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import '../core/base_api_service.dart';
import '../services/app_logger.dart';
import 'firebase_init.dart';
import 'firebase_native.dart';
import 'repo/firebase_todo_repo.dart';
import 'repo/firebase_user_repo.dart';

/// Firebase implementation of [BaseApiService].
///
/// Core auth & storage live here. Feature repos are mixed in:
///   - [FirebaseUserRepo] — user CRUD
///   - [FirebaseTodoRepo] — todo CRUD
///
/// To add a new feature, create `repo/firebase_xyz_repo.dart` and mix it in.
class FirebaseService extends BaseApiService
    with FirebaseUserRepo, FirebaseTodoRepo {
  late final FirebaseNative _native;

  /// Exposed for repo mixins to access raw Firebase operations.
  @override
  FirebaseNative get native => _native;

  @override
  Future<void> init() async {
    final initialized = await FirebaseInit.initialize();
    if (!initialized) {
      throw StateError('Firebase failed to initialize.');
    }
    _native = FirebaseNative();
  }

  @override
  bool get isSignedIn => native.currentUser != null;

  @override
  String? get currentUserId => native.currentUser?.uid;

  // ── Auth ─────────────────────────────────────────────────

  @override
  Future<String?> sendOtp({
    required String destination,
    required bool isEmail,
  }) async {
    if (isEmail) {
      AppLogger.warning(
        'Firebase email OTP is not implemented in this starter.',
        tag: 'FirebaseService',
      );
      return null;
    }

    final completer = Completer<String?>();

    await native.verifyPhone(
      phone: destination,
      codeSent: (verificationId, forceResendingToken) {
        if (!completer.isCompleted) completer.complete(verificationId);
      },
      verificationFailed: (error) {
        if (!completer.isCompleted) completer.completeError(error);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        if (!completer.isCompleted) completer.complete(verificationId);
      },
    );

    return completer.future;
  }

  @override
  Future<String?> verifyOtp({
    required String otp,
    required String verificationId,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final result = await native.signInWithCredential(credential);
      return result.user?.uid;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> signInWithGoogle() async {
    try {
      final result = await native.signInWithGoogle();
      return result?.user?.uid;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> signInWithApple() async {
    try {
      final result = await native.signInWithApple();
      return result.user?.uid;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await native.signOut();
  }

  // ── Storage ──────────────────────────────────────────────

  @override
  Future<String?> uploadFile(String localPath, String remotePath) async {
    try {
      return await native.uploadFile(localPath, remotePath);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteFile(String remotePath) async {
    try {
      await native.deleteFile(remotePath);
      return true;
    } catch (e) {
      return false;
    }
  }
}
