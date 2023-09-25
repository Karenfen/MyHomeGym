// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout(
      json['workoutName'] as String,
      json['workoutType'] as String,
      (json['exerciseList'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      'workoutName': instance.workoutName,
      'workoutType': instance.workoutType,
      'exerciseList': instance.exerciseList,
    };
