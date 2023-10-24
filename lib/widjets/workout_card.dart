import 'package:flutter/material.dart';

import '../classes/exercise.dart';
import '../classes/workout.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.headlineLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    final textStyle = theme.textTheme.headlineSmall!.copyWith(
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
              workout.name,
              style: headerStyle,
            ),
            Text(
              workout.getWorkoutTypeAsString(),
              style: textStyle,
            ),
            Text(
              workout.getExerciseTypeAsString(),
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
                    child: Center(
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: screenWidth * 0.8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.name} ',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Text('${item.repetitions}'),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
              value: header,
              onChanged: (item) {
                if (item is Exercise) {
                  item.showInfo(context);
                }
              },
              //Text('${exerciseList.length} упражнения'),
            ),
          ],
        ),
      ),
    );
  }
}
