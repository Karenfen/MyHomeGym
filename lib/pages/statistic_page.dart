import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_app.dart';

class StatisticPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView(
      scrollDirection: Axis.vertical,
      // scrollDirection: Axis.vertical,
      // children: [
      //   for (var pairWords in appState.favorite)
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         BigCard(
      //             pairAsString:
      //                 appState.pairToSeparatedString(pairWords).toUpperCase()),
      //         SizedBox(
      //           width: 10,
      //         ),
      //         ElevatedButton.icon(
      //           onPressed: () {
      //             appState.removeFavoritPair(pairWords);
      //           },
      //           icon: Icon(iconRemove),
      //           label: Text('Remove'),
      //         )
      //       ],
      //     ),
      // ],
    );
  }
}
