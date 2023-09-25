import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/appdata.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'exercise.dart';
import 'workout.dart';

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
        title: 'Namer App',
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
  late Directory dataDir;
  late File dataFile;
  List<Exercise> exerciseList = [
    // Exercise(
    //   'Отжимания алмазые',
    //   12,
    // ),
    // Exercise(
    //   'Отжимания горкой',
    //   12,
    // ),
    // Exercise(
    //   'Подтягивания прямым хватом',
    //   12,
    // ),
    // Exercise(
    //   'Подтягивания обратным хватом',
    //   12,
    // ),
    // Exercise(
    //   'Болгарскиу сплит-приседания',
    //   20,
    // ),
    // Exercise(
    //   'Скандинавские скручивания',
    //   20,
    // ),
    // Exercise(
    //   'Скручивания на пресс',
    //   25,
    // ),
    // Exercise(
    //   'Упражнение "супермен"',
    //   25,
    // ),
    // Exercise(
    //   'Зашагивание на возвышение',
    //   20,
    // ),
    // Exercise(
    //   'Разтяжка "кобра"',
    //   20,
    // ),
    // Exercise(
    //   'Грудь',
    //   20,
    // ),
    // Exercise(
    //   'Скручивания в пояснице лёжа на полу (влево)',
    //   20,
    // ),
    // Exercise(
    //   'Скручивания в пояснице лёжа на полу (вправо)',
    //   20,
    // ),
    // Exercise(
    //   'Поза ребёнка',
    //   30,
    // ),
    // Exercise(
    //   'Махи руками с шагами в стороны',
    //   30,
    // ),
    // Exercise(
    //   'Прыжки без скакалки',
    //   30,
    // ),
    // Exercise(
    //   'Наклоны вперёд со скручиванием',
    //   30,
    // ),
    // Exercise(
    //   'Бег, колени вверх',
    //   30,
    // ),
    // Exercise(
    //   'Приводящая мышца - стоя',
    //   30,
    // ),
  ];
  List<Workout> workoutList = <Workout>[
    // Workout(
    //   'Тренировка 1',
    //   'На всё тело',
    //   [
    //     Exercise(
    //       'Отжимания алмазые',
    //       12,
    //     ),
    //     Exercise(
    //       'Подтягивания прямым хватом',
    //       12,
    //     ),
    //     Exercise(
    //       'Болгарскиу сплит-приседания',
    //       20,
    //     ),
    //     Exercise(
    //       'Скандинавские скручивания',
    //       20,
    //     ),
    //     Exercise(
    //       'Скручивания на пресс',
    //       25,
    //     ),
    //     Exercise(
    //       'Упражнение "супермен"',
    //       25,
    //     ),
    //   ],
    // ),
    // Workout(
    //   'Тренировка 2',
    //   'На всё тело',
    //   [
    //     Exercise(
    //       'Отжимания горкой',
    //       12,
    //     ),
    //     Exercise(
    //       'Подтягивания обратным хватом',
    //       12,
    //     ),
    //     Exercise(
    //       'Зашагивание на возвышение',
    //       20,
    //     ),
    //     Exercise(
    //       'Сгибание ног на бицепс бедра, лёжа на спине',
    //       20,
    //     ),
    //     Exercise(
    //       'Подъём ног к турнику в висе',
    //       25,
    //     ),
    //     Exercise(
    //       'Упражнение "пловец"',
    //       25,
    //     ),
    //   ],
    // ),
  ];
  List<Workout> warmUpAfterList = <Workout>[
    // Workout(
    //   'Разтяжка',
    //   'После тренировки',
    //   [
    //     Exercise(
    //       'Разтяжка "кобра"',
    //       20,
    //     ),
    //     Exercise(
    //       'Грудь',
    //       20,
    //     ),
    //     Exercise(
    //       'Скручивания в пояснице лёжа на полу (влево)',
    //       20,
    //     ),
    //     Exercise(
    //       'Скручивания в пояснице лёжа на полу (вправо)',
    //       20,
    //     ),
    //     Exercise(
    //       'Поза ребёнка',
    //       30,
    //     ),
    //   ],
    // ),
  ];
  List<Workout> warmUpBeforeList = <Workout>[
    // Workout(
    //   'Разминка',
    //   'Перед тренировкой',
    //   [
    //     Exercise(
    //       'Махи руками с шагами в стороны',
    //       30,
    //     ),
    //     Exercise(
    //       'Прыжки без скакалки',
    //       30,
    //     ),
    //     Exercise(
    //       'Наклоны вперёд со скручиванием',
    //       30,
    //     ),
    //     Exercise(
    //       'Бег, колени вверх',
    //       30,
    //     ),
    //     Exercise(
    //       'Приводящая мышца - стоя',
    //       30,
    //     ),
    //   ],
    // ),
  ];

  AppData data = AppData([], [], [], []);

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
      dataDir = await getApplicationDocumentsDirectory();
      dataFile = File('${dataDir.path}/data.data');
      if (dataFile.existsSync()) {
        String jsonData = dataFile.readAsStringSync();
        if (jsonData.isNotEmpty) {
          Map<String, dynamic> dataMap = jsonDecode(jsonData);
          data = AppData.fromJson(dataMap);
          notifyListeners();
        }
      }
    }
  }

  void saveState() {
    data =
        AppData(warmUpBeforeList, warmUpAfterList, workoutList, exerciseList);
    String jsonData = jsonEncode(data);

    if (jsonData.isNotEmpty) {
      dataFile.writeAsString(jsonData);
    }
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
                // начать тренировку
              },
              icon: Icon(Icons.play_arrow),
              label: Text('Начать'),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              onPressed: () {
                // пропустить тренировку
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
    appState.loadState();

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
    appState.loadState();

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

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    final textStyle = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      shadowColor: theme.shadowColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              workout.workoutName,
              style: headerStyle,
            ),
            Text(
              workout.workoutType,
              style: textStyle,
            ),
            DropdownButton(
              icon: Icon(Icons.format_list_bulleted_rounded),
              items: [
                for (var item in workout.exerciseList)
                  DropdownMenuItem<Exercise>(
                    value: item,
                    child: Row(
                      children: [
                        Icon(Icons.accessibility_rounded),
                        Text('${item.name} ${item.repetitions}'),
                      ],
                    ),
                  )
              ],
              value: workout.exerciseList.first,
              onChanged: (item) {},
              //Text('${exerciseList.length} упражнения'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      shadowColor: theme.shadowColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.ac_unit_rounded),
            Text(
              exercise.name,
              style: textStyle,
            ),
            Text('${exercise.repetitions}'),
          ],
        ),
      ),
    );
  }
}
