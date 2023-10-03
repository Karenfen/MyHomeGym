// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
      json['name'] as String,
      json['repetitions'] as int,
      json['videoUrl'] as String,
      json['imageUrl'] as String,
    );

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'name': instance.name,
      'repetitions': instance.repetitions,
      'videoUrl': instance.videoUrl,
      'imageUrl': instance.imageUrl,
    };
