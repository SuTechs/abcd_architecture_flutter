import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/purchase/purchase_state.dart';

final purchaseBlocProvider = NotifierProvider<PurchaseBloc, PurchaseState>(
  PurchaseBloc.new,
);

class PurchaseBloc extends Notifier<PurchaseState> {
  @override
  PurchaseState build() {
    return const PurchaseState();
  }

  void setPremium(bool isPremium) {
    state = state.copyWith(isPremium: isPremium);
  }

  void setStoreState(StoreState storeState) {
    state = state.copyWith(storeState: storeState);
  }

  void setPlans(List<PremiumPlan> plans) {
    state = state.copyWith(plans: plans);
  }

  void selectPlan(String planId) {
    state = state.copyWith(selectedPlanId: planId);
  }
}
