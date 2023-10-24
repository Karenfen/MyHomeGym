import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../pages/exercise_info_page.dart';
import 'activities.dart';
import 'enums.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise extends Activities {
  Exercise(
      String name,
      ExerciseType exerciseType,
      WorkoutType workoutType,
      int repetitions,
      this.isTimePeriod,
      this.videoId,
      this.imageUrl,
      this.info)
      : super(name, exerciseType, workoutType, repetitions);
  bool isTimePeriod;
  String videoId;
  String imageUrl;
  String info;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);

  void showInfo(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ExerciseInfoPage(exercise: this),
    ));
  }

  factory Exercise.empty() {
    return Exercise(
        '', ExerciseType.none, WorkoutType.none, 0, false, '', '', '');
  }

  @override
  Future<void> run() async {}
}
