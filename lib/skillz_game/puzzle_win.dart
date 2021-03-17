import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:fortuna/common/patikda.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/templates/gamepage.dart';

class PuzzleWin extends StatefulWidget {
  final Function gotoMainScreen;
  final int index;
  final int retries;
  final Size gameSize;

  const PuzzleWin({Key key, this.gotoMainScreen, this.index, this.retries, this.gameSize}) : super(key: key);

  @override
  _PuzzleWinState createState() => _PuzzleWinState();
}

class _PuzzleWinState extends State<PuzzleWin> {
  String troffyImage;
  int roundScore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateScore();
    goBack();
  }

  void calculateScore() {
    // Select Troffy Image
    troffyImage = "diamond.png";
    roundScore = 5;
    if(widget.retries >= 1 && widget.retries <= 2) {
      troffyImage = "gold.png";
      roundScore = 4;
    }
    else if(widget.retries > 2) {
      troffyImage = "platinum.png";
      roundScore = 3;
    }


    final prefs = Prefs();
    Map score = prefs.data[7];
    print(score);

    if (score["solvedGame"] <= widget.index) {
      score["solvedGame"] = widget.index + 1;
    }
    int curScore = score["${widget.index}"];
    score["${widget.index}"] = max(curScore, roundScore);

    int total = 0;
    for (int i = 1; i <= 6; i++) {
      total += score["$i"];
    }
    score["total"] = total;
    print(score);
    Prefs().updateScore(7, score);
  }

  void goBack() {
    Future.delayed(Duration(seconds: 2), () {
      widget.gotoMainScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Patikda(
          seconds: 3,
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("asset/image/$troffyImage", width: widget.gameSize.width / 2, fit: BoxFit.contain,),
              SizedBox(
                height: 20,
              ),
              Text(
                "Felicidades...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
