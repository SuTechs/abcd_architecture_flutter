import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserData with _$UserData {
  const UserData._();

  @HiveType(typeId: 0, adapterName: 'UserDataAdapter')
  const factory UserData({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String phone,
    @HiveField(3) String? email,
    @HiveField(4) String? imageUrl,

    //
    @HiveField(5) required int createdAt,
    @HiveField(6) required int updatedAt,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
