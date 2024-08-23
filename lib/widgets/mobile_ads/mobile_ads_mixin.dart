import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Banner ad mixin
mixin BannerAdMixin<T extends StatefulWidget> on State<T> {
  final bool isAnchoredAdaptive = true;

  bool _isAdLoaded = false;

  BannerAd? _bannerAd;
  AdSize? _adSize;

  Future<void> _loadAd() async {
    final width = MediaQuery.sizeOf(context).width.truncate() - 16;

    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AdSize size = isAnchoredAdaptive
        ? (await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
                width)) ??
            AdSize.banner
        : AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(width);

    // Create a BannerAd instance
    _bannerAd = BannerAd(
      adUnitId: AdUnitId.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) async {
          debugPrint(
              '${isAnchoredAdaptive ? 'Anchored' : 'Inline'} adaptive banner loaded: ${ad.responseInfo}');

          // After the ad is loaded, get the platform ad size and use it to
          // update the height of the container. This is necessary because the
          // height can change after the ad is loaded.
          BannerAd bannerAd = (ad as BannerAd);
          final AdSize? newSize = await bannerAd.getPlatformAdSize();
          if (newSize == null) {
            debugPrint(
                'Error: getPlatformAdSize() returned null for $bannerAd');
            return;
          }

          setState(() {
            _isAdLoaded = true;
            _adSize = newSize;
          });

          // AnalyticsRepository.logBannerAdLoaded();
        },
        onAdFailedToLoad: (_, error) {
          debugPrint('Banner Ad failed to load: $error');
          _bannerAd?.dispose();

          // AnalyticsRepository.logBannerAdFailedToLoad();
        },
      ),
    );

    // Load the ad
    return _bannerAd?.load();
  }

  late Orientation _currentOrientation;

  /// Banner Ad Widget
  Widget get bannerAdWidget {
    final orientation = MediaQuery.of(context).orientation;

    if (orientation != _currentOrientation) {
      _currentOrientation = orientation;
      _isAdLoaded = false;
      _loadAd();

      return const SizedBox();
    }

    return AnimatedOpacity(
      opacity: _isAdLoaded ? 1.0 : 0.0,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 1000),
      child: AnimatedContainer(
        margin: const EdgeInsets.all(8.0),
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 1000),
        width: _isAdLoaded ? _adSize?.width.toDouble() : 0.0,
        height: _isAdLoaded ? _adSize?.height.toDouble() : 0.0,
        child: _isAdLoaded && _bannerAd != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AdWidget(ad: _bannerAd!),
              )
            : const SizedBox(),
      ),
    );
  }

  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
    _init = true;
  }

  @override
  void dispose() {
    super.dispose();

    // dispose ad
    _bannerAd?.dispose();
  }
}

/// Native ad mixin
mixin NativeAdMixin<T extends StatefulWidget> on State<T> {
  bool _nativeAdIsLoaded = false;

  bool isMediumSize = true;

  late final colorScheme = Theme.of(context).colorScheme;
  late final textTheme = Theme.of(context).textTheme;

  late final NativeAd _nativeAd = NativeAd(
    adUnitId: AdUnitId.native,
    request: const AdRequest(),
    listener: NativeAdListener(
      onAdLoaded: (_) {
        setState(() {
          _nativeAdIsLoaded = true;
        });

        // AnalyticsRepository.logNativeAdLoaded();
      },
      onAdFailedToLoad: (_, error) {
        debugPrint('Native Ad failed to load: $error');
        _nativeAd.dispose();

        // AnalyticsRepository.logNativeAdFailedToLoad();
      },
    ),
    nativeTemplateStyle: NativeTemplateStyle(
      cornerRadius: 10,
      templateType: isMediumSize ? TemplateType.medium : TemplateType.small,
      callToActionTextStyle: NativeTemplateTextStyle(
        backgroundColor: colorScheme.secondaryContainer,
        textColor: colorScheme.primary,
      ),
    ),
  );

  Widget get nativeAdWidget {
    return AnimatedOpacity(
      opacity: _nativeAdIsLoaded ? 1.0 : 0.0,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 1000),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 320, // minimum recommended width
          minHeight: isMediumSize ? 320 : 90, // minimum recommended height
          maxWidth: 400,
          maxHeight: isMediumSize ? 400 : 200,
        ),
        child: _nativeAdIsLoaded ? AdWidget(ad: _nativeAd) : const SizedBox(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // load ad
    _nativeAd.load();
  }

  @override
  void dispose() {
    super.dispose();

    // dispose ad
    _nativeAd.dispose();
  }
}

/// Interstitial Ad Loader
class InterstitialAdLoader {
  /// Interstitial Ad
  InterstitialAd? _interstitialAd;

  Future<void> load() {
    return InterstitialAd.load(
      adUnitId: AdUnitId.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
            },

            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
          );

          ///
          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;

          _show();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');

          // AnalyticsRepository.logInterstitialAdFailedToShow();
        },
      ),
    );
  }

  void _show() {
    try {
      _interstitialAd?.show();
      // AnalyticsRepository.logShowInterstitialAd();
    } catch (e, s) {
      debugPrint('InterstitialAd failed to show: $e and stack = $s');
    }
  }
}

