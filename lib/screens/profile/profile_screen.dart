import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/extensions.dart';
import '../../data/bloc/app_bloc.dart';
import '../../data/bloc/user_bloc.dart';
import '../../data/command/auth/auth_command.dart';
import '../../data/data/app/app_constants.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userBlocProvider);
    final appState = ref.watch(appBlocProvider);
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Avatar & Info ──
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: colorScheme.primaryContainer,
                  child: user.imageUrl != null && user.imageUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            user.imageUrl!,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'G',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name.isEmpty ? 'Guest' : user.name,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user.email.isNotEmpty || user.phone.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.email.isNotEmpty ? user.email : user.phone,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Premium ──
          if (user.isPremium)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [AppColors.premiumGold, AppColors.premiumGoldDark],
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.black87),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Premium Member',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.workspace_premium,
                  color: AppColors.premiumGold,
                ),
                title: const Text('Go Premium'),
                subtitle: const Text('Unlock all features'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.premium),
              ),
            ),
          const SizedBox(height: 20),

          // ── Preferences Section ──
          Text(
            'Preferences',
            style: context.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.palette_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 16),
                          Text('Theme', style: context.textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.light,
                              icon: Icon(Icons.light_mode, size: 18),
                            ),
                            ButtonSegment(
                              value: ThemeMode.system,
                              icon: Icon(Icons.brightness_auto, size: 18),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              icon: Icon(Icons.dark_mode, size: 18),
                            ),
                          ],
                          selected: {appState.themeMode},
                          onSelectionChanged: (set) {
                            ref
                                .read(appBlocProvider.notifier)
                                .setThemeMode(set.first);
                          },
                          showSelectedIcon: false,
                          style: const ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Danger Zone ──
          Text(
            'Account',
            style: context.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: user.isGuest
                ? ListTile(
                    leading: Icon(Icons.login, color: colorScheme.primary),
                    title: Text(
                      'Login / Create Account',
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    onTap: () => context.push(AppRoutes.login),
                  )
                : ListTile(
                    leading: Icon(Icons.logout, color: colorScheme.error),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: colorScheme.error),
                    ),
                    onTap: () => AuthCommand().logout(),
                  ),
          ),

          const SizedBox(height: 48),
          Center(
            child: Text(
              'v$kAppVersion',
              style: context.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
