import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widjets/exercise_card.dart';
import 'package:audioplayers/audioplayers.dart';

import '../classes/exercise.dart';
import '../classes/workout.dart';
import '../widjets/workout_card.dart';

class WorkoutStartPage extends StatefulWidget {
  const WorkoutStartPage({super.key, required this.workout});

  final Workout workout;

  @override
  State<WorkoutStartPage> createState() => _WorkoutStartPageState();
}

class _WorkoutStartPageState extends State<WorkoutStartPage> {
  late Workout workout;
  int secondsLeft = 0;
  Exercise currentExercise = Exercise.empty();
  AudioPlayer startNotificationPlayer = AudioPlayer();
  AudioPlayer endNotificationPlayer = AudioPlayer();
  AudioPlayer finishNotificationPlayer = AudioPlayer();
  bool isPause = false;
  bool isRun = false;
  bool isCompleted = false;
  bool isCurrentExerciseWaitingForComplete = false;
  Icon iconButtonStart = Icon(Icons.play_arrow_rounded);
  Text labelButtonStart = Text('Начать');
  late String audioName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    workout = widget.workout.copy();

    startNotificationPlayer.setSourceAsset('sounds/start.wav');
    startNotificationPlayer.setReleaseMode(ReleaseMode.stop);
    endNotificationPlayer.setSourceAsset('sounds/end.wav');
    endNotificationPlayer.setReleaseMode(ReleaseMode.stop);
    finishNotificationPlayer.setSourceAsset('sounds/finish.wav');
    finishNotificationPlayer.setReleaseMode(ReleaseMode.stop);

    workout.onExerciseBegin = (Exercise newExercise) {
      setState(() {
        currentExercise = newExercise;
      });

      currentExercise.onTick = (seconds) {
        setState(() {
          secondsLeft = seconds;
        });
      };

      currentExercise.onBegine = (seconds) {
        setState(() {
          secondsLeft = seconds;
          isPause = false;
          iconButtonStart = Icon(Icons.pause_rounded);
          labelButtonStart = Text('Пауза');
        });

        startNotificationPlayer.resume();
      };

      currentExercise.onDone = () {
        endNotificationPlayer.resume();
      };

      currentExercise.onGetReady = (seconds) {
        setState(() {
          secondsLeft = seconds;
        });

        /// уведомление "приготовиться"
      };
      currentExercise.onWaitingForComplete = () {
        setState(() {
          isCurrentExerciseWaitingForComplete = true;
          iconButtonStart = Icon(Icons.done_rounded);
          labelButtonStart = Text('Готово');
        });
      };

      currentExercise.onRelax = (seconds) {
        setState(() {
          secondsLeft = seconds;
        });

        // уведомление "отдохните"
      };
    };

    workout.initExerciseList();
    currentExercise = workout.exerciseList.first;
  }

  @override
  void dispose() {
    startNotificationPlayer.dispose();
    endNotificationPlayer.dispose();
    finishNotificationPlayer.dispose();

    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> run() async {
    setState(() {
      isRun = true;
      iconButtonStart = Icon(Icons.pause_rounded);
      labelButtonStart = Text('Пауза');
    });

    await workout.run();

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
          title: Text(workout.name),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Center(child: WorkoutCard(workout: workout)),
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
                  child: Text('$secondsLeft', style: textStyle),
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (isRun) {
                        if (isPause) isPause = false;
                        workout.previous();
                      }
                    },
                    icon: Icon(Icons.skip_previous_rounded),
                    label: Text('Пред.'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (!mounted) return;

                      if (isCompleted) Navigator.pop(context);

                      if (isRun) {
                        if (isCurrentExerciseWaitingForComplete) {
                          setState(() {
                            isCurrentExerciseWaitingForComplete = false;
                          });
                          currentExercise.exerciseCompleted();
                          setState(() {
                            isCurrentExerciseWaitingForComplete = false;
                            iconButtonStart = Icon(Icons.pause_rounded);
                            labelButtonStart = Text('Пауза');
                          });
                          return;
                        }
                        setState(() {
                          isPause = !isPause;
                          iconButtonStart = isPause
                              ? Icon(Icons.play_arrow)
                              : Icon(Icons.pause);
                          labelButtonStart =
                              isPause ? Text('Прод.') : Text('Пауза');
                          if (isPause) {
                            workout.pause();
                          } else {
                            workout.resume();
                          }
                        });
                      } else {
                        run();
                      }
                    },
                    icon: iconButtonStart,
                    label: labelButtonStart,
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (isRun) {
                        if (isPause) isPause = false;
                        workout.skip();
                      }
                    },
                    icon: Icon(Icons.skip_next_rounded),
                    label: Text('След.'),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
