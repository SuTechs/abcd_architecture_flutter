import 'package:flutter/material.dart';

import 'mobile_ads_mixin.dart';

/// native ad example
class NativeAdBanner extends StatefulWidget {
  const NativeAdBanner({super.key});

  @override
  State<NativeAdBanner> createState() => _NativeAdBannerState();
}

class _NativeAdBannerState extends State<NativeAdBanner> with NativeAdMixin {
  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: nativeAdWidget,
    );
  }
}

/// Bottom Banner Ad Example

class BottomBannerAd extends StatefulWidget {
  final bool isListAd;

  const BottomBannerAd({super.key, this.isListAd = false});

  @override
  State<BottomBannerAd> createState() => _BottomBannerAdState();
}

class _BottomBannerAdState extends State<BottomBannerAd> with BannerAdMixin {
  @override
  bool get isAnchoredAdaptive => widget.isListAd == false;

  @override
  Widget build(BuildContext context) {
    return bannerAdWidget;
  }
}
