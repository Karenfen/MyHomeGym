import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/enums.dart';
import 'package:flutter_application_1/widjets/exercise_card.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../classes/exercise.dart';
import '../classes/workout.dart';
import '../my_app.dart';
import '../widjets/workout_card.dart';

class WorkoutStartPage extends StatefulWidget {
  const WorkoutStartPage({super.key, required this.workout});

  final Workout workout;

  @override
  State<WorkoutStartPage> createState() => _WorkoutStartPageState();
}

class _WorkoutStartPageState extends State<WorkoutStartPage> {
  Timer? timer;
  int secondsPassed = 0;
  late Exercise currentExercise;
  AudioPlayer startNotificationPlayer = AudioPlayer();
  AudioPlayer endNotificationPlayer = AudioPlayer();
  AudioPlayer finishNotificationPlayer = AudioPlayer();
  late MyAppState appState;
  bool isPause = false;
  bool isRun = false;
  bool isCompleted = false;
  bool isCurrentExerciseCompleted = true;
  List<Exercise> exerciseList = [];
  int currentExerciseIndex = 0;
  Icon iconButtonStart = Icon(Icons.play_arrow_rounded);
  Text labelButtonStart = Text('Начать');
  late String audioName;

  Future<void> timerStart() async {
    print('timer start');
    timer?.cancel();
    Completer<void> timerCompleter = Completer<void>();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isPause) {
        setState(() {
          if (secondsPassed > 0) secondsPassed--;
        });
        if (secondsPassed <= 0) {
          timer.cancel();
          if (!timerCompleter.isCompleted) timerCompleter.complete();
        }
      }
    });

    await timerCompleter.future;

    return Future<void>.value();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appState = context.watch<MyAppState>();

    startNotificationPlayer.setSourceAsset('sounds/start.wav');
    startNotificationPlayer.setReleaseMode(ReleaseMode.stop);
    endNotificationPlayer.setSourceAsset('sounds/end.wav');
    endNotificationPlayer.setReleaseMode(ReleaseMode.stop);
    finishNotificationPlayer.setSourceAsset('sounds/finish.wav');
    finishNotificationPlayer.setReleaseMode(ReleaseMode.stop);

    if (exerciseList.isEmpty) {
      Workout warmUpBefore = appState.data.workoutList.firstWhere(
          (element) => (element.exerciseType == widget.workout.exerciseType &&
              element.workoutType == WorkoutType.warmUp),
          orElse: () => Workout.empty());
      Workout warmUpAfter = appState.data.workoutList.firstWhere(
          (element) => (element.exerciseType == widget.workout.exerciseType &&
              element.workoutType == WorkoutType.stretching),
          orElse: () => Workout.empty());

      exerciseList = List.from(warmUpBefore.exerciseList);

      for (var i = 0; i < widget.workout.repetitions; i++) {
        exerciseList.addAll(widget.workout.exerciseList);
      }

      exerciseList.addAll(warmUpAfter.exerciseList);

      currentExercise = exerciseList.first;
    }
  }

  @override
  void dispose() {
    startNotificationPlayer.dispose();
    endNotificationPlayer.dispose();
    finishNotificationPlayer.dispose();
    timer?.cancel();

    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> completedExercise() async {
    while (!isCompleted) {
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Future<void> runExercise(Exercise exercise) async {
    //playSound('file_name.wav');  // Звуковое уведомление и одновременно обратный отсчет до начала упражнения

    setState(() {
      secondsPassed = 5;
    });

    await timerStart();

    await Future.delayed(Duration(seconds: 1));

    startNotificationPlayer.resume();

    setState(() {
      secondsPassed = exercise.repetitions;
    });

    if (exercise.isTimePeriod) {
      await timerStart();
    } else {
      setState(() {
        isCurrentExerciseCompleted = false;
        iconButtonStart = Icon(Icons.done_rounded);
        labelButtonStart = Text('Готово');
      });

      await completedExercise();

      setState(() {
        isCurrentExerciseCompleted = true;
        iconButtonStart = Icon(Icons.pause_rounded);
        labelButtonStart = Text('Пауза');
      });
    }

    endNotificationPlayer.resume();

    await Future.delayed(Duration(seconds: 1));

    return Future<void>.value();
  }

  Future<void> run() async {
    setState(() {
      isRun = true;
      iconButtonStart = Icon(Icons.pause_rounded);
      labelButtonStart = Text('Пауза');
    });

    if (exerciseList.isNotEmpty) {
      for (var exercise in exerciseList) {
        if (!mounted) return;
        setState(() {
          currentExercise = exercise;
        });

        await runExercise(exercise);
      }
    }

    setState(() {
      isRun = false;
      isCompleted = true;
      iconButtonStart = Icon(Icons.exit_to_app_rounded);
      labelButtonStart = Text('Выйти');
    });

    finishNotificationPlayer.resume();

    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.workout.name),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Center(child: WorkoutCard(workout: widget.workout)),
              Text('Следующее упражнение:'),
              ExerciseCard(exercise: currentExercise),
              Expanded(
                child: SizedBox(),
              ),
              Text('Оставшееся время:'),
              Card(
                color: theme.colorScheme.primary,
                shadowColor: theme.shadowColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('$secondsPassed', style: textStyle),
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  if (!mounted) return;

                  if (isCompleted) Navigator.pop(context);

                  if (isRun) {
                    if (!isCurrentExerciseCompleted) {
                      setState(() {
                        isCurrentExerciseCompleted = true;
                      });
                      return;
                    }
                    setState(() {
                      isPause = !isPause;
                      iconButtonStart =
                          isPause ? Icon(Icons.play_arrow) : Icon(Icons.pause);
                      labelButtonStart =
                          isPause ? Text('Продолжить') : Text('Пауза');
                    });
                  } else {
                    run();
                  }
                },
                icon: iconButtonStart,
                label: labelButtonStart,
              ),
            ],
          ),
        ));
  }
}
