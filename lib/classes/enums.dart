import 'package:json_annotation/json_annotation.dart';

enum ExerciseType {
  @JsonValue('all')
  all,
  @JsonValue('top')
  top,
  @JsonValue('lower')
  lower,
  @JsonValue('none')
  none
}

enum WorkoutType {
  @JsonValue('warmUp')
  warmUp,
  @JsonValue('strength')
  strength,
  @JsonValue('stretching')
  stretching,
  @JsonValue('none')
  none
}

enum Level {
  @JsonValue('easy')
  easy,
  @JsonValue('normal')
  normal,
  @JsonValue('hard')
  hard,
  @JsonValue('none')
  none
}
