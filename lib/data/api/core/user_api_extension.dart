import '../../data/user/user_data.dart';

/// Feature mixin: User API operations.
///
/// Added to [BaseApiService] via `with UserApiMixin`.
/// Every backend (Firebase, Supabase, HTTP, Mock) must implement these.
mixin UserApiMixin {
  Future<UserData?> getUser(String userId);
  Future<void> upsertUser(UserData user);
  Future<void> deleteUser(String userId);
}
