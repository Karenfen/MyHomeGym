// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
      json['name'] as String,
      $enumDecode(_$ExerciseTypeEnumMap, json['exerciseType']),
      $enumDecode(_$WorkoutTypeEnumMap, json['workoutType']),
      json['repetitions'] as int,
      json['isTimePeriod'] as bool,
      json['videoId'] as String,
      json['imageUrl'] as String,
      json['info'] as String,
    );

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'name': instance.name,
      'exerciseType': _$ExerciseTypeEnumMap[instance.exerciseType]!,
      'workoutType': _$WorkoutTypeEnumMap[instance.workoutType]!,
      'repetitions': instance.repetitions,
      'isTimePeriod': instance.isTimePeriod,
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
