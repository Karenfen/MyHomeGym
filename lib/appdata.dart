import 'package:json_annotation/json_annotation.dart';

import 'workout.dart';
import 'exercise.dart';

part 'appdata.g.dart';

@JsonSerializable()
class AppData {
  AppData(this.warmUpBeforeList, this.warmUpAfterList, this.workoutList,
      this.exerciseList);

  List<Workout> warmUpBeforeList;
  List<Workout> warmUpAfterList;
  List<Workout> workoutList;
  List<Exercise> exerciseList;

  factory AppData.fromJson(Map<String, dynamic> json) =>
      _$AppDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppDataToJson(this);

  bool isEmpty() {
    return (workoutList.isEmpty ||
        exerciseList.isEmpty ||
        warmUpAfterList.isEmpty ||
        warmUpBeforeList.isEmpty);
  }
}
