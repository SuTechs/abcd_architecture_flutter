import '../../../data/user/user_data.dart';
import '../../core/base_api_service.dart';
import '../supabase_native.dart';

/// Supabase implementation of [UserApiMixin].
///
/// Uses [SupabaseNative] for raw database operations.
mixin SupabaseUserRepo on BaseApiService {
  SupabaseNative get native;

  @override
  Future<UserData?> getUser(String userId) async {
    final data = await native.selectOne('users', userId);
    if (data == null) return null;
    return UserData.fromJson(data);
  }

  @override
  Future<void> upsertUser(UserData user) async {
    await native.upsert('users', user.toJson());
  }

  @override
  Future<void> deleteUser(String userId) async {
    await native.delete('users', userId);
  }
}
