import '../../bloc/auth_bloc.dart';
import '../../bloc/user_bloc.dart';
import '../base_command.dart';

class UserCommand extends BaseCommand {
  Future<void> updateProfile({String? name, String? phone}) async {
    final user = ref.read(userBlocProvider);
    if (user.isGuest) return;

    final updated = user.copyWith(
      name: name ?? user.name,
      phone: phone ?? user.phone,
      updatedAt: DateTime.now(),
    );

    // Optimistic update
    userBloc.updateProfileLocally(updated);

    try {
      await api.upsertUser(updated);
    } catch (e) {
      // If error, refetch to revert
      ref.invalidate(authBlocProvider);
    }
  }

  Future<void> uploadAvatar(String localPath) async {
    final user = ref.read(userBlocProvider);
    if (user.isGuest) return;

    try {
      final remotePath =
          'avatars/${user.id}_${DateTime.now().millisecondsSinceEpoch}';
      final downloadUrl = await api.uploadFile(localPath, remotePath);

      if (downloadUrl != null) {
        final updated = user.copyWith(
          imageUrl: downloadUrl,
          updatedAt: DateTime.now(),
        );
        userBloc.updateProfileLocally(updated);
        await api.upsertUser(updated);
      }
    } catch (e) {
      // Handle upload error
    }
  }
}
