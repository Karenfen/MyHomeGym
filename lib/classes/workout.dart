import 'package:json_annotation/json_annotation.dart';

import 'activities.dart';
import 'exercise.dart';
import 'enums.dart';

part 'workout.g.dart';

@JsonSerializable()
class Workout extends Activities {
  Workout(String name, ExerciseType exerciseType, WorkoutType workoutType,
      int repetitions, this.exerciseList)
      : super(name, exerciseType, workoutType, repetitions);

  List<Exercise> exerciseList;

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutToJson(this);

  factory Workout.empty() {
    return Workout('', ExerciseType.none, WorkoutType.none, 0, []);
  }

  @override
  Future<void> run() async {}
}
