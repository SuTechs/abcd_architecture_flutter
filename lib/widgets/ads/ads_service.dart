import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../app/config.dart';
import '../../data/api/services/app_logger.dart';

/// Full-featured ad service supporting banner, interstitial, rewarded, and native ads.
///
/// All methods are guarded with `kIsWeb` and availability checks.
/// Uses Google test ad unit IDs in debug mode.
class AdsService {
  static bool _isAvailable = false;

  static Future<void>? _initFuture;

  static Future<void> initialize() {
    if (kIsWeb) return Future.value();
    _initFuture ??= _doInitialize();
    return _initFuture!;
  }

  static Future<void> _doInitialize() async {
    try {
      await MobileAds.instance.initialize();
      _isAvailable = true;
    } catch (e) {
      AppLogger.error('Init Error', tag: 'AdsService', error: e);
    }
  }

  /// Wait until initialization is complete
  static Future<void> get ensureInitialized async {
    if (_initFuture != null) {
      await _initFuture;
    }
  }

  static bool get isAvailable => _isAvailable && !kIsWeb;

  // ── Ad Unit IDs ────────────────────────────────────────────

  static String get bannerAdUnitId {
    if (kIsWeb) return '';
    if (kDebugMode) {
      return _debugBannerAdUnitId;
    }
    final configured = defaultTargetPlatform == TargetPlatform.android
        ? AppConfig.instance.admobAndroidBannerAdUnitId
        : AppConfig.instance.admobIosBannerAdUnitId;
    return configured;
  }

  static String get interstitialAdUnitId {
    if (kIsWeb) return '';
    if (kDebugMode) return _debugInterstitialAdUnitId;
    final configured = defaultTargetPlatform == TargetPlatform.android
        ? AppConfig.instance.admobAndroidInterstitialAdUnitId
        : AppConfig.instance.admobIosInterstitialAdUnitId;
    return configured;
  }

  static String get rewardedAdUnitId {
    if (kIsWeb) return '';
    if (kDebugMode) return _debugRewardedAdUnitId;
    final configured = defaultTargetPlatform == TargetPlatform.android
        ? AppConfig.instance.admobAndroidRewardedAdUnitId
        : AppConfig.instance.admobIosRewardedAdUnitId;
    return configured;
  }

  static String get nativeAdUnitId {
    if (kIsWeb) return '';
    if (kDebugMode) return _debugNativeAdUnitId;
    final configured = defaultTargetPlatform == TargetPlatform.android
        ? AppConfig.instance.admobAndroidNativeAdUnitId
        : AppConfig.instance.admobIosNativeAdUnitId;
    return configured;
  }

  static String get _debugBannerAdUnitId =>
      defaultTargetPlatform == TargetPlatform.android
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static String get _debugInterstitialAdUnitId =>
      defaultTargetPlatform == TargetPlatform.android
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static String get _debugRewardedAdUnitId =>
      defaultTargetPlatform == TargetPlatform.android
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  static String get _debugNativeAdUnitId =>
      defaultTargetPlatform == TargetPlatform.android
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  // ── Interstitial Ads ───────────────────────────────────────

  static InterstitialAd? _interstitialAd;

  /// Preload an interstitial ad. Call early so it's ready when needed.
  static Future<void> loadInterstitial() async {
    if (!isAvailable) return;
    final adUnitId = interstitialAdUnitId;
    if (adUnitId.isEmpty) return;
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          AppLogger.info('Interstitial loaded', tag: 'AdsService');
        },
        onAdFailedToLoad: (err) {
          AppLogger.error(
            'Interstitial failed to load',
            tag: 'AdsService',
            error: err,
          );
        },
      ),
    );
  }

  /// Show the preloaded interstitial. Returns true if shown successfully.
  static Future<bool> showInterstitial() async {
    if (_interstitialAd == null) return false;
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial(); // Preload next one
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _interstitialAd = null;
      },
    );
    await _interstitialAd!.show();
    return true;
  }

  // ── Rewarded Ads ───────────────────────────────────────────

  static RewardedAd? _rewardedAd;

  /// Whether a rewarded ad is preloaded and ready to show.
  static bool get isRewardedReady => _rewardedAd != null;

  /// Preload a rewarded ad.
  static Future<void> loadRewarded() async {
    if (!isAvailable) return;
    final adUnitId = rewardedAdUnitId;
    if (adUnitId.isEmpty) return;
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          AppLogger.info('Rewarded ad loaded', tag: 'AdsService');
        },
        onAdFailedToLoad: (err) {
          AppLogger.error(
            'Rewarded ad failed to load',
            tag: 'AdsService',
            error: err,
          );
        },
      ),
    );
  }

  /// Show the rewarded ad. Calls [onRewarded] when user earns the reward.
  static Future<bool> showRewarded({
    required void Function(AdWithoutView ad, RewardItem reward) onRewarded,
  }) async {
    final ad = _rewardedAd;
    if (ad == null) return false;

    final completer = Completer<bool>();
    var didEarnReward = false;

    void complete(bool value) {
      if (!completer.isCompleted) completer.complete(value);
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewarded(); // Preload next one
        complete(didEarnReward);
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _rewardedAd = null;
        complete(false);
      },
    );

    try {
      await ad.show(
        onUserEarnedReward: (ad, reward) {
          didEarnReward = true;
          onRewarded(ad, reward);
          complete(true);
        },
      );
    } catch (e) {
      ad.dispose();
      _rewardedAd = null;
      complete(false);
    }

    return completer.future;
  }

  // ── Adaptive Banner ────────────────────────────────────────

  /// Creates an adaptive banner ad sized for the current screen width.
  static Future<BannerAd?> createAdaptiveBanner({
    required double width,
    BannerAdListener? listener,
  }) async {
    if (!isAvailable) return null;
    final adUnitId = bannerAdUnitId;
    if (adUnitId.isEmpty) return null;
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width.truncate(),
    );
    if (size == null) return null;

    return BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: listener ?? const BannerAdListener(),
    )..load();
  }

  // ── Native Ads ─────────────────────────────────────────────

  /// Creates a native ad with the specified factory ID.
  static NativeAd? createNativeAd({
    required NativeAdListener listener,
    String factoryId = 'listTile',
  }) {
    if (!isAvailable) return null;
    final adUnitId = nativeAdUnitId;
    if (adUnitId.isEmpty) return null;

    return NativeAd(
      adUnitId: adUnitId,
      factoryId: factoryId,
      request: const AdRequest(),
      listener: listener,
    )..load();
  }
}
