import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fortuna/skillz_game/puzzle_win.dart';
import 'package:fortuna/skillz_game/puzzle_timer.dart';

final Map puzzle4Data = {
  "PURPLE": Colors.purple,
  "BLACK": Colors.black,
  "RED": Colors.red,
  "GREEN": Colors.green,
  "BLUE": Colors.blue,
  "BROWN": Colors.brown,
  "YELLOW": Colors.yellow
};

String getText(String color) {
  if (color == "YELLOW")
    return "AMARILLO";
  else if (color == "BLACK")
    return "NEGRO";
  else if (color == "RED")
    return "ROJO";
  else if (color == "GREEN")
    return "VERDE";
  else if (color == "BLUE")
    return "AZUL";
  else if (color == "BROWN")
    return "MARRÓN";
  else if (color == "PURPLE") return "PÚRPURA";
}

int puzzle4MaxQuestion = 6;

class Puzzle4 extends StatefulWidget {
  final Size gameSize;
  static Function initialize;
  final Function gotoMainScreen;

  Puzzle4({Key key, this.gameSize, this.gotoMainScreen}) {
    print('Puzzle 4 constructed');
    if (initialize != null) {
      initialize();
    }
  }

  @override
  _Puzzle4State createState() => _Puzzle4State();
}

class _Puzzle4State extends State<Puzzle4> {
  PuzzleTimer _puzzleTimer;
  String msg;

  String buttonColor;
  Color color1, color2, color3;
  List pos;

  int curIndex;
  bool isGameOver;
  bool isWrongAns;

  bool isWin;
  int retries = 0;

  @override
  void initState() {
    print("Init");
    super.initState();
    Puzzle4.initialize = () {
      initialize();
    };
    initialize();
  }

  void initialize() {
    print("New data loaded");
    msg = "Toque para comenzar";
    // Set Timer
    _puzzleTimer = PuzzleTimer(
      gameDuration: Duration(seconds: 15),
      gameOver: updateGameStatus,
    );

    isWin = false;
    // Game Data
    curIndex = 0;
    pos = [1, 2, 3];
    isGameOver = true;
    isWrongAns = false;
    generateQuestion();
  }

  void generateQuestion() {
    Random rand = new Random();
    int a = rand.nextInt(puzzle4Data.length);
    buttonColor = puzzle4Data.keys.elementAt(a);
    color1 = puzzle4Data[buttonColor];

    int b = a;
    while (b == a) b = rand.nextInt(puzzle4Data.length);
    color2 = puzzle4Data.values.elementAt(b);

    int c = b;
    while (c == a || c == b) c = rand.nextInt(puzzle4Data.length);
    color3 = puzzle4Data.values.elementAt(c);

    pos.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    print("Retries: $retries");
    return Container(
      color: Colors.white.withOpacity((isGameOver || isWrongAns) ? 0 : 0.7),
      child: Stack(
        children: [
          if (!isGameOver) _puzzleTimer,
          if (!isGameOver )
            Positioned(
              top: widget.gameSize.height * 0.3,
              child: Container(
                width: widget.gameSize.width,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Toque el botón ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: "${getText(buttonColor)}",
                            style: TextStyle(
                                color:
                                    Random().nextInt(3) == 0 ? color1 : color2,
                                fontWeight: FontWeight.bold)),
                      ],
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          if (!isGameOver)
            Positioned(
              top: widget.gameSize.height * 0.6,
              child: Container(
                width: widget.gameSize.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (pos[0] == 1)
                          updateQue(true);
                        else
                          updateQue(false);
                      },
                      child: Container(
                        width: widget.gameSize.width / 4,
                        height: widget.gameSize.height * 0.1,
                        color: pos[0] == 1
                            ? color1
                            : (pos[0] == 2 ? color2 : color3),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (pos[1] == 1)
                          updateQue(true);
                        else
                          updateQue(false);
                      },
                      child: Container(
                        width: widget.gameSize.width / 4,
                        height: widget.gameSize.height * 0.1,
                        color: pos[1] == 1
                            ? color1
                            : (pos[1] == 2 ? color2 : color3),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (pos[2] == 1)
                          updateQue(true);
                        else
                          updateQue(false);
                      },
                      child: Container(
                        width: widget.gameSize.width / 4,
                        height: widget.gameSize.height * 0.1,
                        color: pos[2] == 1
                            ? color1
                            : (pos[2] == 2 ? color2 : color3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isWrongAns)
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () {
                  updateGameStatus(m: "Toca para comenzar");
                },
                child: Container(
                  height: widget.gameSize.height * 0.85,
                  width: widget.gameSize.width,
                  color: Colors.white.withOpacity(0.8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("asset/image/cross.png"),
                      ListView(shrinkWrap: true, children: <Widget>[
                        Center(
                            child: Text(
                          "Respuesta incorrecta\nInténtalo de nuevo",
                          textAlign: TextAlign.center,
                          style: textStyle,
                        )),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          if (isGameOver && !isWin)
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () {
                  updateGameStatus(
                      m: "Se acabó el tiempo\nToque para reintentar.");
                },
                child: Container(
                  height: widget.gameSize.height * 0.85,
                  width: widget.gameSize.width,
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      Center(
                          child: Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: textStyle,
                      )),
                      Center(
                          child: Text(
                        'Elija la opción correcta',
                        textAlign: TextAlign.center,
                        style: textStyle,
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
                  index: 4,
                  retries: retries,
                  gotoMainScreen: widget.gotoMainScreen,
                ),
              ),
            )
        ],
      ),
    );
  }

  void updateQue(bool isCorrect) {
    if (isCorrect) {
      curIndex += 1;
      if (curIndex >= puzzle4MaxQuestion) {
        // TODO: GameOver.
        setState(() {
          curIndex = 0;
          isWrongAns = false;
          isWin = true;
          msg = "Toca para comenzar";
          isGameOver = !isGameOver;
        });
      } else {
        generateQuestion();
        setState(() {});
      }
    } else {
      retries++;
      updateAnsStatus(true);
    }
  }

  void updateAnsStatus(bool ans) {
    setState(() {
      _puzzleTimer.timer.cancel();
      isWrongAns = ans;
    });
  }

  void updateGameStatus(
      {String m = "Se acabó el tiempo.\nToque para reintentar."}) {
    if (m == "Se acabó el tiempo.\nToque para reintentar.") {
      retries++;
    }
    generateQuestion();
    setState(() {
      curIndex = 0;
      isWrongAns = false;
      msg = m;
      isGameOver = !isGameOver;
    });
  }
}

final textStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);
