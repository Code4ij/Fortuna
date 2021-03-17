import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fortuna/skillz_game/puzzle_win.dart';
import 'package:fortuna/skillz_game/puzzle_timer.dart';

class Puzzle2 extends StatefulWidget {
  final Size gameSize;
  static Function initialize;
  final Function gotoMainScreen;

  Puzzle2({Key key, this.gameSize, this.gotoMainScreen}) {
    print('Puzzle 2 constructed');
    if (initialize != null) {
      initialize();
    }
  }

  @override
  _Puzzle2State createState() => _Puzzle2State();
}

class _Puzzle2State extends State<Puzzle2> {
  PuzzleTimer _puzzleTimer;
  String msg;

  List data;
  int row = 6;
  int col = 4;
  bool isGameOver;
  bool canClink;
  int nextNumber = 0;

  int round;
  bool isWin;
  int retries = 0;

  @override
  void initState() {
    // TODO: implement initState
    print("Init");
    super.initState();
    Puzzle2.initialize = () {
      initialize();
    };
    initialize();
  }

  void initialize({bool isNew = true}) {
    print("New data loaded");
    msg = "Toque para comenzar";
    // Set Timer
    _puzzleTimer = PuzzleTimer(
      gameDuration: Duration(seconds: 30),
      gameOver: updateGameStatus,
    );

    if (isNew) {
      round = 1;
    }
    isWin = false;

    // Game Data
    List curData = List();
    data = List();
    curData.clear();
    data.clear();
    for (int i = 1; i < 25; i++) curData.add(i);
    Random rand = Random();
    int index;
    for (int i = 1; i < 25; i++) {
      index = rand.nextInt(curData.length);
      data.add(curData[index]);
      curData.removeAt(index);
    }
    nextNumber = 0;
    isGameOver = true;
    canClink = true;
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
                      'Seleccione los números en orden ascendente',
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
                index: 2,
                retries: retries,
                gotoMainScreen: widget.gotoMainScreen,
              ),
            ),
          ),
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
      // If Selects Wrong ans.
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
        isWin = true;
      }
      setState(() {});
    }
  }

  Widget getTile(int i, int j) {
//    print("Index i:$i j:$j");
    return CharTile(
      gameSize: widget.gameSize,
      col: col,
      row: row,
      i: i,
      j: j,
      data: data,
      isClickable: isClickable,
    );
  }

  int isClickable({update = ""}) {
    if (update != "") {
      nextNumber = -1;
      _puzzleTimer.timer.cancel();
      Future.delayed(Duration(seconds: 1), () {
        if (update == "Success")
          gameOver(2);
        else if (update == "Failure") gameOver(1);
      });
    }
    if (nextNumber != -1) {
      nextNumber++;
    }
    return nextNumber;
  }
}

class CharTile extends StatefulWidget {
  final int i;
  final int j;
  final Size gameSize;
  final int col;
  final int row;
  final Function isClickable;
  final List data;
  bool isSelected = false;

  CharTile(
      {Key key,
      this.i,
      this.j,
      this.gameSize,
      this.col,
      this.row,
      this.isClickable,
      this.data})
      : super(key: key);

  @override
  _CharTileState createState() => _CharTileState();
}

class _CharTileState extends State<CharTile> {
  MaterialColor onSelectColor;
  int curNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNumber();
  }

  void getNumber() {
    curNumber = widget.data[(widget.col * widget.i) + widget.j];
  }

  @override
  Widget build(BuildContext context) {
    getNumber();
    return GestureDetector(
      onTap: () {
        if (widget.isSelected) return;
        int nextNumber = widget.isClickable();
        if (nextNumber != -1) {
          if (nextNumber == curNumber) {
            onSelectColor = Colors.green;
            if (curNumber == 24) {
              widget.isClickable(
                update: "Success",
              );
            }
          } else {
            onSelectColor = Colors.red;
            widget.isClickable(
              update: "Failure",
            );
          }
          setState(() {
            widget.isSelected = true;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.isSelected
                ? onSelectColor.withOpacity(0.5)
                : Colors.white.withOpacity(0.5),
            border: Border.all(width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        width: widget.gameSize.width / (widget.col + 1),
        height: widget.gameSize.height * 0.80 / (widget.row + 1),
        child: Center(
            child: Text(
          curNumber.toString(),
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