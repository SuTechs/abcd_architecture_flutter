// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseStateImpl _$$PurchaseStateImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseStateImpl(
      isPremium: json['isPremium'] as bool? ?? false,
      storeState:
          $enumDecodeNullable(_$StoreStateEnumMap, json['storeState']) ??
          StoreState.loading,
      plans:
          (json['plans'] as List<dynamic>?)
              ?.map((e) => PremiumPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedPlanId: json['selectedPlanId'] as String?,
    );

Map<String, dynamic> _$$PurchaseStateImplToJson(_$PurchaseStateImpl instance) =>
    <String, dynamic>{
      'isPremium': instance.isPremium,
      'storeState': _$StoreStateEnumMap[instance.storeState]!,
      'plans': instance.plans,
      'selectedPlanId': instance.selectedPlanId,
    };

const _$StoreStateEnumMap = {
  StoreState.available: 'available',
  StoreState.notAvailable: 'notAvailable',
  StoreState.loading: 'loading',
};

_$PremiumPlanImpl _$$PremiumPlanImplFromJson(Map<String, dynamic> json) =>
    _$PremiumPlanImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      price: json['price'] as String,
      period: json['period'] as String,
      description: json['description'] as String? ?? '',
      isBestValue: json['isBestValue'] as bool? ?? false,
      savings: json['savings'] as String?,
    );

Map<String, dynamic> _$$PremiumPlanImplToJson(_$PremiumPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'period': instance.period,
      'description': instance.description,
      'isBestValue': instance.isBestValue,
      'savings': instance.savings,
    };
