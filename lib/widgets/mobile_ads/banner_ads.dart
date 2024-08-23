import 'package:flutter/material.dart';

import 'mobile_ads_mixin.dart';

/// native ad for favorite screen
class _NativeAdBanner extends StatefulWidget {
  const _NativeAdBanner();

  @override
  State<_NativeAdBanner> createState() => _NativeAdBannerState();
}

class _NativeAdBannerState extends State<_NativeAdBanner> with NativeAdMixin {
  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: nativeAdWidget,
    );
  }
}

/// Bottom Banner Ad

class _BottomBannerAd extends StatefulWidget {
  final bool isListAd;

  const _BottomBannerAd({this.isListAd = false});

  @override
  State<_BottomBannerAd> createState() => _BottomBannerAdState();
}

class _BottomBannerAdState extends State<_BottomBannerAd> with BannerAdMixin {
  @override
  bool get isAnchoredAdaptive => widget.isListAd == false;

  @override
  Widget build(BuildContext context) {
    return bannerAdWidget;
  }
}
