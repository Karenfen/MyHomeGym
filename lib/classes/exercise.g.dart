// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
      name: json['name'] as String,
      exerciseType: $enumDecode(_$ExerciseTypeEnumMap, json['exerciseType']),
      workoutType: $enumDecode(_$WorkoutTypeEnumMap, json['workoutType']),
      repetitions: json['repetitions'] as int,
      isTimePeriod: json['isTimePeriod'] as bool? ?? false,
      preparationSeconds: json['preparationSeconds'] as int? ?? 5,
      relaxSeconds: json['relaxSeconds'] as int? ?? 0,
      videoId: json['videoId'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      info: json['info'] as String? ?? '',
    );

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'name': instance.name,
      'exerciseType': _$ExerciseTypeEnumMap[instance.exerciseType]!,
      'workoutType': _$WorkoutTypeEnumMap[instance.workoutType]!,
      'repetitions': instance.repetitions,
      'isTimePeriod': instance.isTimePeriod,
      'preparationSeconds': instance.preparationSeconds,
      'relaxSeconds': instance.relaxSeconds,
      'videoId': instance.videoId,
      'imageUrl': instance.imageUrl,
      'info': instance.info,
    };

const _$ExerciseTypeEnumMap = {
  ExerciseType.all: 'all',
  ExerciseType.top: 'top',
  ExerciseType.lower: 'lower',
  ExerciseType.none: 'none',
};

const _$WorkoutTypeEnumMap = {
  WorkoutType.warmUp: 'warmUp',
  WorkoutType.strength: 'strength',
  WorkoutType.stretching: 'stretching',
  WorkoutType.none: 'none',
};
