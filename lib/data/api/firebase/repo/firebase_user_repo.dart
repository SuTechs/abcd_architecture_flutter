import '../../../data/user/user_data.dart';
import '../../core/base_api_service.dart';
import '../firebase_native.dart';

/// Firebase implementation of [UserApiMixin].
///
/// Uses [FirebaseNative] for raw Firestore operations.
/// Access [native] via the service that mixes this in.
mixin FirebaseUserRepo on BaseApiService {
  FirebaseNative get native;

  @override
  Future<UserData?> getUser(String userId) async {
    final doc = await native.getDoc('users', userId);
    if (!doc.exists || doc.data() == null) return null;
    return UserData.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> upsertUser(UserData user) async {
    await native.setDoc('users', user.id, user.toJson());
  }

  @override
  Future<void> deleteUser(String userId) async {
    await native.deleteDoc('users', userId);
  }
}
