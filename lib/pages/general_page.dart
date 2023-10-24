import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_app.dart';
import '../widjets/workout_card.dart';
import 'workout_start_page.dart';

class GeneralPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var workouts = appState.data.activeWorkoutList;

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
