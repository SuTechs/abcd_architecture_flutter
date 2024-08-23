import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:abcd_architecture_flutter/widgets/context_extension.dart';
import 'package:flutter/material.dart';

import 'mobile_ads_mixin.dart';

/// View Ad Dialog
class ViewAdDialog extends StatefulWidget {
  const ViewAdDialog({super.key});

  @override
  State<ViewAdDialog> createState() => _ViewAdDialogState();

  static Future<bool?> show(BuildContext context) async {
    // Disable ads for some conditions if needed
    // // show ads only if user has downloaded atleast 5 sounds
    // // 5 svg path and 5 sound path in stringBox
    // if (Data.stringBox.length < 10) return true;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      // barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: ViewAdDialog(),
        );
      },
    );
  }
}

class _ViewAdDialogState extends State<ViewAdDialog> {
  final _rewardedAd = RewardedAdLoader();

  @override
  void initState() {
    super.initState();
    _rewardedAd.load();
  }

  void _showAd() {
    _rewardedAd.show(
      onUserEarnedReward: () {
        if (mounted) Navigator.of(context).maybePop(true);
        // AnalyticsRepository.logOnUserEarnedRewardAd();
      },
      onAdFailedToShow: () {
        final isOffline = context.readIsOffline;

        if (isOffline) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please check your internet connection'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ad failed to show! #2313'),
            ),
          );
        }

        if (mounted) Navigator.of(context).maybePop(isOffline == false);

        // AnalyticsRepository.logRewardAdFailedToShow();
      },
    );
  }

  ///

  // final _lottie = getRandomText(['donate', 'bird']);

  final _title = getRandomText(
    [
      "Keep The App Free",
      "Support Free Music",
      "Help Keep the Music Playing",
      "Enjoy More Free Music",
      "Your Support Matters",
      "Keep The Tunes Alive"
    ],
  );

  final _subtitle = getRandomText(
    [
      "Watch a quick ad to support free music",
      "Watch a quick ad to keep the tunes coming",
      "Watch a quick ad",
      "Your support keeps the music free",
      "Help us stay free with a quick ad",
      "Support us by watching a quick ad"
    ],
  );

  final _removeAdsText = getRandomText(
    [
      "Remove Ads",
      "Get Premium",
      "Unlock Premium",
      "Go Premium",
      "Upgrade to Premium",
      "Remove Ads",
      "Remove Ads",
    ],
  );

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.4,
            color: Colors.white.withOpacity(0.8),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // /// close button
            // Align(
            //   alignment: Alignment.topRight,
            //   child: IconButton(
            //     padding: EdgeInsets.zero,
            //     visualDensity: VisualDensity.compact,
            //     icon: const Icon(Icons.close),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   ),
            // ),

            /// lottie animation
            // Lottie.asset(
            //   'assets/icons/${_lottie}_lottie.json',
            //   height: MediaQuery.of(context).size.height * 0.2,
            //   width: MediaQuery.of(context).size.height * 0.2,
            // ),

            const SizedBox(height: 16),

            /// title
            Text(
              _title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            /// subtitle
            Text(
              _subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 24),

            /// watch ad button
            TimerWatchAdButton(
              onTap: _showAd,
            ),
            const SizedBox(height: 8),

            /// Remove Ad Button
            TextButton(
              onPressed: () {
                // AnalyticsRepository.logRemoveAdButton();

                // ToDO: Implement Premium Page
                // got to premium page
                Navigator.pushNamedAndRemoveUntil(
                    context, '/premium', (route) => route.isFirst);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: Text(
                _removeAdsText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationThickness: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String getRandomText(List<String> texts, [int? indexToTest]) {
    if (indexToTest != null) {
      return texts[indexToTest];
    }

    return texts[Random().nextInt(texts.length)];
  }
}

/// Timer Watch Ad Button
class TimerWatchAdButton extends StatefulWidget {
  final VoidCallback onTap;

  const TimerWatchAdButton({super.key, required this.onTap});

  @override
  State<TimerWatchAdButton> createState() => _TimerWatchAdButtonState();
}

class _TimerWatchAdButtonState extends State<TimerWatchAdButton> {
  int _countdown = 5;
  late Timer _timer;

  bool _isButtonAlreadyPressed = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer.cancel();
          widget.onTap();
          // AnalyticsRepository.logAutoViewAdButtonClick();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.play_arrow_rounded),
      label: Text(
        _isButtonAlreadyPressed || _countdown <= 0
            ? "Loading Ad..."
            : "Watch Ad (${_countdown}s)",
      ),
      onPressed: () {
        if (_isButtonAlreadyPressed) {
          return;
        }

        setState(() {
          _isButtonAlreadyPressed = true;
        });

        _timer.cancel();

        widget.onTap();
        // AnalyticsRepository.logViewAdButtonClick();
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
