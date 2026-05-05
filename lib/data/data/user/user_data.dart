import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';

part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  const UserData._();

  const factory UserData({
    required String id,
    required String name,
    @Default('') String email,
    @Default('') String phone,
    String? imageUrl,
    @Default(false) bool isPremium,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  /// Default guest user — not authenticated
  factory UserData.guest() => UserData(
    id: 'guest',
    name: 'Guest',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  bool get isGuest => id == 'guest';
}
