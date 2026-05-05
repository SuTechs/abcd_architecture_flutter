import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_data.freezed.dart';
part 'todo_data.g.dart';

@freezed
class ToDoData with _$ToDoData {
  const ToDoData._();

  const factory ToDoData({
    required String id,
    required String userId,
    required String title,
    @Default('') String description,
    @Default(false) bool isCompleted,

    /// If true, this todo uses a premium feature (e.g., priority label).
    @Default(false) bool isPremiumFeature,
    required DateTime createdAt,
  }) = _ToDoData;

  factory ToDoData.fromJson(Map<String, dynamic> json) =>
      _$ToDoDataFromJson(json);
}
