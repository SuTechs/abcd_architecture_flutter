import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/user/user.dart';
import '../../utils/time_utils.dart';
import 'firebase_service.dart';
import 'service_extension.dart';

/// Native implementation of firebase service
class NativeFirebaseService extends FirebaseService {
  FirebaseFirestore get fireStore => FirebaseFirestore.instance;

  FirebaseAuth get auth => FirebaseAuth.instance;

  FirebaseStorage get storage => FirebaseStorage.instance;

  DocumentReference get userDoc => fireStore.doc(userPath.join("/"));

  // DocumentReference get userDoc =>  FirebaseStorage.instance.ref();
  Reference get userStorageRef => storage.ref(userPath.join("/"));

  @override
  Future<void> init() async {
    try {
      await Firebase.initializeApp(
          // ToDo: Configure Firebase Options using FlutterFire
          // options: DefaultFirebaseOptions.currentPlatform,
          );

      await FirebaseAppCheck.instance.activate();

      if (kIsWeb) {
        await auth.setPersistence(Persistence.LOCAL);
      }
      log("InitComplete");
      FirebaseAuth.instance.userChanges().listen((User? user) {
        _isSignedIn = user != null;
        log("UserChange");
      });
    } catch (e) {
      log("FirebaseInit Error = $e");
    }
    // // Handle background messages
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //
    // // Handle foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  // Auth
  @override
  Future<void> verifyPhoneNative({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String userId) onAutoVerified,
    required void Function(String failedMessage) onVerificationFailed,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (String verificationId, int? resendToken) {
          log('codeSent Verification Id = $verificationId');
          onCodeSent(verificationId);
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('hello verification auto completed ${credential.smsCode}');

          final user = await auth.signInWithCredential(credential);

          if (user.user != null) {
            final isNewUser = user.additionalUserInfo!.isNewUser;
            if (isNewUser) {
              debugPrint('Welcome New User: Adding to firestore!');
              await addUser(
                UserData(
                  id: user.user!.uid,
                  phone: user.user!.phoneNumber!,
                  createdAt: TimeUtils.nowMillis,
                  updatedAt: TimeUtils.nowMillis,
                  name: user.user!.displayName ?? '',
                ),
              );
            }

            onAutoVerified(user.user!.uid);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            log('The provided phone number is not valid.');
            onVerificationFailed('Invalid Phone Number');
            return;
          }

          log('Error = ${e.message}');
          onVerificationFailed(
              e.message ?? "Something went wrong! [code: s032]");

          // Handle other errors
        },
        codeAutoRetrievalTimeout: (verificationId) {
          log('TimeOut Verification Id = $verificationId');
        },
      );
    } catch (e) {
      log('SendOTPError = $e');
    }
  }

  @override
  Future<String?> verifyOtpMobile(String otp, String verificationId) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    final user = await auth.signInWithCredential(credential);

    final isNewUser = (user.additionalUserInfo?.isNewUser) ?? false;
    if (isNewUser) {
      debugPrint('Welcome New User: Adding to firestore!');
      await addUser(
        UserData(
          id: user.user!.uid,
          phone: user.user!.phoneNumber!,
          createdAt: TimeUtils.nowMillis,
          updatedAt: TimeUtils.nowMillis,
          name: user.user!.displayName ?? '',
        ),
      );
    }

    return user.user?.uid;
  }

  /// google sign in

  @override
  Future<String?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();

    try {
      debugPrint('Google User : $googleUser');
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user = await auth.signInWithCredential(credential);

      final userData = user.user;

      debugPrint(
          'Firebase User : $userData and additional info = ${user.additionalUserInfo}');

      if (userData == null) return null;

      final isNewUser = (user.additionalUserInfo?.isNewUser) ?? false;

      if (isNewUser) {
        debugPrint('Welcome New User: Adding to firestore!');
        await addUser(
          UserData(
            id: userData.uid,
            phone: userData.phoneNumber,
            email: googleUser.email,
            name: googleUser.displayName ?? '',
            createdAt: TimeUtils.nowMillis,
            updatedAt: TimeUtils.nowMillis,
          ),
        );
      }

      return userData.uid;
    } catch (e) {
      log('GoogleSignInError = $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
    super.signOut();
  }

  bool _isSignedIn = false;

  @override
  bool get isSignedIn => _isSignedIn;

  /// CRUD

  @override
  Future<String> addDoc(List<String> keys, Map<String, dynamic> json,
      {String? documentId}) async {
    if (documentId != null) {
      keys.add(documentId);
      log("Add Doc ${getPathFromKeys(keys)}");
      await fireStore.doc(getPathFromKeys(keys)).set(json);
      log("Add Doc Complete");
      return documentId;
    }
    CollectionReference ref = fireStore.collection(getPathFromKeys(keys));
    final doc = await ref.add(json);
    return (doc).id;
  }

  @override
  Future<void> deleteDoc(List<String> keys) async =>
      await fireStore.doc(getPathFromKeys(keys)).delete();

  @override
  Future<void> updateDoc(
    List<String> keys,
    Map<String, dynamic> json,
  ) async {
    await fireStore.doc(getPathFromKeys(keys)).update(json);
  }

  // upsert doc
  @override
  Future<void> upsertDoc(
    List<String> keys,
    Map<String, dynamic> json,
  ) async {
    await fireStore
        .doc(getPathFromKeys(keys))
        .set(json, SetOptions(merge: true));
  }

  @override
  Future<Map<String, dynamic>?> getDoc(List<String> keys) async {
    try {
      if (checkKeysForNull(keys) == false) return null;
      DocumentSnapshot<Map<String, dynamic>> d =
          await fireStore.doc(getPathFromKeys(keys)).get();

      // if (!d.exists) return null; // data is null

      // return (d.data()!)..['documentId'] = d.id..['isExist'] = d.exists;

      return d.data()?..['documentId'] = d.id;
    } catch (e) {
      if (kDebugMode) print('getDoc error(0x67) = $e ');
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>?> getCollection(List<String> keys) async {
    if (checkKeysForNull(keys) == false) return null;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await fireStore.collection(getPathFromKeys(keys)).get();

    for (final d in snapshot.docs) {
      (d.data())['documentId'] = d.id;
    }
    return snapshot.docs.map((d) => (d.data())).toList();
  }

  @override
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
  }) async {
    if (checkKeysForNull(keys) == false) return null;

    QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
        .collection(getPathFromKeys(keys))
        .where(
          field,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThan: isLessThan,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThan: isGreaterThan,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          isNull: isNull,
        )
        .get();

    for (final d in snapshot.docs) {
      (d.data())['documentId'] = d.id;
    }
    return snapshot.docs.map((d) => (d.data())).toList();
  }

  /// count
  @override
  Future<int?> getCount(List<String> keys) async {
    if (checkKeysForNull(keys) == false) return null;
    final result =
        await fireStore.collection(getPathFromKeys(keys)).count().get();

    return result.count;
  }

  /// get count where
  @override
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
  }) async {
    if (checkKeysForNull(keys) == false) return null;
    final result = await fireStore
        .collection(getPathFromKeys(keys))
        .where(
          field,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThan: isLessThan,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThan: isGreaterThan,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          isNull: isNull,
        )
        .count()
        .get();

    return result.count;
  }

  bool checkKeysForNull(List<String> keys) {
    if (keys.contains(null)) {
      log("ERROR: invalid key was passed to firestore: $keys");
      return false;
    }
    return true;
  }

  // Helper method for getting a path from keys (users/id)
  String getPathFromKeys(List<String> keys) {
    String path = keys.join("/");
    // addUserPath ? userPath.followedBy(keys).join("/") : keys.join("/");
    return path.replaceAll("//", "/");
  }

  @override
  Future<String?> uploadFile(String filePath, String uploadPath) async {
    final ref = userStorageRef.child(uploadPath);
    final file = File(filePath);

    try {
      await ref.putFile(file);

      return await ref.getDownloadURL();
    } catch (e) {
      log('File Upload Error = $e');
    }

    return null;
  }

  @override
  Future<bool> deleteFile(String url) async {
    try {
      final ref = storage.refFromURL(url);
      await ref.delete();
      return true;
    } catch (e) {
      log('Storage Delete Error = $e');
    }
    return false;
  }
}
