import 'ads_service.dart';

/// Static helper for interstitial ad lifecycle management.
///
/// Usage:
/// ```dart
/// // Preload early (e.g. in bootstrap)
/// await AdInterstitial.preload();
///
/// // Show when needed
/// final shown = await AdInterstitial.show();
/// ```
class AdInterstitial {
  AdInterstitial._();

  /// Preload an interstitial ad in the background.
  static Future<void> preload() => AdsService.loadInterstitial();

  /// Show the preloaded interstitial. Returns `true` if shown.
  ///
  /// Automatically preloads the next ad after dismissal.
  static Future<bool> show() => AdsService.showInterstitial();
}
