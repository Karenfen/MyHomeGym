import 'package:json_annotation/json_annotation.dart';

import 'info.dart';
import 'workout.dart';
import 'exercise.dart';

part 'app_data.g.dart';

@JsonSerializable()
class AppData {
  AppData(
      this.info, this.workoutList, this.activeWorkoutList, this.exerciseList);

  MyInfo info;
  List<Workout> workoutList;
  List<Workout> activeWorkoutList;
  List<Exercise> exerciseList;

  factory AppData.fromJson(Map<String, dynamic> json) =>
      _$AppDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppDataToJson(this);

  bool isEmpty() {
    return (workoutList.isEmpty || exerciseList.isEmpty);
  }

  factory AppData.empty() {
    return AppData(MyInfo.empty(), [], [], []);
  }
}
