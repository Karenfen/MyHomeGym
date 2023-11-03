import 'package:json_annotation/json_annotation.dart';

import 'activities.dart';
import 'exercise.dart';
import 'enums.dart';

part 'workout.g.dart';

@JsonSerializable()
class Workout extends Activities {
  Workout(
      {required String name,
      required ExerciseType exerciseType,
      required WorkoutType workoutType,
      required this.exerciseList,
      int repetitions = 0,
      this.warmUpBefore,
      this.warmUpAfter})
      : super(name, exerciseType, workoutType, repetitions);

  List<Exercise> exerciseList;
  Workout? warmUpBefore;
  Workout? warmUpAfter;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late Exercise currentExercise;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int currentIndex = 0;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isActive = true;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool toPrevious = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Function? onExerciseBegin;

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutToJson(this);

  Workout copy() {
    return Workout(
        name: name,
        exerciseType: exerciseType,
        workoutType: workoutType,
        exerciseList: exerciseList,
        repetitions: repetitions,
        warmUpBefore: warmUpBefore,
        warmUpAfter: warmUpAfter);
  }

  factory Workout.empty() {
    return Workout(
        name: '',
        exerciseType: ExerciseType.none,
        workoutType: WorkoutType.none,
        exerciseList: []);
  }

  void initExerciseList() {
    if (workoutType == WorkoutType.strength) {
      List<Exercise> fullExerciseList = [];

      if (warmUpBefore != null) {
        fullExerciseList.addAll(warmUpBefore!.exerciseList);
      }

      for (var i = 0; i < repetitions; i++) {
        fullExerciseList.addAll(exerciseList);
      }

      if (warmUpAfter != null) {
        fullExerciseList.addAll(warmUpAfter!.exerciseList);
      }

      exerciseList = fullExerciseList;
    }

    currentExercise = exerciseList.first;
  }

  @override
  Future<void> run() async {
    while (currentIndex < exerciseList.length) {
      if (!isActive) return;

      try {
        currentExercise = exerciseList[currentIndex];
        onExerciseBegin?.call(currentExercise);

        await currentExercise.run();
        currentExercise.reset();
      } on Exception catch (e) {
        break;
      }

      if (toPrevious) {
        toPrevious = false;

        if (currentIndex > 0) {
          currentIndex--;
        }
      } else {
        currentIndex++;
      }
    }
  }

  void skip() {
    try {
      currentExercise.cancel();
    } on Exception catch (e) {
      // TODO
    }
  }

  void previous() {
    toPrevious = true;
    skip();
  }

  void pause() {
    try {
      currentExercise.pause();
    } on Exception catch (e) {
      // TODO
    }
  }

  void resume() {
    try {
      currentExercise.resume();
    } on Exception catch (e) {
      // TODO
    }
  }
}
