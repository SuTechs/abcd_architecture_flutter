import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';

/// A glassmorphic consent dialog shown before rewarded ads.
///
/// Features:
///   - Animated circular countdown timer
///   - Blur backdrop with glassmorphism
///   - Auto-starts ad when timer completes
///   - "No Thanks" cancel option
class AdConsentDialog extends StatefulWidget {
  final String title;
  final String description;
  final String rewardText;
  final int countdownSeconds;
  final VoidCallback onWatchAd;
  final VoidCallback onCancel;

  const AdConsentDialog({
    super.key,
    required this.title,
    required this.description,
    required this.rewardText,
    required this.countdownSeconds,
    required this.onWatchAd,
    required this.onCancel,
  });

  @override
  State<AdConsentDialog> createState() => _AdConsentDialogState();
}

class _AdConsentDialogState extends State<AdConsentDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _countdownController;

  @override
  void initState() {
    super.initState();
    _countdownController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.countdownSeconds),
    );

    // Auto-start the countdown
    _countdownController.forward();
    _countdownController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onWatchAd();
      }
    });
  }

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface.withValues(alpha: 0.92),
                colorScheme.surfaceContainerLow.withValues(alpha: 0.95),
              ],
            ),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Icon ──
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradientStart.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_circle_outline_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Title ──
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // ── Description ──
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),

                // ── Reward Chip ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.card_giftcard,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.rewardText,
                        style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Watch Ad Auto-Button ──
                AnimatedBuilder(
                  animation: _countdownController,
                  builder: (context, child) {
                    final remaining =
                        (widget.countdownSeconds *
                                (1 - _countdownController.value))
                            .ceil();
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: widget.onWatchAd,
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: Text('Watch Ad ($remaining)'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        // Overlay progress at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(14),
                            ),
                            child: LinearProgressIndicator(
                              value: _countdownController.value,
                              minHeight: 3,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(
                                Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),

                // ── Cancel ──
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text(
                    'No Thanks',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
