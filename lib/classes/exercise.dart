import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../pages/exercise_info_page.dart';
import 'activities.dart';
import 'enums.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise extends Activities {
  Exercise(
      {required String name,
      required ExerciseType exerciseType,
      required WorkoutType workoutType,
      required int repetitions,
      this.isTimePeriod = false,
      this.preparationSeconds = 5,
      this.relaxSeconds = 0,
      this.videoId = '',
      this.imageUrl = '',
      this.info = ''})
      : super(name, exerciseType, workoutType, repetitions);

  bool isTimePeriod;
  int preparationSeconds;
  int relaxSeconds;
  String videoId;
  String imageUrl;
  String info;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Timer? timer;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isPause = false;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int secondsLeft = 0;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isNotCompleted = false;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isCanceled = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Function? onTick;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Function? onBegine;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Function? onDone;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Function? onGetReady;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Function? onWaitingForComplete;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Function? onRelax;

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
        name: '',
        exerciseType: ExerciseType.none,
        workoutType: WorkoutType.none,
        repetitions: 0);
  }

  Future<void> waitingForExecution() async {
    while (isNotCompleted) {
      if (isCanceled) return;

      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Future<void> timerStart() async {
    timer?.cancel();
    Completer<void> timerCompleter = Completer<void>();

    if (isCanceled) return;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isCanceled) {
        timer.cancel();
        if (!timerCompleter.isCompleted) timerCompleter.complete();
      }

      if (!isPause) {
        if (secondsLeft > 0) {
          secondsLeft--;
          onTick?.call(secondsLeft);
        }
        if (secondsLeft <= 0) {
          timer.cancel();
          if (!timerCompleter.isCompleted) timerCompleter.complete();
        }
      }
    });

    if (isCanceled) return;

    await timerCompleter.future;
  }

  @override
  Future<void> run() async {
    secondsLeft = 5;
    onGetReady?.call(secondsLeft);

    await timerStart();
    await Future.delayed(Duration(seconds: 1));

    if (isCanceled) return;

    secondsLeft = repetitions;
    onBegine?.call(secondsLeft);

    if (isTimePeriod) {
      await timerStart();
    } else {
      isNotCompleted = true;
      onWaitingForComplete?.call();
      await waitingForExecution();
    }

    onDone?.call();

    if (isCanceled) return;

    if (workoutType == WorkoutType.strength) {
      secondsLeft = relaxSeconds;
      onRelax?.call(secondsLeft);
      await timerStart();
    }

    if (isCanceled) return;

    await Future.delayed(Duration(seconds: 1));
  }

  void pause() {
    isPause = true;
  }

  void resume() {
    isPause = false;
  }

  void exerciseCompleted() {
    isNotCompleted = false;
  }

  void cancel() {
    isCanceled = true;
    isPause = false;
    isNotCompleted = false;
  }

  void reset() {
    isCanceled = false;
    isPause = false;
    isNotCompleted = false;
  }
}
