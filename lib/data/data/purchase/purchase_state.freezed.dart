// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PurchaseState _$PurchaseStateFromJson(Map<String, dynamic> json) {
  return _PurchaseState.fromJson(json);
}

/// @nodoc
mixin _$PurchaseState {
  bool get isPremium => throw _privateConstructorUsedError;
  StoreState get storeState => throw _privateConstructorUsedError;
  List<PremiumPlan> get plans => throw _privateConstructorUsedError;
  String? get selectedPlanId => throw _privateConstructorUsedError;

  /// Serializes this PurchaseState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseStateCopyWith<PurchaseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseStateCopyWith<$Res> {
  factory $PurchaseStateCopyWith(
    PurchaseState value,
    $Res Function(PurchaseState) then,
  ) = _$PurchaseStateCopyWithImpl<$Res, PurchaseState>;
  @useResult
  $Res call({
    bool isPremium,
    StoreState storeState,
    List<PremiumPlan> plans,
    String? selectedPlanId,
  });
}

/// @nodoc
class _$PurchaseStateCopyWithImpl<$Res, $Val extends PurchaseState>
    implements $PurchaseStateCopyWith<$Res> {
  _$PurchaseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPremium = null,
    Object? storeState = null,
    Object? plans = null,
    Object? selectedPlanId = freezed,
  }) {
    return _then(
      _value.copyWith(
            isPremium: null == isPremium
                ? _value.isPremium
                : isPremium // ignore: cast_nullable_to_non_nullable
                      as bool,
            storeState: null == storeState
                ? _value.storeState
                : storeState // ignore: cast_nullable_to_non_nullable
                      as StoreState,
            plans: null == plans
                ? _value.plans
                : plans // ignore: cast_nullable_to_non_nullable
                      as List<PremiumPlan>,
            selectedPlanId: freezed == selectedPlanId
                ? _value.selectedPlanId
                : selectedPlanId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PurchaseStateImplCopyWith<$Res>
    implements $PurchaseStateCopyWith<$Res> {
  factory _$$PurchaseStateImplCopyWith(
    _$PurchaseStateImpl value,
    $Res Function(_$PurchaseStateImpl) then,
  ) = __$$PurchaseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isPremium,
    StoreState storeState,
    List<PremiumPlan> plans,
    String? selectedPlanId,
  });
}

/// @nodoc
class __$$PurchaseStateImplCopyWithImpl<$Res>
    extends _$PurchaseStateCopyWithImpl<$Res, _$PurchaseStateImpl>
    implements _$$PurchaseStateImplCopyWith<$Res> {
  __$$PurchaseStateImplCopyWithImpl(
    _$PurchaseStateImpl _value,
    $Res Function(_$PurchaseStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPremium = null,
    Object? storeState = null,
    Object? plans = null,
    Object? selectedPlanId = freezed,
  }) {
    return _then(
      _$PurchaseStateImpl(
        isPremium: null == isPremium
            ? _value.isPremium
            : isPremium // ignore: cast_nullable_to_non_nullable
                  as bool,
        storeState: null == storeState
            ? _value.storeState
            : storeState // ignore: cast_nullable_to_non_nullable
                  as StoreState,
        plans: null == plans
            ? _value._plans
            : plans // ignore: cast_nullable_to_non_nullable
                  as List<PremiumPlan>,
        selectedPlanId: freezed == selectedPlanId
            ? _value.selectedPlanId
            : selectedPlanId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseStateImpl implements _PurchaseState {
  const _$PurchaseStateImpl({
    this.isPremium = false,
    this.storeState = StoreState.loading,
    final List<PremiumPlan> plans = const [],
    this.selectedPlanId,
  }) : _plans = plans;

  factory _$PurchaseStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseStateImplFromJson(json);

  @override
  @JsonKey()
  final bool isPremium;
  @override
  @JsonKey()
  final StoreState storeState;
  final List<PremiumPlan> _plans;
  @override
  @JsonKey()
  List<PremiumPlan> get plans {
    if (_plans is EqualUnmodifiableListView) return _plans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plans);
  }

  @override
  final String? selectedPlanId;

  @override
  String toString() {
    return 'PurchaseState(isPremium: $isPremium, storeState: $storeState, plans: $plans, selectedPlanId: $selectedPlanId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseStateImpl &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.storeState, storeState) ||
                other.storeState == storeState) &&
            const DeepCollectionEquality().equals(other._plans, _plans) &&
            (identical(other.selectedPlanId, selectedPlanId) ||
                other.selectedPlanId == selectedPlanId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isPremium,
    storeState,
    const DeepCollectionEquality().hash(_plans),
    selectedPlanId,
  );

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseStateImplCopyWith<_$PurchaseStateImpl> get copyWith =>
      __$$PurchaseStateImplCopyWithImpl<_$PurchaseStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseStateImplToJson(this);
  }
}

abstract class _PurchaseState implements PurchaseState {
  const factory _PurchaseState({
    final bool isPremium,
    final StoreState storeState,
    final List<PremiumPlan> plans,
    final String? selectedPlanId,
  }) = _$PurchaseStateImpl;

  factory _PurchaseState.fromJson(Map<String, dynamic> json) =
      _$PurchaseStateImpl.fromJson;

  @override
  bool get isPremium;
  @override
  StoreState get storeState;
  @override
  List<PremiumPlan> get plans;
  @override
  String? get selectedPlanId;

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseStateImplCopyWith<_$PurchaseStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PremiumPlan _$PremiumPlanFromJson(Map<String, dynamic> json) {
  return _PremiumPlan.fromJson(json);
}

/// @nodoc
mixin _$PremiumPlan {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get price => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isBestValue => throw _privateConstructorUsedError;
  String? get savings => throw _privateConstructorUsedError;

  /// Serializes this PremiumPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PremiumPlanCopyWith<PremiumPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumPlanCopyWith<$Res> {
  factory $PremiumPlanCopyWith(
    PremiumPlan value,
    $Res Function(PremiumPlan) then,
  ) = _$PremiumPlanCopyWithImpl<$Res, PremiumPlan>;
  @useResult
  $Res call({
    String id,
    String title,
    String price,
    String period,
    String description,
    bool isBestValue,
    String? savings,
  });
}

/// @nodoc
class _$PremiumPlanCopyWithImpl<$Res, $Val extends PremiumPlan>
    implements $PremiumPlanCopyWith<$Res> {
  _$PremiumPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? period = null,
    Object? description = null,
    Object? isBestValue = null,
    Object? savings = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as String,
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            isBestValue: null == isBestValue
                ? _value.isBestValue
                : isBestValue // ignore: cast_nullable_to_non_nullable
                      as bool,
            savings: freezed == savings
                ? _value.savings
                : savings // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PremiumPlanImplCopyWith<$Res>
    implements $PremiumPlanCopyWith<$Res> {
  factory _$$PremiumPlanImplCopyWith(
    _$PremiumPlanImpl value,
    $Res Function(_$PremiumPlanImpl) then,
  ) = __$$PremiumPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String price,
    String period,
    String description,
    bool isBestValue,
    String? savings,
  });
}

/// @nodoc
class __$$PremiumPlanImplCopyWithImpl<$Res>
    extends _$PremiumPlanCopyWithImpl<$Res, _$PremiumPlanImpl>
    implements _$$PremiumPlanImplCopyWith<$Res> {
  __$$PremiumPlanImplCopyWithImpl(
    _$PremiumPlanImpl _value,
    $Res Function(_$PremiumPlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? period = null,
    Object? description = null,
    Object? isBestValue = null,
    Object? savings = freezed,
  }) {
    return _then(
      _$PremiumPlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as String,
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        isBestValue: null == isBestValue
            ? _value.isBestValue
            : isBestValue // ignore: cast_nullable_to_non_nullable
                  as bool,
        savings: freezed == savings
            ? _value.savings
            : savings // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PremiumPlanImpl extends _PremiumPlan {
  const _$PremiumPlanImpl({
    required this.id,
    required this.title,
    required this.price,
    required this.period,
    this.description = '',
    this.isBestValue = false,
    this.savings,
  }) : super._();

  factory _$PremiumPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$PremiumPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String price;
  @override
  final String period;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final bool isBestValue;
  @override
  final String? savings;

  @override
  String toString() {
    return 'PremiumPlan(id: $id, title: $title, price: $price, period: $period, description: $description, isBestValue: $isBestValue, savings: $savings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PremiumPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isBestValue, isBestValue) ||
                other.isBestValue == isBestValue) &&
            (identical(other.savings, savings) || other.savings == savings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    price,
    period,
    description,
    isBestValue,
    savings,
  );

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PremiumPlanImplCopyWith<_$PremiumPlanImpl> get copyWith =>
      __$$PremiumPlanImplCopyWithImpl<_$PremiumPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PremiumPlanImplToJson(this);
  }
}

abstract class _PremiumPlan extends PremiumPlan {
  const factory _PremiumPlan({
    required final String id,
    required final String title,
    required final String price,
    required final String period,
    final String description,
    final bool isBestValue,
    final String? savings,
  }) = _$PremiumPlanImpl;
  const _PremiumPlan._() : super._();

  factory _PremiumPlan.fromJson(Map<String, dynamic> json) =
      _$PremiumPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get price;
  @override
  String get period;
  @override
  String get description;
  @override
  bool get isBestValue;
  @override
  String? get savings;

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PremiumPlanImplCopyWith<_$PremiumPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
