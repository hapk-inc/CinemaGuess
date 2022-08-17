import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GamePageLoader extends StatelessWidget {
  const GamePageLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: AutoSizeText(
        orientation == Orientation.portrait
            ? "Do you watch Movies \nframe by frame,\nremember "
                "the scenes still now?"
            : "Do you watch movies frame by frame, remember the scenes still now?",
        style: TextStyle(
          fontSize: size.shortestSide * 0.05,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
