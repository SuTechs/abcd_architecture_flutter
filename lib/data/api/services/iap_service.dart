import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart';

import 'app_logger.dart';

class IapService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static bool _isAvailable = false;

  static bool get isAvailable => _isAvailable;

  static Future<void> initialize(
    Function(List<PurchaseDetails>) onPurchaseUpdate,
  ) async {
    if (kIsWeb) return;
    try {
      _isAvailable = await _iap.isAvailable();
      if (!_isAvailable) {
        AppLogger.warning(
          'IAP not available on this device',
          tag: 'IapService',
        );
        return;
      }

      _subscription = _iap.purchaseStream.listen(
        onPurchaseUpdate,
        onDone: () => _subscription?.cancel(),
        onError: (error) {
          AppLogger.error('IAP Stream Error', tag: 'IapService', error: error);
        },
      );
    } catch (e) {
      AppLogger.error('IAP Initialization Error', tag: 'IapService', error: e);
    }
  }

  static Future<List<ProductDetails>> fetchProducts(
    Set<String> productIds,
  ) async {
    if (!_isAvailable || kIsWeb) return [];
    try {
      final response = await _iap.queryProductDetails(productIds);
      if (response.error != null) {
        AppLogger.error(
          'Error fetching products',
          tag: 'IapService',
          error: response.error,
        );
        return [];
      }
      return response.productDetails;
    } catch (e) {
      AppLogger.error('IAP Fetch Error', tag: 'IapService', error: e);
      return [];
    }
  }

  static Future<bool> buyProduct(ProductDetails product) async {
    if (!_isAvailable || kIsWeb) return false;
    try {
      final purchaseParam = PurchaseParam(productDetails: product);
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      AppLogger.error('IAP Buy Error', tag: 'IapService', error: e);
      return false;
    }
  }

  static Future<void> restorePurchases() async {
    if (!_isAvailable || kIsWeb) return;
    try {
      await _iap.restorePurchases();
    } catch (e) {
      AppLogger.error('IAP Restore Error', tag: 'IapService', error: e);
    }
  }
}
