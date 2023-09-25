import 'package:json_annotation/json_annotation.dart';

import 'exercise.dart';

part 'workout.g.dart';

@JsonSerializable()
class Workout {
  Workout(this.workoutName, this.workoutType, this.exerciseList);

  String workoutName;
  String workoutType;
  List<Exercise> exerciseList;

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutToJson(this);
}
