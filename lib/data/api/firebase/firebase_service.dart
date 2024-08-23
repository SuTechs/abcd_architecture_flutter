import 'package:flutter/foundation.dart';

import 'firebase_native.dart';

// CollectionKeys
class FireIds {
  static const user = "User";
}

class FirebaseFactory {
  static bool _initComplete = false;

  static Future<FirebaseService> create() async {
    final FirebaseService service = NativeFirebaseService();
    if (_initComplete == false) {
      await service.init();
      _initComplete = true;
    }
    return service;
  }
}

// Interface / Base class
// Combination of abstract methods that must be implemented, and concrete methods that are shared.
abstract class FirebaseService {
  /// /////////////////////////////////////////////////
  /// Concrete Methods
  /// //////////////////////////////////////////////////

  // shared setUserId method
  String? userId;

  List<String> get userPath => [FireIds.user, userId ?? ""];

  ///////////////////////////////////////////////////
  // Abstract Methods
  //////////////////////////////////////////////////
  Future<void> init();

  // Auth
  Future<void> verifyPhoneNative({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String userId) onAutoVerified,
    required void Function(String failedMessage) onVerificationFailed,
  });

  Future<String?> verifyOtpMobile(String otp, String verificationId);

  // Future<String?> signInWithPhoneWeb(String phone);

  bool get isSignedIn;

  @mustCallSuper
  Future<void> signOut() async {
    userId = null;
  }

  Future<Map<String, dynamic>?> getDoc(List<String> keys);

  Future<String> addDoc(List<String> keys, Map<String, dynamic> json,
      {String documentId});

  Future<void> updateDoc(List<String> keys, Map<String, dynamic> json);

  Future<void> upsertDoc(List<String> keys, Map<String, dynamic> json);

  Future<void> deleteDoc(List<String> keys);

  Future<List<Map<String, dynamic>>?> getCollection(List<String> keys);

  Future<List<Map<String, dynamic>>?> getCollectionWhere(
    List<String> keys,
    Object field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  });

  Future<int?> getCount(List<String> keys);

  Future<int?> getCountWhere(
    List<String> keys,
    Object field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  });

  Future<String?> uploadFile(String filePath, String uploadPath);

  Future<bool> deleteFile(String url);

  Future<String?> signInWithGoogle();
}
