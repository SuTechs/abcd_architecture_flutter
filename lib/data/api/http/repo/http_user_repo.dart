import '../../../data/user/user_data.dart';
import '../../core/base_api_service.dart';
import '../http_native.dart';

/// HTTP implementation of [UserApiMixin].
///
/// Uses [HttpNative] for raw REST API calls.
mixin HttpUserRepo on BaseApiService {
  HttpNative get native;

  @override
  Future<UserData?> getUser(String userId) async {
    try {
      final res = await native.get('/users/$userId');
      return UserData.fromJson(res.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> upsertUser(UserData user) async {
    await native.put('/users/${user.id}', data: user.toJson());
  }

  @override
  Future<void> deleteUser(String userId) async {
    await native.delete('/users/$userId');
  }
}
