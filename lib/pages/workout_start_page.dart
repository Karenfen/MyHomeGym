import 'dart:async';

import 'package:flutter/material.dart';
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
  Exercise currentExercise = Exercise('Приготовьтесь!', 0, '', '');
  AudioPlayer notificationPlayer = AudioPlayer();
  late MyAppState appState;
  bool isInProcess = false;

  @override
  void dispose() {
    notificationPlayer.stop();
    notificationPlayer.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> runExerciseFromTime(Exercise exercise) async {
    // Звуковое уведомление и одновременно обратный отсчет до начала упражнения
    //notificationPlayer.play('${appState.tempDirPath}/timer_start.mp3');
    setState(() {
      secondsPassed = 5;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsPassed > 0) secondsPassed--;
      });
    });
    await Future.delayed(Duration(
        seconds:
            secondsPassed)); // Пример задержки в 5 секунд для обратного отсчета
    timer?.cancel();
    setState(() {
      secondsPassed = 0;
    });
    await Future.delayed(Duration(seconds: 1));
// звук начала упражнения
    setState(() {
      secondsPassed = 5;
      notificationPlayer
          .play(UrlSource('${appState.tempDirPath}/timer_start.mp3'));
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsPassed > 0) secondsPassed--;
      });
    });
    await Future.delayed(Duration(
        seconds:
            secondsPassed)); // Пример задержки в 5 секунд для обратного отсчета
    timer?.cancel();
    setState(() {
      secondsPassed = 0;
      notificationPlayer
          .play(UrlSource('${appState.tempDirPath}/timer_end.mp3'));
    });
// звук завершения упражнения
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> runExerciseFromTimes(Exercise ex) async {
    // Звуковое уведомление о начале
    //await notificationPlayer.play('sound_start.mp3'); // Замените 'sound_start.mp3' на путь к звуковому файлу
    // Ожидание нажатия кнопки при завершении упражнения (здесь вы должны реализовать логику ожидания)
    // Звуковое уведомление о завершении упражнения
    //await notificationPlayer.play('sound_end.mp3'); // Замените 'sound_end.mp3' на путь к звуковому файлу
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    appState = context.watch<MyAppState>();
    Workout warmUpBefore = appState.data.warmUpBeforeList
        .firstWhere((element) => true, orElse: () => Workout('', '', []));
    Workout warmUpAfter = appState.data.warmUpAfterList
        .firstWhere((element) => true, orElse: () => Workout('', '', []));
    var exercises = List.from(warmUpBefore.exerciseList);
    exercises.addAll(widget.workout.exerciseList);
    exercises.addAll(warmUpAfter.exerciseList);

    //AudioPlayer notificationPlayer = AudioPlayer();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.workout.workoutName),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Center(child: WorkoutCard(workout: widget.workout)),
              Text('Следующее упражнение:'),
              Card(
                color: theme.colorScheme.primary,
                shadowColor: theme.shadowColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      currentExercise.repetitions == 0
                          ? currentExercise
                              .name // Показываем только имя, если repetitions равно 0
                          : '${currentExercise.name}: ${currentExercise.repetitions}',
                      style: textStyle),
                ),
              ),
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
                  if (isInProcess) {
                    return;
                  }

                  isInProcess = true;

                  if (exercises.isNotEmpty) {
                    for (var exercise in warmUpBefore.exerciseList) {
                      if (!mounted) return;
                      setState(() {
                        currentExercise = exercise;
                      });
                      await runExerciseFromTime(exercise);
                    }
                    for (var exercise in widget.workout.exerciseList) {
                      if (!mounted) return;
                      setState(() {
                        currentExercise = exercise;
                      });
                      await runExerciseFromTimes(exercise);
                    }
                    for (var exercise in warmUpAfter.exerciseList) {
                      if (!mounted) return;
                      setState(() {
                        currentExercise = exercise;
                      });
                      await runExerciseFromTime(exercise);
                    }
                  }
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                icon: Icon(Icons.play_arrow),
                label: Text('Начать'),
              ),
            ],
          ),
        ));
  }
}
