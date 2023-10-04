import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

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
