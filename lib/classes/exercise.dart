import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../pages/exercise_info_page.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise {
  Exercise(this.name, this.repetitions, this.videoId, this.imageUrl, this.info);

  String name;
  int repetitions;
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
}
