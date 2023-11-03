// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout(
      name: json['name'] as String,
      exerciseType: $enumDecode(_$ExerciseTypeEnumMap, json['exerciseType']),
      workoutType: $enumDecode(_$WorkoutTypeEnumMap, json['workoutType']),
      exerciseList: (json['exerciseList'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      repetitions: json['repetitions'] as int? ?? 0,
      warmUpBefore: json['warmUpBefore'] == null
          ? null
          : Workout.fromJson(json['warmUpBefore'] as Map<String, dynamic>),
      warmUpAfter: json['warmUpAfter'] == null
          ? null
          : Workout.fromJson(json['warmUpAfter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      'name': instance.name,
      'exerciseType': _$ExerciseTypeEnumMap[instance.exerciseType]!,
      'workoutType': _$WorkoutTypeEnumMap[instance.workoutType]!,
      'repetitions': instance.repetitions,
      'exerciseList': instance.exerciseList,
      'warmUpBefore': instance.warmUpBefore,
      'warmUpAfter': instance.warmUpAfter,
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
