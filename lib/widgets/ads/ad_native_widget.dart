import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_service.dart';
import '../../app/theme/colors.dart';
import '../../data/api/services/app_logger.dart';
import '../../data/bloc/user_bloc.dart';

/// A self-contained adaptive native ad widget.
///
/// - Automatically adjusts height based on the loaded native ad.
/// - Shows a shimmer placeholder while loading.
/// - Fades in smoothly when ad is ready.
/// - Auto-hides for premium users and on web.
///
/// Usage:
/// ```dart
/// const AdNativeWidget()                           // default medium template
/// const AdNativeWidget(templateType: TemplateType.small)
/// ```
class AdNativeWidget extends ConsumerStatefulWidget {
  /// Template size: [TemplateType.medium] or [TemplateType.small].
  final TemplateType templateType;

  const AdNativeWidget({super.key, this.templateType = TemplateType.medium});

  @override
  ConsumerState<AdNativeWidget> createState() => _AdNativeWidgetState();
}

class _AdNativeWidgetState extends ConsumerState<AdNativeWidget>
    with SingleTickerProviderStateMixin {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  late AnimationController _fadeController;

  bool _isAdLoadStarted = false;

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
    if (!_isAdLoadStarted) {
      _isAdLoadStarted = true;
      _loadAd();
    }
  }

  void _loadAd() async {
    if (kIsWeb) return;

    await AdsService.ensureInitialized;
    if (!AdsService.isAvailable || !mounted || !context.mounted) return;

    final colorScheme = Theme.of(context).colorScheme;

    _nativeAd = NativeAd(
      adUnitId: AdsService.nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() => _isLoaded = true);
            _fadeController.forward();
          }
        },
        onAdFailedToLoad: (ad, error) {
          AppLogger.warning('Native ad failed: $error', tag: 'AdNative');
          ad.dispose();
          _nativeAd = null;
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.templateType,
        mainBackgroundColor: colorScheme.surfaceContainer,
        cornerRadius: 20.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onPrimary,
          backgroundColor: AppColors.gradientStart,
          style: NativeTemplateFontStyle.bold,
          size: 15.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurface,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurfaceVariant,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurfaceVariant,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  double get _estimatedHeight {
    return widget.templateType == TemplateType.small ? 100.0 : 380.0;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userBlocProvider);

    // Hide for premium users
    if (user.isPremium) return const SizedBox.shrink();

    if (!_isLoaded || _nativeAd == null) {
      // Shimmer placeholder while loading
      if (kIsWeb || !AdsService.isAvailable) return const SizedBox.shrink();
      return _ShimmerPlaceholder(height: _estimatedHeight);
    }

    return FadeTransition(
      opacity: CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 90, maxHeight: _estimatedHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AdWidget(ad: _nativeAd!),
        ),
      ),
    );
  }
}

/// A simple shimmer placeholder for ad loading state.
class _ShimmerPlaceholder extends StatefulWidget {
  final double height;
  const _ShimmerPlaceholder({required this.height});

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          height: widget.height,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2 * _shimmerController.value, 0),
              end: Alignment(1.0 + 2 * _shimmerController.value, 0),
              colors: [
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ],
            ),
          ),
        );
      },
    );
  }
}
