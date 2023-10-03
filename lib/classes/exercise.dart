import 'package:json_annotation/json_annotation.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise {
  Exercise(this.name, this.repetitions, this.videoId, this.imageUrl);

  String name;
  int repetitions;
  String videoId;
  String imageUrl;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}
