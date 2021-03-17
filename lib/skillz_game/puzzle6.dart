import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fortuna/skillz_game/puzzle_win.dart';
import 'package:fortuna/skillz_game/puzzle_timer.dart';

final List availableColors = [
  Color(0xff1f038a),
];

final List ascentColors = [
  Color(0xff2602ab),
];

class Puzzle6 extends StatefulWidget {
  final Size gameSize;
  static Function initialize;
  final Function gotoMainScreen;

  Puzzle6({Key key, this.gameSize, this.gotoMainScreen}) {
    print('Puzzle 1 constructed');
    if (initialize != null) {
      initialize();
    }
  }

  @override
  _Puzzle6State createState() => _Puzzle6State();
}

class _Puzzle6State extends State<Puzzle6> {
  PuzzleTimer _puzzleTimer;
  String msg;

  int x;
  int y;
  int row = 8;
  int col = 5;
  Color colorA;
  Color colorB;
  bool isGameOver;
  bool canClink;

  int round;
  bool isWin;
  int retries = 0;

  @override
  void initState() {
    // TODO: implement initState
    print("Init");
    super.initState();
    Puzzle6.initialize = () {
      initialize();
    };
    initialize();
  }

  void initialize({bool isNew = true}) {
    print("New data loaded");
    msg = "Toque para comenzar";
    // Set Timer
    _puzzleTimer = PuzzleTimer(
      gameDuration: Duration(seconds: 5),
      gameOver: updateGameStatus,
    );

    if (isNew) {
      round = 1;
    }
    isWin = false;
    // Game Data
    isGameOver = true;
    canClink = true;
    Random random = Random();
    int index = random.nextInt(availableColors.length);
    if (random.nextBool()) {
      colorA = availableColors[index];
      colorB = ascentColors[index];
    } else {
      colorB = availableColors[index];
      colorA = ascentColors[index];
    }
    x = random.nextInt(row);
    y = random.nextInt(col);
  }

  @override
  Widget build(BuildContext context) {
    print("Retries: $retries");
    return Stack(
      children: [
        if (!isGameOver) _puzzleTimer,
        if(!isGameOver)
          Positioned(
          top: widget.gameSize.height * 0.05,
          child: Container(
            height: widget.gameSize.height * 0.80,
            width: widget.gameSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  row,
                  (i) => Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(col, (j) => getTile(i, j)),
                      ))),
            ),
          ),
        ),
        if (isGameOver && !isWin)
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {
                updateGameStatus(isTime: false);
              },
              child: Container(
                height: widget.gameSize.height * 0.85,
                width: widget.gameSize.width,
                color: Colors.white.withOpacity(0.5),
                child: Center(
                  child: ListView(shrinkWrap: true, children: <Widget>[
                    if (round <= 3)
                      Center(
                          child: Text(
                        "Ronda $round",
                        style: textStyle,
                        textAlign: TextAlign.center,
                      )),
                    Center(
                        child: Text(
                      msg,
                      style: textStyle,
                      textAlign: TextAlign.center,
                    )),
                    Center(
                        child: Text(
                      'Encuentre el color diferente',
                      style: textStyle,
                      textAlign: TextAlign.center,
                    )),
                  ]),
                ),
              ),
            ),
          ),
        if (isWin)
          Positioned(
            child: Container(
              color: Colors.white.withOpacity(0.5),
              width: widget.gameSize.width,
              height: widget.gameSize.height,
              child: PuzzleWin(
                gameSize: widget.gameSize,
                index: 6,
                retries: retries,
                gotoMainScreen: widget.gotoMainScreen,
              ),
            ),
          )
      ],
    );
  }

  void updateGameStatus({bool isTime: true}) {
    if (isTime) {
      isWin = false;
      round = 1;
      retries++;
    }
    setState(() {
      msg = "Se acabó el tiempo.\nToque para reintentar.";
      isGameOver = !isGameOver;
    });
  }

  void gameOver(int i) {
    initialize(isNew: false);
    if (i == 1) {
      msg = "Tocas el mosaico incorrecto.\nToque para reintentar.";
      // Start From First Round
      round = 1;
      retries++;
      setState(() {});
    } else {
      msg = "Felicidades..";
      if (round < 3) {
        round++;
      } else {
        // GameOver
        isWin = true;
      }
      setState(() {});
    }
  }

  Widget getTile(int i, int j) {
    return (i == x && j == y)
        ? CharTile(
            gameSize: widget.gameSize,
            color: colorA,
            col: col,
            row: row,
            i: i,
            j: j,
            onSelectColor: Colors.green,
            isClickable: isClickable,
          )
        : CharTile(
            gameSize: widget.gameSize,
            color: colorB,
            col: col,
            row: row,
            i: i,
            j: j,
            onSelectColor: Colors.red,
            isClickable: isClickable,
          );
  }

  bool isClickable({update = ""}) {
    if (update != "") {
      _puzzleTimer.timer.cancel();
      canClink = false;
      Future.delayed(Duration(seconds: 1), () {
        if (update == "Success")
          gameOver(2);
        else if (update == "Failure") gameOver(1);
      });
    }
    return canClink;
  }
}

class CharTile extends StatefulWidget {
  final int i;
  final int j;
  final Color color;
  final Size gameSize;
  final int col;
  final int row;
  final MaterialColor onSelectColor;
  final Function isClickable;
  bool isSelected = false;

  CharTile(
      {Key key,
      this.i,
      this.j,
      this.color,
      this.gameSize,
      this.col,
      this.row,
      this.onSelectColor,
      this.isClickable})
      : super(key: key);

  @override
  _CharTileState createState() => _CharTileState();
}

class _CharTileState extends State<CharTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isClickable()) {
          if (widget.onSelectColor == Colors.green)
            widget.isClickable(
              update: "Success",
            );
          else if (widget.onSelectColor == Colors.red)
            widget.isClickable(
              update: "Failure",
            );
          setState(() {
            widget.isSelected = true;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(
                width: widget.isSelected ? 5 : 0,
                color: widget.isSelected
                    ? widget.onSelectColor
                    : Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        width: widget.gameSize.width / (widget.col + 1),
        height: widget.gameSize.height * 0.80 / (widget.row + 1),
      ),
    );
  }
}

final textStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);