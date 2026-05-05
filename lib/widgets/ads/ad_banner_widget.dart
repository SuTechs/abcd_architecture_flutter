import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_service.dart';
import '../../data/api/services/app_logger.dart';
import '../../data/bloc/user_bloc.dart';

/// A self-contained adaptive banner ad widget.
///
/// - Auto-sizes to screen width using adaptive banners.
/// - Fades in smoothly when the ad loads.
/// - Auto-hides for premium users and on web.
/// - Shows nothing when ads are unavailable or fail to load.
///
/// Usage:
/// ```dart
/// const AdBannerWidget()            // adaptive width
/// const AdBannerWidget(maxWidth: 400) // constrained width
/// ```
class AdBannerWidget extends ConsumerStatefulWidget {
  /// Optional maximum width constraint for the banner.
  final double? maxWidth;

  const AdBannerWidget({super.key, this.maxWidth});

  @override
  ConsumerState<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends ConsumerState<AdBannerWidget>
    with SingleTickerProviderStateMixin {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerAd == null) _loadAd();
  }

  void _loadAd() async {
    if (kIsWeb) return;

    await AdsService.ensureInitialized;
    if (!AdsService.isAvailable || !mounted) return;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final width = widget.maxWidth != null
        ? screenWidth.clamp(0, widget.maxWidth!).toDouble()
        : screenWidth;

    AdsService.createAdaptiveBanner(
      width: width,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _bannerAd = ad as BannerAd;
            });
            _fadeController.forward();
          }
        },
        onAdFailedToLoad: (ad, err) {
          AppLogger.warning('Banner ad failed: $err', tag: 'AdBanner');
          ad.dispose();
        },
      ),
    ).then((ad) {
      if (ad == null && mounted) return;
      _bannerAd = ad;
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userBlocProvider);

    // Hide for premium users
    if (user.isPremium) return const SizedBox.shrink();

    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
      child: Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
