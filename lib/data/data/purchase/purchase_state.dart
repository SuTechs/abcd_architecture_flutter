import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_state.freezed.dart';
part 'purchase_state.g.dart';

enum StoreState { available, notAvailable, loading }

@freezed
class PurchaseState with _$PurchaseState {
  const factory PurchaseState({
    @Default(false) bool isPremium,
    @Default(StoreState.loading) StoreState storeState,
    @Default([]) List<PremiumPlan> plans,
    String? selectedPlanId,
  }) = _PurchaseState;

  factory PurchaseState.fromJson(Map<String, dynamic> json) =>
      _$PurchaseStateFromJson(json);
}

/// Represents a subscription plan (real or mock).
@freezed
class PremiumPlan with _$PremiumPlan {
  const PremiumPlan._();

  const factory PremiumPlan({
    required String id,
    required String title,
    required String price,
    required String period,
    @Default('') String description,
    @Default(false) bool isBestValue,
    String? savings,
  }) = _PremiumPlan;

  factory PremiumPlan.fromJson(Map<String, dynamic> json) =>
      _$PremiumPlanFromJson(json);

  /// Default mock plans for when IAP is not configured.
  static List<PremiumPlan> get mockPlans => const [
    PremiumPlan(
      id: 'premium_monthly',
      title: 'Monthly',
      price: '\$4.99',
      period: '/month',
      description: 'Billed monthly, cancel anytime',
    ),
    PremiumPlan(
      id: 'premium_yearly',
      title: 'Yearly',
      price: '\$39.99',
      period: '/year',
      description: 'Billed annually',
      isBestValue: true,
      savings: 'Save 33%',
    ),
  ];
}
