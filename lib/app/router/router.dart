import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/bloc/app_bloc.dart';
import '../../data/bloc/auth_bloc.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/verify_otp_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/premium/premium_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/todos/todo_list_screen.dart';
import '../../widgets/app_scaffold.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final appState = ref.watch(appBlocProvider);
  final authState = ref.watch(authBlocProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      if (!appState.hasBootstrapped) {
        return null; // Wait for bootstrap to complete
      }

      final isLoggingIn = state.matchedLocation.startsWith('/auth');
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;

      if (!appState.isOnboardingComplete) {
        return isOnboarding ? null : AppRoutes.onboarding;
      }

      final user = authState.valueOrNull;
      final isGuest = user?.isGuest ?? false;
      final isLoggedIn = user != null && !isGuest;

      // If absolutely no user data, must log in
      if (user == null) {
        return isLoggingIn ? null : AppRoutes.login;
      }

      // If fully logged in, prevent accessing login/onboarding
      if (isLoggedIn && (isLoggingIn || isOnboarding)) {
        return AppRoutes.home;
      }

      // If guest, allow accessing login, but prevent onboarding
      if (isGuest && isOnboarding) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (context, state) => const VerifyOtpScreen(),
      ),
      GoRoute(
        path: AppRoutes.premium,
        builder: (context, state) => const PremiumScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.todos,
            builder: (context, state) => const TodoListScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
