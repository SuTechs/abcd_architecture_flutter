import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/extensions.dart';
import '../../data/bloc/todo_bloc.dart';
import '../../data/bloc/user_bloc.dart';
import '../../widgets/ads/ad_banner_widget.dart';
import '../../widgets/ads/ad_native_widget.dart';
import '../../widgets/premium_gate.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userBlocProvider);
    final todosAsync = ref.watch(todoBlocProvider);
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Welcome Card ──
          _WelcomeCard(user: user),
          const SizedBox(height: 24),

          // ── Stats ──
          todosAsync.when(
            data: (todos) {
              final completed = todos.where((t) => t.isCompleted).length;
              final total = todos.length;
              final percent = total == 0 ? 0.0 : completed / total;
              final activeTasks = total - completed;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Progress Card ──
                  Text(
                    'Your Progress',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$completed of $total tasks',
                                style: context.textTheme.bodyLarge,
                              ),
                              Text(
                                '${(percent * 100).toInt()}%',
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: percent,
                              minHeight: 10,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Quick Stats Grid ──
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.check_circle_outline,
                          label: 'Completed',
                          value: '$completed',
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.pending_outlined,
                          label: 'Active',
                          value: '$activeTasks',
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.list_alt,
                          label: 'Total',
                          value: '$total',
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Native Ad (for free users) ──
                  if (!user.isPremium) ...[
                    const AdNativeWidget(),
                    const SizedBox(height: 24),
                  ],

                  // ── Premium Analytics Section ──
                  PremiumGate(
                    fallback: _LockedAnalytics(
                      onTap: () => context.push(AppRoutes.premium),
                    ),
                    child: _PremiumAnalytics(
                      completed: completed,
                      total: total,
                      todos: todos,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Quick Actions ──
                  Text(
                    'Quick Actions',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.add_task,
                          label: 'Add Todo',
                          color: colorScheme.primary,
                          onTap: () => context.go(AppRoutes.todos),
                        ),
                      ),
                      if (!user.isPremium) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.diamond_rounded,
                            label: 'Go Premium',
                            color: AppColors.premiumGold,
                            onTap: () => context.push(AppRoutes.premium),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, s) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error loading stats: $e'),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Banner Ad ──
          if (!user.isPremium) const AdBannerWidget(),
        ],
      ),
    );
  }
}

// ── Welcome Card ──────────────────────────────────────────────

class _WelcomeCard extends StatelessWidget {
  final dynamic user;
  const _WelcomeCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: user.imageUrl != null && user.imageUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      user.imageUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  )
                : Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'G',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.name.isEmpty ? 'Guest' : user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (user.isPremium)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.premiumGold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 14, color: Colors.black87),
                  SizedBox(width: 4),
                  Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Premium Analytics (unlocked) ──────────────────────────────

class _PremiumAnalytics extends StatelessWidget {
  final int completed;
  final int total;
  final List<dynamic> todos;

  const _PremiumAnalytics({
    required this.completed,
    required this.total,
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final streak = _calculateStreak();
    final productivityScore = total > 0
        ? ((completed / total) * 100).toInt()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Premium Analytics',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.premiumGold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.premiumGold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _AnalyticTile(
                        icon: Icons.local_fire_department,
                        label: 'Streak',
                        value: '$streak days',
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _AnalyticTile(
                        icon: Icons.speed,
                        label: 'Productivity',
                        value: '$productivityScore%',
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Simple bar chart
                _WeeklyChart(todos: todos),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _calculateStreak() {
    // Simple streak calculation based on consecutive days with completed tasks
    if (todos.isEmpty) return 0;
    final now = DateTime.now();
    int streak = 0;
    for (int i = 0; i < 30; i++) {
      final day = now.subtract(Duration(days: i));
      final hasCompleted = todos.any(
        (t) =>
            t.isCompleted &&
            t.createdAt.year == day.year &&
            t.createdAt.month == day.month &&
            t.createdAt.day == day.day,
      );
      if (hasCompleted) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }
    return streak;
  }
}

class _AnalyticTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _AnalyticTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Simple weekly bar chart — no external packages.
class _WeeklyChart extends StatelessWidget {
  final List<dynamic> todos;
  const _WeeklyChart({required this.todos});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Calculate completed tasks per day of this week
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final counts = List.generate(7, (i) {
      final day = weekStart.add(Duration(days: i));
      return todos
          .where(
            (t) =>
                t.isCompleted &&
                t.createdAt.year == day.year &&
                t.createdAt.month == day.month &&
                t.createdAt.day == day.day,
          )
          .length;
    });

    final maxCount = counts.reduce((a, b) => a > b ? a : b).clamp(1, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final height = (counts[i] / maxCount) * 60.0;
              final isToday = now.weekday == i + 1;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: height.clamp(4.0, 60.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isToday
                              ? colorScheme.primary
                              : colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        days[i],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isToday
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ── Locked Analytics (for free users) ─────────────────────────

class _LockedAnalytics extends StatelessWidget {
  final VoidCallback onTap;
  const _LockedAnalytics({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Premium Analytics',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.lock,
                        size: 16,
                        color: AppColors.premiumGold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Blurred placeholder bars
                  Row(
                    children: List.generate(
                      7,
                      (i) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Container(
                            height: 20.0 + (i * 6.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.diamond_rounded,
                        size: 16,
                        color: AppColors.premiumGold,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Upgrade to unlock analytics',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action Card ───────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
