import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/providers.dart';
import '../data/user/user_data.dart';

final authBlocProvider = AsyncNotifierProvider<AuthBloc, UserData?>(
  AuthBloc.new,
);

class AuthBloc extends AsyncNotifier<UserData?> {
  @override
  Future<UserData?> build() async {
    final api = ref.watch(apiServiceProvider);
    final storage = ref.watch(localStorageProvider);

    if (!api.isSignedIn) {
      final isGuest = storage.getBool('is_guest_session') ?? false;
      if (isGuest) {
        return UserData.guest();
      }
      return null;
    }

    final userId = api.currentUserId;
    if (userId == null) {
      return null;
    }

    // Try fetching user from API
    try {
      final user = await api.getUser(userId);
      return user;
    } catch (e) {
      // Handle error, e.g., network issue
      return null;
    }
  }

  void setAuthenticatedUser(UserData user) {
    state = AsyncData(user);
  }

  void logout() {
    state = const AsyncData(null);
  }
}
