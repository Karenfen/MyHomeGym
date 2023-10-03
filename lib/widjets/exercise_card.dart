import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/exercise_info_page.dart';

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
            Expanded(
              child: Text(
                exercise.name,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExerciseInfoPage(exercise: exercise),
                ));
              },
              icon: Icon(Icons.info_outline_rounded),
              label: Text('info'),
            ),
          ],
        ),
      ),
    );
  }
}
