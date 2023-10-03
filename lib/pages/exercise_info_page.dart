import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/exercise.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseInfoPage extends StatelessWidget {
  const ExerciseInfoPage({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: exercise.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
        loop: true,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(exercise.name),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Card(
              color: theme.colorScheme.primary,
              shadowColor: theme.shadowColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  exercise.name,
                  style: headerStyle,
                ),
              ),
            ),
            // описание
            Expanded(
              child: Text('как правиьно делать упражнение'),
            ),
            Text('Иллюстрация:'),
            // image
            if (exercise.imageUrl.isNotEmpty)
              Image.asset(
                exercise.imageUrl,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            Text('Видео-пример на YouTube:'),
            if (exercise.videoId.isNotEmpty)
              // video
              YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor:
                    Theme.of(context).colorScheme.primaryContainer,
              )
          ]),
        ));
  }
}
