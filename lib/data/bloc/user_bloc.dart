import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/user/user_data.dart';
import 'auth_bloc.dart';

/// Provides a non-null [UserData] for the rest of the app.
/// If not logged in, returns [UserData.guest()].
final userBlocProvider = NotifierProvider<UserBloc, UserData>(UserBloc.new);

class UserBloc extends Notifier<UserData> {
  @override
  UserData build() {
    // Watch AuthBloc. If auth bloc has a user, we use it, otherwise guest.
    final authState = ref.watch(authBlocProvider);
    return authState.valueOrNull ?? UserData.guest();
  }

  /// Optimistically update user profile UI
  void updateProfileLocally(UserData updatedUser) {
    state = updatedUser;
    // Also sync to auth bloc so they stay in sync
    ref.read(authBlocProvider.notifier).setAuthenticatedUser(updatedUser);
  }
}
