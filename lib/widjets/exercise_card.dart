import 'package:flutter/material.dart';

import '../classes/exercise.dart';

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
            Icon(Icons.accessibility_new_rounded),
            Expanded(
              child: Text(
                exercise.name,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Text('${exercise.repetitions}'),
          ],
        ),
      ),
    );
  }
}