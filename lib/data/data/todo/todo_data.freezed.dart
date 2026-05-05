// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ToDoData _$ToDoDataFromJson(Map<String, dynamic> json) {
  return _ToDoData.fromJson(json);
}

/// @nodoc
mixin _$ToDoData {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  /// If true, this todo uses a premium feature (e.g., priority label).
  bool get isPremiumFeature => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ToDoData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ToDoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToDoDataCopyWith<ToDoData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToDoDataCopyWith<$Res> {
  factory $ToDoDataCopyWith(ToDoData value, $Res Function(ToDoData) then) =
      _$ToDoDataCopyWithImpl<$Res, ToDoData>;
  @useResult
  $Res call({
    String id,
    String userId,
    String title,
    String description,
    bool isCompleted,
    bool isPremiumFeature,
    DateTime createdAt,
  });
}

/// @nodoc
class _$ToDoDataCopyWithImpl<$Res, $Val extends ToDoData>
    implements $ToDoDataCopyWith<$Res> {
  _$ToDoDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToDoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = null,
    Object? isCompleted = null,
    Object? isPremiumFeature = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPremiumFeature: null == isPremiumFeature
                ? _value.isPremiumFeature
                : isPremiumFeature // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ToDoDataImplCopyWith<$Res>
    implements $ToDoDataCopyWith<$Res> {
  factory _$$ToDoDataImplCopyWith(
    _$ToDoDataImpl value,
    $Res Function(_$ToDoDataImpl) then,
  ) = __$$ToDoDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String title,
    String description,
    bool isCompleted,
    bool isPremiumFeature,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$ToDoDataImplCopyWithImpl<$Res>
    extends _$ToDoDataCopyWithImpl<$Res, _$ToDoDataImpl>
    implements _$$ToDoDataImplCopyWith<$Res> {
  __$$ToDoDataImplCopyWithImpl(
    _$ToDoDataImpl _value,
    $Res Function(_$ToDoDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ToDoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = null,
    Object? isCompleted = null,
    Object? isPremiumFeature = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ToDoDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPremiumFeature: null == isPremiumFeature
            ? _value.isPremiumFeature
            : isPremiumFeature // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ToDoDataImpl extends _ToDoData {
  const _$ToDoDataImpl({
    required this.id,
    required this.userId,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.isPremiumFeature = false,
    required this.createdAt,
  }) : super._();

  factory _$ToDoDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToDoDataImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final bool isCompleted;

  /// If true, this todo uses a premium feature (e.g., priority label).
  @override
  @JsonKey()
  final bool isPremiumFeature;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ToDoData(id: $id, userId: $userId, title: $title, description: $description, isCompleted: $isCompleted, isPremiumFeature: $isPremiumFeature, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToDoDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.isPremiumFeature, isPremiumFeature) ||
                other.isPremiumFeature == isPremiumFeature) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    title,
    description,
    isCompleted,
    isPremiumFeature,
    createdAt,
  );

  /// Create a copy of ToDoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToDoDataImplCopyWith<_$ToDoDataImpl> get copyWith =>
      __$$ToDoDataImplCopyWithImpl<_$ToDoDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToDoDataImplToJson(this);
  }
}

abstract class _ToDoData extends ToDoData {
  const factory _ToDoData({
    required final String id,
    required final String userId,
    required final String title,
    final String description,
    final bool isCompleted,
    final bool isPremiumFeature,
    required final DateTime createdAt,
  }) = _$ToDoDataImpl;
  const _ToDoData._() : super._();

  factory _ToDoData.fromJson(Map<String, dynamic> json) =
      _$ToDoDataImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String get description;
  @override
  bool get isCompleted;

  /// If true, this todo uses a premium feature (e.g., priority label).
  @override
  bool get isPremiumFeature;
  @override
  DateTime get createdAt;

  /// Create a copy of ToDoData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToDoDataImplCopyWith<_$ToDoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
