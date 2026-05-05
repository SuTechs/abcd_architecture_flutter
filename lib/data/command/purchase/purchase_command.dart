import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../api/services/app_logger.dart';
import '../../api/services/iap_service.dart';
import '../../bloc/user_bloc.dart';
import '../../data/purchase/purchase_state.dart';
import '../base_command.dart';

class PurchaseCommand extends BaseCommand {
  Future<void> init() async {
    await IapService.initialize(_onPurchaseUpdate);

    // If IAP is not available (no store configured), load mock plans
    if (!IapService.isAvailable) {
      AppLogger.info(
        'IAP not available — loading mock plans',
        tag: 'PurchaseCommand',
      );
      purchaseBloc.setPlans(PremiumPlan.mockPlans);
      purchaseBloc.setStoreState(StoreState.available);
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        purchaseBloc.setStoreState(StoreState.loading);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          purchaseBloc.setStoreState(StoreState.available);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _grantPremium();
        }
        if (purchaseDetails.pendingCompletePurchase) {
          InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void _grantPremium() {
    purchaseBloc.setPremium(true);
    final user = ref.read(userBlocProvider);
    if (!user.isGuest) {
      final updated = user.copyWith(isPremium: true);
      userBloc.updateProfileLocally(updated);
      api.upsertUser(updated);
    }
    purchaseBloc.setStoreState(StoreState.available);
  }

  Future<void> loadProducts() async {
    purchaseBloc.setStoreState(StoreState.loading);

    if (!IapService.isAvailable) {
      // Use mock plans when store isn't configured
      purchaseBloc.setPlans(PremiumPlan.mockPlans);
      purchaseBloc.setStoreState(StoreState.available);
      return;
    }

    final products = await IapService.fetchProducts({
      'premium_monthly',
      'premium_yearly',
    });

    final plans = products
        .map(
          (p) => PremiumPlan(
            id: p.id,
            title: p.title,
            price: p.price,
            period: p.id.contains('yearly') ? '/year' : '/month',
            description: p.description,
            isBestValue: p.id.contains('yearly'),
            savings: p.id.contains('yearly') ? 'Save 33%' : null,
          ),
        )
        .toList();

    purchaseBloc.setPlans(plans.isEmpty ? PremiumPlan.mockPlans : plans);
    purchaseBloc.setStoreState(StoreState.available);
  }

  /// Buy a premium plan. Falls back to mock purchase if IAP isn't available.
  Future<void> buyPremium(String planId) async {
    if (!IapService.isAvailable) {
      // Mock purchase — grant premium immediately
      AppLogger.info('Mock purchase: $planId', tag: 'PurchaseCommand');
      await Future.delayed(const Duration(seconds: 1)); // Simulate delay
      _grantPremium();
      return;
    }

    final products = await IapService.fetchProducts({planId});
    if (products.isNotEmpty) {
      await IapService.buyProduct(products.first);
    } else if (kDebugMode) {
      // Fallback (DEBUG ONLY): If products are empty, store isn't fully configured.
      // We process it as a mock purchase so developers can test the premium flow.
      AppLogger.info(
        'Store not configured for $planId. Mocking purchase...',
        tag: 'PurchaseCommand',
      );
      await Future.delayed(const Duration(seconds: 1)); // Simulate store delay
      _grantPremium();
    } else {
      AppLogger.warning(
        'Failed to fetch product $planId from store.',
        tag: 'PurchaseCommand',
      );
      purchaseBloc.setStoreState(StoreState.available);
    }
  }

  Future<void> restorePurchases() async {
    await IapService.restorePurchases();
  }
}
