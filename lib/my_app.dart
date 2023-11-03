import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'classes/app_data.dart';
import 'classes/exercise.dart';
import 'classes/workout.dart';
import 'pages/my_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My Home Gym',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.highContrastDark(
            primary: Color.fromARGB(255, 20, 212, 164),
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier with WidgetsBindingObserver {
  AppData data = AppData.empty();
  late String tempDirPath;

  MyAppState() {
    WidgetsBinding.instance.addObserver(this);
    loadState();
  }

  Future<void> loadState() async {
    try {
      if (data.isEmpty()) {
        final tempDir = await getTemporaryDirectory();
        tempDirPath = tempDir.path;
        String jsonData = '';

        File file = File('$tempDirPath/data.json');
        if (file.existsSync()) {
          jsonData = file.readAsStringSync();
        }

        if (jsonData.isEmpty) {
          jsonData = await rootBundle.loadString('assets/data/data.json');
        }

        if (jsonData.isNotEmpty) {
          Map<String, dynamic> dataMap = jsonDecode(jsonData);
          data = AppData.fromJson(dataMap);

          notifyListeners();
        }
      }
    } on Exception catch (e) {
      // обработка исключения
      print(e);
    }
  }

  Future<void> saveState() async {
    try {
      if (!data.isEmpty()) {
        String jsonData = jsonEncode(data);

        if (jsonData.isNotEmpty) {
          File file = File('$tempDirPath/data.json');

          if (!file.existsSync()) {
            await file.create(recursive: true);
          }

          file.writeAsString(jsonData);
        }
      }
    } on Exception catch (e) {
      // обработка исключения
    }
  }

  void skipWorkout() {
    if (data.activeWorkoutList.length > 1) {
      var first = data.activeWorkoutList.removeAt(0);
      data.activeWorkoutList.add(first);

      notifyListeners();
      saveState();
    }
  }

  void startWarmUp(Workout warmup) {
    for (Exercise exercise in warmup.exerciseList) {}
  }

  void startWorkout(Workout wK) {
    for (Exercise exercise in wK.exerciseList) {}
  }
}
