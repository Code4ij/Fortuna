import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TapToStart extends StatefulWidget {
  final Size size;
  Function startGame;
  final Function updateScreen;

  TapToStart({Key key, this.size, this.updateScreen}) : super(key: key);

  @override
  _TapToStartState createState() => _TapToStartState();
}

class _TapToStartState extends State<TapToStart> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        color: Colors.white.withOpacity(0.5),
        child: Center(
          child: Text(
            "Tap To Start",
          ),
        ),
      ),
      onTap: () {
        widget.updateScreen();
      },
    );
  }
}
