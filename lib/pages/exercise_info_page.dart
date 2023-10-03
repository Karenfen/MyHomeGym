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
      initialVideoId: exercise.videoUrl,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
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
            // image
            Image.asset(
              exercise.imageUrl,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            // описание
            Expanded(
              child: Text('как правиьно делать упражнение'),
            ),
            // video
            YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
            )
          ]),
        ));
  }
}
