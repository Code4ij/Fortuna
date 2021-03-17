import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class Patikda extends StatefulWidget {
  final Alignment alignment;
  final int seconds;

  Patikda({Key key, this.alignment = Alignment.center, this.seconds = 10})
      : super(key: key);

  @override
  _PatikdaState createState() => _PatikdaState();
}

class _PatikdaState extends State<Patikda> {
  ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        ConfettiController(duration: Duration(seconds: widget.seconds));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.play();
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              // don't specify a direction, blast randomly
              shouldLoop: false,
              // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ])),
    );
  }
}
