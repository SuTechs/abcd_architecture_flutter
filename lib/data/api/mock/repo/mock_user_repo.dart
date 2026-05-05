import '../../../data/user/user_data.dart';
import '../../core/base_api_service.dart';

/// Mock implementation of [UserApiMixin].
///
/// Uses in-memory maps with Hive persistence.
mixin MockUserRepo on BaseApiService {
  Map<String, UserData> get users;

  Future<void> persistUsers();

  @override
  Future<UserData?> getUser(String userId) async {
    return users[userId];
  }

  @override
  Future<void> upsertUser(UserData user) async {
    users[user.id] = user;
    await persistUsers();
  }

  @override
  Future<void> deleteUser(String userId) async {
    users.remove(userId);
    await persistUsers();
  }
}
