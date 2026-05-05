import '../../api/providers.dart';
import '../../api/services/analytics_service.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/todo_bloc.dart';
import '../../data/app/app_constants.dart';
import '../../data/user/user_data.dart';
import '../base_command.dart';

class AuthCommand extends BaseCommand {
  Future<String?> sendOtp(AuthMethod method, String destination) async {
    try {
      final verificationId = await api.sendOtp(
        destination: destination,
        isEmail: method == AuthMethod.email,
      );
      return verificationId;
    } catch (e) {
      // Handle error gracefully in real app (e.g. snackbar)
      return null;
    }
  }

  Future<bool> verifyOtp(String otp, String verificationId) async {
    try {
      final userId = await api.verifyOtp(
        otp: otp,
        verificationId: verificationId,
      );
      if (userId != null) {
        AnalyticsService.logEvent('login', parameters: {'method': 'otp'});
        ref.invalidate(authBlocProvider);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final userId = await api.signInWithGoogle();
      if (userId != null) {
        AnalyticsService.logEvent('login', parameters: {'method': 'google'});
        ref.invalidate(authBlocProvider);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      final userId = await api.signInWithApple();
      if (userId != null) {
        AnalyticsService.logEvent('login', parameters: {'method': 'apple'});
        ref.invalidate(authBlocProvider);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> signInAsGuest() async {
    AnalyticsService.logEvent('login', parameters: {'method': 'guest'});
    await ref.read(localStorageProvider).setBool('is_guest_session', true);
    ref.read(authBlocProvider.notifier).setAuthenticatedUser(UserData.guest());
  }

  Future<void> logout() async {
    await api.signOut();
    await ref.read(localStorageProvider).remove('is_guest_session');
    AnalyticsService.logEvent('logout');
    ref.invalidate(authBlocProvider);
    ref.invalidate(todoBlocProvider);
  }
}
