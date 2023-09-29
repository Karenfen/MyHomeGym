import 'package:flutter/material.dart';

import 'exercise.dart';
import 'workout.dart';

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
    Text header = Text('Упражнения');

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
              items: [
                DropdownMenuItem(
                  value: header,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Упражнения - '),
                      Text('${workout.exerciseList.length}'),
                    ],
                  ),
                ),
                for (var item in workout.exerciseList)
                  DropdownMenuItem<Exercise>(
                    value: item,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.name} '),
                        Text('${item.repetitions}'),
                      ],
                    ),
                  )
              ],
              value: header,
              onChanged: (item) {},
              //Text('${exerciseList.length} упражнения'),
            ),
          ],
        ),
      ),
    );
  }
}
