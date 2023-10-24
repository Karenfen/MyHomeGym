import 'enums.dart';

abstract class Activities {
  Activities(this.name, this.exerciseType, this.workoutType, this.repetitions);
  String name;
  ExerciseType exerciseType;
  WorkoutType workoutType;
  int repetitions;

  Future<void> run();

  bool isEmpty() {
    return name.isEmpty;
  }

  bool isNotEmpty() {
    return name.isNotEmpty;
  }

  String getExerciseTypeAsString() {
    switch (exerciseType) {
      case ExerciseType.all:
        return 'На всё тело';
      case ExerciseType.lower:
        return 'На низ тела';
      case ExerciseType.top:
        return 'На верх тела';
      case ExerciseType.none:
        return '';
    }
  }

  String getWorkoutTypeAsString() {
    switch (workoutType) {
      case WorkoutType.strength:
        return 'Силовая тренировка';
      case WorkoutType.stretching:
        return 'Разтяжка';
      case WorkoutType.warmUp:
        return 'Разминка';
      case WorkoutType.none:
        return '';
    }
  }
}
