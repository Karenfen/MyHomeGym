import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_app.dart';
import '../widjets/workout_card.dart';

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        for (var item in appState.data.workoutList) WorkoutCard(workout: item),
      ],
    );
  }
}
