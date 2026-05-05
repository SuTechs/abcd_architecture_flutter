// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ToDoDataImpl _$$ToDoDataImplFromJson(Map<String, dynamic> json) =>
    _$ToDoDataImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      isPremiumFeature: json['isPremiumFeature'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ToDoDataImplToJson(_$ToDoDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'isPremiumFeature': instance.isPremiumFeature,
      'createdAt': instance.createdAt.toIso8601String(),
    };
