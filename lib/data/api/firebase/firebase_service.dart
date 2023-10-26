import 'package:flutter/foundation.dart';

import '../../data/user.dart';
import 'firebase_native.dart';

// CollectionKeys
class FireIds {
  static const String user = "User";

  ///
  static const String otherCollection = "Other Collection";
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

  /////////////////////////////////////////////////////////
  // USERS
  /////////////////////////////////////////////////////////
  Future<UserData?> getUser(String userId) async {
    try {
      Map<String, dynamic>? data = await getDoc([FireIds.user, userId]);

      return data == null ? null : UserData.fromJson(data);
    } catch (e) {
      if (kDebugMode) print('hello error 543 = $e');

      return null;
    }
  }

  Future<String> addUser(UserData value) async {
    return await addDoc([FireIds.user], value.toJson(), documentId: value.id);
  }

  Future<void> setUserData(UserData value) async {
    // ToDo: implement update only which is changed to reduce no of writes
    await updateDoc(userPath, value.toJson());
  }

  ///upload images

  Future<String?> uploadProfilePic(String filePath) =>
      uploadFile(filePath, 'pic.png');

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
}
