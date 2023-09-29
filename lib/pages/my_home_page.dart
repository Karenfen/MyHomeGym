import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_app.dart';
import 'exercise_page.dart';
import 'general_page.dart';
import 'statistic_page.dart';
import 'workout_page.dart';

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