/// Rewarded Ad Loader
class RewardedAdLoader {
  /// Rewarded Ad
  RewardedAd? _rewardedAd;

  int _failedLoadCount = 0;

  Future<void> load() {
    return RewardedAd.load(
      adUnitId: AdUnitId.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // // Called when the ad showed the full screen content.
            // onAdShowedFullScreenContent: (ad) {},
            // // Called when an impression occurs on the ad.
            // onAdImpression: (ad) {},

            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },

            // // Called when a click is recorded for an ad.
            // onAdClicked: (ad) {},
          );

          ///
          debugPrint('$ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          _failedLoadCount++;

          if (_failedLoadCount < 3) load();
        },
      ),
    );
  }

  void show({
    required void Function()? onUserEarnedReward,
    void Function()? onAdFailedToShow,
  }) async {
    debugPrint(
        "Showing ad and rewarded: $_rewardedAd and failed count: $_failedLoadCount");

    if (_rewardedAd == null && _failedLoadCount >= 3) {
      onAdFailedToShow?.call();
      return;
    }

    // add a fail safe if the ad is still loading
    if (_rewardedAd == null) {
      debugPrint(
          'RewardFailCheckTrigger: Ad is still loading, waiting for 3 seconds');
      // AnalyticsRepository.logRewardAdFailCheckTrigger();

      await Future.delayed(const Duration(seconds: 3));

      // check if the ad is still null
      if (_rewardedAd == null) {
        onAdFailedToShow?.call();
        return;
      }
    }

    _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('User rewarded: ${reward.amount} ${reward.type}');
        onUserEarnedReward?.call();
      },
    );
  }
}

/// Rewarded Interstitial Ad Loader
class RewardedInterstitialAdLoader {
  /// Rewarded Ad
  RewardedInterstitialAd? _rewardedInterstitialAd;

  int _failedLoadCount = 0;

  Future<void> load() {
    return RewardedInterstitialAd.load(
      adUnitId: AdUnitId.rewardedInterstitial,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // // Called when the ad showed the full screen content.
            // onAdShowedFullScreenContent: (ad) {},
            // // Called when an impression occurs on the ad.
            // onAdImpression: (ad) {},

            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },

            // // Called when a click is recorded for an ad.
            // onAdClicked: (ad) {},
          );

          ///
          debugPrint('$ad loaded.');
          _rewardedInterstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          _failedLoadCount++;

          if (_failedLoadCount < 3) load();
        },
      ),
    );
  }

  void show({
    required void Function()? onUserEarnedReward,
    void Function()? onAdFailedToShow,
  }) async {
    debugPrint(
        "Showing ad and rewarded: $_rewardedInterstitialAd and failed count: $_failedLoadCount");

    if (_rewardedInterstitialAd == null && _failedLoadCount >= 3) {
      onAdFailedToShow?.call();
      return;
    }

    // add a fail safe if the ad is still loading
    if (_rewardedInterstitialAd == null) {
      debugPrint(
          'RewardFailCheckTrigger: Ad is still loading, waiting for 3 seconds');
      // AnalyticsRepository.logRewardAdFailCheckTrigger();

      await Future.delayed(const Duration(seconds: 3));

      // check if the ad is still null
      if (_rewardedInterstitialAd == null) {
        onAdFailedToShow?.call();
        return;
      }
    }

    _rewardedInterstitialAd?.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('User rewarded: ${reward.amount} ${reward.type}');
        onUserEarnedReward?.call();
      },
    );
  }
}

/// Ad unit Id Constants
class AdUnitId {
  ///
  /// Android Rewarded Ad Unit Id
  static const _testAndroidRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const _liveAndroidRewarded = 'ca-app-pub-3940256099942544/5224354917';

  static String get rewarded =>
      kReleaseMode ? _liveAndroidRewarded : _testAndroidRewarded;

  ///
  /// Android Interstitial Ad Unit Id
  static const _testAndroidInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const _liveAndroidInterstitial =
      'ca-app-pub-3940256099942544/1033173712';

  static String get interstitial =>
      kReleaseMode ? _liveAndroidInterstitial : _testAndroidInterstitial;

  ///
  /// Android Rewarded Interstitial Ad Unit Id
  static const _testAndroidRewardedInterstitial =
      'ca-app-pub-3940256099942544/5354046379';

  static const _liveAndroidRewardedInterstitial =
      'ca-app-pub-3940256099942544/5354046379';

  static String get rewardedInterstitial => kReleaseMode
      ? _liveAndroidRewardedInterstitial
      : _testAndroidRewardedInterstitial;

  ///
  /// Android Native Ad Unit Id
  static const _testAndroidNative = 'ca-app-pub-3940256099942544/2247696110';
  static const _liveAndroidNative = 'ca-app-pub-3940256099942544/2247696110';

  static String get native =>
      kReleaseMode ? _liveAndroidNative : _testAndroidNative;

  ///
  /// Banner Ad Unit Id
  static const _testAndroidBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const _liveAndroidBanner = 'ca-app-pub-3940256099942544/6300978111';

  static String get banner =>
      kReleaseMode ? _liveAndroidBanner : _testAndroidBanner;
}
