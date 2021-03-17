import 'dart:async';

import 'package:flutter/material.dart';

class PuzzleTimer extends StatefulWidget {
  final Duration gameDuration;
  static Function initialize;
  Timer timer;
  final Function gameOver;

  PuzzleTimer({Key key, this.gameDuration, this.gameOver}) : super(key: key) {
    if (initialize != null) {
      initialize();
    }
  }

  @override
  _PuzzleTimerState createState() => _PuzzleTimerState();
}

class _PuzzleTimerState extends State<PuzzleTimer> {
  Duration _time;

  @override
  void initState() {
    super.initState();
    PuzzleTimer.initialize = () {
      initialize();
    };
    initialize();
  }

  void initialize() {
    widget.timer = null;
    widget.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(mounted) {
        setState(() {
          _time = _time - Duration(seconds: 1);
          if(_time <= Duration(seconds: 0)) {
            // Timer Over.
            cancelTimer();
          }
        });
      }
    });
    _time = widget.gameDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: TimerWidget(),
      alignment: Alignment.topCenter,
    );
  }

  // ignore: non_constant_identifier_names
  Widget TimerWidget() {
    final size = MediaQuery.of(context).size;
    final seconds = _time.inSeconds % 60;
    int minutes = (_time.inSeconds - seconds) ~/ 60;
    String timeString = '${format(minutes)} : ${format(seconds)}';
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black,
              width: 1
          ),
          color: Colors.white.withOpacity(0.7)
      ),
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.2,
      height: size.height * 0.03,
      child: Center(
        child: Text(timeString),
      ),
    );
  }

  String format(int x) {
    if(x == 0)  return '00';
    else if(x < 10) return '0' + x.toString();
    else  return x.toString();
  }

  void cancelTimer() {
    widget.timer.cancel();
    widget.timer = null;
    widget.gameOver();
  }
}
