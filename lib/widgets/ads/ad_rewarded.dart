import 'dart:async';

import 'package:flutter/material.dart';

import 'ads_service.dart';
import '../../data/api/services/app_logger.dart';
import 'ad_consent_dialog.dart';

/// Static helper for rewarded ad lifecycle management with user consent.
///
/// Shows a consent dialog before the ad, with a countdown timer.
///
/// Usage:
/// ```dart
/// final rewarded = await AdRewarded.showWithConsent(
///   context,
///   title: 'Unlock Extra Task',
///   description: 'Watch a short ad to add more tasks',
///   rewardText: 'Task slot unlocked!',
///   onRewarded: () => addTodo(),
///   onCancelled: () => showUpgradePrompt(),
/// );
/// ```
class AdRewarded {
  AdRewarded._();

  /// Preload a rewarded ad in the background.
  static Future<void> preload() => AdsService.loadRewarded();

  /// Whether a rewarded ad is ready to be shown.
  static bool get isReady => AdsService.isRewardedReady;

  /// Show a consent dialog, then play the rewarded ad.
  ///
  /// Returns `true` if the user watched the ad and earned the reward.
  /// Returns `false` if the user cancelled or the ad failed.
  static Future<bool> showWithConsent(
    BuildContext context, {
    String title = 'Watch an Ad',
    String description = 'Watch a short ad to unlock this feature',
    String rewardText = 'Reward will be granted after the ad',
    int countdownSeconds = 5,
    VoidCallback? onRewarded,
    VoidCallback? onCancelled,
  }) async {
    final completer = Completer<bool>();

    if (!context.mounted) {
      return false;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (dialogContext) => AdConsentDialog(
        title: title,
        description: description,
        rewardText: rewardText,
        countdownSeconds: countdownSeconds,
        onWatchAd: () async {
          Navigator.of(dialogContext).pop();

          final shown = await AdsService.showRewarded(
            onRewarded: (ad, reward) {
              AppLogger.info(
                'User earned reward: ${reward.amount} ${reward.type}',
                tag: 'AdRewarded',
              );
              onRewarded?.call();
              if (!completer.isCompleted) completer.complete(true);
            },
          );

          if (!shown) {
            AppLogger.warning('No rewarded ad available', tag: 'AdRewarded');
            onCancelled?.call();
            if (!completer.isCompleted) completer.complete(false);
          }
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
          onCancelled?.call();
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    return completer.future;
  }
}
