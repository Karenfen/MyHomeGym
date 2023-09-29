import 'dart:async';
import 'dart:convert';
// import 'dart:js_interop';
// import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/appdata.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'exercise.dart';
import 'exerciseCard.dart';
import 'workout.dart';
import 'workoutCard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My Home Gym',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 97, 81)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier with WidgetsBindingObserver {
  //late Directory dataDir;
  //late File dataFile; // = File('assets/data/data.txt');
  AppData data = AppData([], [], [], []);
  String srcDir = 'files/sounds';
  late String tempDirPath;
  List<String> asetsName = ['/timer_start.mp3', '/timer_end.mp3'];

  MyAppState() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      saveState();
    }
  }

  Future<void> loadState() async {
    if (data.isEmpty()) {
      final jsonData = await rootBundle.loadString('files/data/data.txt');
      if (jsonData.isNotEmpty) {
        Map<String, dynamic> dataMap = jsonDecode(jsonData);
        data = AppData.fromJson(dataMap);
        notifyListeners();
      }
      // dataFile = File('assets/data/data.txt');
      // if (dataFile.existsSync()) {
      //   String jsonData = dataFile.readAsStringSync();
      //   if (jsonData.isNotEmpty) {
      //     Map<String, dynamic> dataMap = jsonDecode(jsonData);
      //     data = AppData.fromJson(dataMap);
      //     notifyListeners();
      //   }
      // }
    }

    final tempDir = await getTemporaryDirectory();
    tempDirPath = tempDir.path;

    for (var fileName in asetsName) {
      File file = File('$tempDirPath$fileName');
      if (!file.existsSync()) {
        await file.create(recursive: true);
      }
      final fileData = await rootBundle.load('$srcDir$fileName');
      file.writeAsBytes(fileData.buffer.asUint8List());
    }
  }

  void saveState() {
    if (!data.isEmpty()) {
      String jsonData = jsonEncode(data);

      if (jsonData.isNotEmpty) {
        //dataFile.writeAsString(jsonData);
      }
    }
  }

  void skipWorkout() {
    if (data.workoutList.length > 1) {
      var first = data.workoutList.removeAt(0);
      data.workoutList.add(first);
      notifyListeners();
    }
  }

  void startWarmUp(Workout warmup) {
    for (Exercise exercise in warmup.exerciseList) {}
  }

  void startWorkout(Workout wK) {
    for (Exercise exercise in wK.exerciseList) {}
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var stateSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    context.watch<MyAppState>().loadState();

    Widget page;
    switch (stateSelectedIndex) {
      case 0:
        page = GeneralPage();
        break;
      case 1:
        page = WorkoutPage();
        break;
      case 2:
        page = ExercisePage();
        break;
      case 3:
        page = StatisticPage();
        break;
      default:
        throw UnimplementedError('no widget for $stateSelectedIndex');
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.whatshot_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_rounded),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_gymnastics_rounded),
            label: 'Exercises',
          ),
          NavigationDestination(
            icon: Icon(Icons.query_stats_rounded),
            label: 'Info',
          ),
        ],
        selectedIndex: stateSelectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            stateSelectedIndex = value;
          });
        },
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
    );
  }
}

class GeneralPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var workouts = appState.data.workoutList;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ListView(
            reverse: true,
            shrinkWrap: true,
            children: [for (var item in workouts) WorkoutCard(workout: item)],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                if (workouts.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        WorkoutStartPage(workout: workouts.first),
                  ));
                }
              },
              icon: Icon(Icons.play_arrow),
              label: Text('Начать'),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              onPressed: () {
                appState.skipWorkout();
              },
              icon: Icon(Icons.reply),
              label: Text('Пропустить'),
            )
          ],
        ),
      ],
    );
  }
}

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        for (var item in appState.data.warmUpBeforeList)
          WorkoutCard(workout: item),
        for (var item in appState.data.warmUpAfterList)
          WorkoutCard(workout: item),
        for (var item in appState.data.workoutList) WorkoutCard(workout: item),
      ],
    );
  }
}

class ExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        for (var item in appState.data.exerciseList)
          ExerciseCard(exercise: item)
      ],
    );
  }
}

class StatisticPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    //appState.loadState();

    return ListView(
      scrollDirection: Axis.vertical,
      // scrollDirection: Axis.vertical,
      // children: [
      //   for (var pairWords in appState.favorite)
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         BigCard(
      //             pairAsString:
      //                 appState.pairToSeparatedString(pairWords).toUpperCase()),
      //         SizedBox(
      //           width: 10,
      //         ),
      //         ElevatedButton.icon(
      //           onPressed: () {
      //             appState.removeFavoritPair(pairWords);
      //           },
      //           icon: Icon(iconRemove),
      //           label: Text('Remove'),
      //         )
      //       ],
      //     ),
      // ],
    );
  }
}

class WorkoutStartPage extends StatefulWidget {
  const WorkoutStartPage({super.key, required this.workout});

  final Workout workout;

  @override
  State<WorkoutStartPage> createState() => _WorkoutStartPageState();
}

class _WorkoutStartPageState extends State<WorkoutStartPage> {
  Timer? timer;
  int secondsPassed = 0;
  Exercise currentExercise = Exercise('Приготовьтесь!', 0);
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
      notificationPlayer.play('${appState.tempDirPath}/timer_start.mp3');
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
      notificationPlayer.play('${appState.tempDirPath}/timer_end.mp3');
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
        body: Column(
          children: [
            WorkoutCard(workout: widget.workout),
            Text('Следующее упражнение:'),
            Card(
              color: theme.colorScheme.primary,
              shadowColor: theme.shadowColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '${currentExercise.name}: ${currentExercise.repetitions}',
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
        ));
  }
}
