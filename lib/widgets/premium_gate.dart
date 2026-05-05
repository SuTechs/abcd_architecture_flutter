import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/router/routes.dart';
import '../data/bloc/user_bloc.dart';

/// Wraps a UI element that requires a premium subscription.
///
/// If the user is premium, [child] is shown.
/// If not, [fallback] is shown. If no [fallback] is provided, the [child] is
/// shown but visually disabled (opacity 50%) and tapping it routes to the premium screen.
class PremiumGate extends ConsumerWidget {
  final Widget child;
  final Widget? fallback;

  const PremiumGate({super.key, required this.child, this.fallback});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userBlocProvider);

    if (user.isPremium) {
      return child;
    }

    if (fallback != null) {
      return fallback!;
    }

    return GestureDetector(
      onTap: () => context.push(AppRoutes.premium),
      child: Opacity(
        opacity: 0.5,
        child: IgnorePointer(ignoring: true, child: child),
      ),
    );
  }
}
