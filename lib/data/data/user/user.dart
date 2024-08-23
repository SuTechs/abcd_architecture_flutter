import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Data class representing user information.
@freezed
class UserData with _$UserData {
  const UserData._();

  @HiveType(typeId: 0, adapterName: 'UserDataAdapter')
  const factory UserData({
    /// Unique user ID
    @HiveField(0) required String id,

    /// User's name
    @HiveField(1) required String name,

    /// User's phone number
    @HiveField(2) String? phone,

    /// User's email
    @HiveField(3) String? email,

    /// URL to user's profile image (optional)
    @HiveField(4) String? imageUrl,

    // Timestamps
    /// User's account creation timestamp
    @HiveField(5) required int createdAt,

    /// Timestamp for user profile updates
    @HiveField(6) required int updatedAt,

    // ------ User statistics & score ------

    // /// Timestamp of the last quiz taken
    // @HiveField(7) @Default(0) int lastQuizDate,
    //
    // /// Current daily streak
    // @HiveField(8) @Default(0) int dayStreak,
    //
    // /// Total gems collected
    // @HiveField(9) @Default(0) int totalGems,
    //
    // /// Total experience points
    // @HiveField(10) @Default(0) int totalXp,
    //
    // /// Last selected book
    // @HiveField(11) String? lastBookId,
    //
    // /// show ads or not
    // @HiveField(12, defaultValue: true) @Default(true) bool showAds,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
