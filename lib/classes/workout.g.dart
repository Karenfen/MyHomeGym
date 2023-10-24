// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout(
      json['name'] as String,
      $enumDecode(_$ExerciseTypeEnumMap, json['exerciseType']),
      $enumDecode(_$WorkoutTypeEnumMap, json['workoutType']),
      json['repetitions'] as int,
      (json['exerciseList'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      'name': instance.name,
      'exerciseType': _$ExerciseTypeEnumMap[instance.exerciseType]!,
      'workoutType': _$WorkoutTypeEnumMap[instance.workoutType]!,
      'repetitions': instance.repetitions,
      'exerciseList': instance.exerciseList,
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
