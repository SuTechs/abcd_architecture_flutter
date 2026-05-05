/// App configuration loaded from environment variables using `--dart-define-from-file`.
///
/// Usage:
/// ```dart
/// final url = AppConfig.instance.supabaseUrl;
/// ```
class AppConfig {
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String supabaseGoogleWebClientId;
  final String apiBaseUrl;
  final String admobAndroidAppId;
  final String admobIosAppId;
  final String admobAndroidBannerAdUnitId;
  final String admobIosBannerAdUnitId;
  final String admobAndroidInterstitialAdUnitId;
  final String admobIosInterstitialAdUnitId;
  final String admobAndroidRewardedAdUnitId;
  final String admobIosRewardedAdUnitId;
  final String admobAndroidNativeAdUnitId;
  final String admobIosNativeAdUnitId;

  const AppConfig({
    this.supabaseUrl = '',
    this.supabaseAnonKey = '',
    this.supabaseGoogleWebClientId = '',
    this.apiBaseUrl = '',
    this.admobAndroidAppId = '',
    this.admobIosAppId = '',
    this.admobAndroidBannerAdUnitId = '',
    this.admobIosBannerAdUnitId = '',
    this.admobAndroidInterstitialAdUnitId = '',
    this.admobIosInterstitialAdUnitId = '',
    this.admobAndroidRewardedAdUnitId = '',
    this.admobIosRewardedAdUnitId = '',
    this.admobAndroidNativeAdUnitId = '',
    this.admobIosNativeAdUnitId = '',
  });

  static const AppConfig _instance = AppConfig(
    supabaseUrl: String.fromEnvironment('supabase_url'),
    supabaseAnonKey: String.fromEnvironment('supabase_anon_key'),
    supabaseGoogleWebClientId: String.fromEnvironment(
      'supabase_google_web_client_id',
    ),
    apiBaseUrl: String.fromEnvironment('api_base_url'),
    admobAndroidAppId: String.fromEnvironment('admob_android_app_id'),
    admobIosAppId: String.fromEnvironment('admob_ios_app_id'),
    admobAndroidBannerAdUnitId: String.fromEnvironment(
      'admob_android_banner_ad_unit_id',
    ),
    admobIosBannerAdUnitId: String.fromEnvironment(
      'admob_ios_banner_ad_unit_id',
    ),
    admobAndroidInterstitialAdUnitId: String.fromEnvironment(
      'admob_android_interstitial_ad_unit_id',
    ),
    admobIosInterstitialAdUnitId: String.fromEnvironment(
      'admob_ios_interstitial_ad_unit_id',
    ),
    admobAndroidRewardedAdUnitId: String.fromEnvironment(
      'admob_android_rewarded_ad_unit_id',
    ),
    admobIosRewardedAdUnitId: String.fromEnvironment(
      'admob_ios_rewarded_ad_unit_id',
    ),
    admobAndroidNativeAdUnitId: String.fromEnvironment(
      'admob_android_native_ad_unit_id',
    ),
    admobIosNativeAdUnitId: String.fromEnvironment(
      'admob_ios_native_ad_unit_id',
    ),
  );

  static AppConfig get instance => _instance;
}
