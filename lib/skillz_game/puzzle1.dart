import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fortuna/skillz_game/puzzle_win.dart';
import 'package:fortuna/skillz_game/puzzle_timer.dart';

class Puzzle1 extends StatefulWidget {
  Map data = {"7": "1", "B": "8", "8": "3"};
  final Size gameSize;
  static Function initialize;
  final Function gotoMainScreen;

  Puzzle1({Key key, this.gameSize, this.gotoMainScreen}) {
    print('Puzzle 1 constructed');
    if (initialize != null) {
      initialize();
    }
  }

  @override
  _Puzzle1State createState() => _Puzzle1State();
}

class _Puzzle1State extends State<Puzzle1> {
  PuzzleTimer _puzzleTimer;
  String msg;

  int x;
  int y;
  int row = 8;
  int col = 5;
  String charA;
  String charB;
  bool isGameOver;
  bool canClink;

  int round;
  bool isWin;
  int retries = 0;

  @override
  void initState() {
    print("Init");
    super.initState();
    Puzzle1.initialize = () {
      initialize();
    };
    initialize();
  }

  void initialize({bool isNew = true}) {
    print("New data loaded");
    msg = "Toque para comenzar";
    // Set Timer
    _puzzleTimer = PuzzleTimer(
      gameDuration: Duration(seconds: 10),
      gameOver: updateGameStatus,
    );

    // Game Data
    if (isNew) {
      round = 1;
    }
    isWin = false;

    isGameOver = true;
    canClink = true;
    Random random = Random();
    int index = random.nextInt(3);
    String data_index = widget.data.keys.elementAt(index);
    if (random.nextInt(2) == 0) {
      charA = data_index;
      charB = widget.data[data_index];
    } else {
      charB = data_index;
      charA = widget.data[data_index];
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
                        textAlign: TextAlign.center,
                        style: textStyle,
                      )),
                    Center(
                        child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    )),
                    Center(
                        child: Text('Encuentre el diferente',
                            textAlign: TextAlign.center, style: textStyle,)),
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
                index: 1,
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
      // If Time over.
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
      // If Selects Wrong ans.
      msg = "Tocas el mosaico incorrecto.\nToque para reintentar.";
      // Start From First Round
      round = 1;
      retries++;
      setState(() {});
    } else {
      msg = "¡Felicidades!";
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
            char: charA,
            col: col,
            row: row,
            i: i,
            j: j,
            onSelectColor: Colors.green,
            isClickable: isClickable,
          )
        : CharTile(
            gameSize: widget.gameSize,
            char: charB,
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
  final String char;
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
      this.char,
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
            color: widget.isSelected
                ? widget.onSelectColor.withOpacity(0.5)
                : Colors.white.withOpacity(0.5),
            border: Border.all(width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        width: widget.gameSize.width / (widget.col + 1),
        height: widget.gameSize.height * 0.80 / (widget.row + 1),
        child: Center(
            child: Text(
          widget.char,
          style: TextStyle(fontSize: 20),
        )),
      ),
    );
  }
}

final textStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);