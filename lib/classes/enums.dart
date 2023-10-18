import 'package:json_annotation/json_annotation.dart';

enum ExerciseType {
  @JsonValue('time')
  time,
  @JsonValue('replays')
  replays
}

enum WorkoutType {
  @JsonValue('all')
  all,
  @JsonValue('top')
  top,
  @JsonValue('lower')
  lower,
  @JsonValue('none')
  none
}

enum Level {
  @JsonValue('easy')
  easy,
  @JsonValue('normal')
  normal,
  @JsonValue('hard')
  hard
}
