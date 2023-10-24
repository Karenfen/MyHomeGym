import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/exercise.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseInfoPage extends StatefulWidget {
  const ExerciseInfoPage({super.key, required this.exercise});

  final Exercise exercise;

  @override
  State<ExerciseInfoPage> createState() => _ExerciseInfoPageState();
}

class _ExerciseInfoPageState extends State<ExerciseInfoPage> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: widget.exercise.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
        loop: true,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameStyle = theme.textTheme.headlineLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    final typeStyle = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.exercise.name),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: ListView(children: [
            Card(
              color: theme.colorScheme.primary,
              shadowColor: theme.shadowColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.exercise.name,
                      style: nameStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.exercise.getExerciseTypeAsString(),
                      style: typeStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.exercise.getWorkoutTypeAsString(),
                      style: typeStyle,
                    ),
                  ),
                ],
              ),
            ),

            Text('Иллюстрация:'),
            // image
            if (widget.exercise.imageUrl.isNotEmpty)
              Image.asset(
                widget.exercise.imageUrl,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            Text('Видео-пример на YouTube:'),
            if (widget.exercise.videoId.isNotEmpty)
              // video
              YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor:
                    Theme.of(context).colorScheme.primaryContainer,
              ),
            // описание
            Expanded(
              child: Text(widget.exercise.info),
            ),
          ]),
        ));
  }
}
