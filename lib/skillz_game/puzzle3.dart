import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fortuna/skillz_game/puzzle_win.dart';
import 'package:fortuna/skillz_game/puzzle_timer.dart';

int puzzle3MaxQuestion = 6;
final Map puzzle3Data = {
  "No es un circulo verde": [
    {"color": Colors.green, "shape": "circle", "ans": false},
    {"color": Colors.green, "shape": "square", "ans": true},
    {"color": Colors.blue, "shape": "circle", "ans": true},
  ],
  "Es un circulo verde": [
    {"color": Colors.green, "shape": "circle", "ans": true},
    {"color": Colors.green, "shape": "square", "ans": false},
    {"color": Colors.blue, "shape": "circle", "ans": false},
    {"color": Colors.blue, "shape": "square", "ans": false}
  ],
  "No es un cuadrado verde": [
    {"color": Colors.green, "shape": "circle", "ans": true},
    {"color": Colors.green, "shape": "square", "ans": false},
    {"color": Colors.blue, "shape": "circle", "ans": true},
  ],
  "Es un cuadrado verde": [
    {"color": Colors.green, "shape": "circle", "ans": false},
    {"color": Colors.green, "shape": "square", "ans": true},
    {"color": Colors.blue, "shape": "circle", "ans": false},
    {"color": Colors.blue, "shape": "square", "ans": false}
  ],
  "No es un circulo azul": [
    {"color": Colors.green, "shape": "circle", "ans": true},
    {"color": Colors.blue, "shape": "square", "ans": true},
    {"color": Colors.blue, "shape": "circle", "ans": false},
  ],
  "Es un circulo azul": [
    {"color": Colors.green, "shape": "circle", "ans": false},
    {"color": Colors.green, "shape": "square", "ans": false},
    {"color": Colors.blue, "shape": "circle", "ans": true},
    {"color": Colors.blue, "shape": "square", "ans": false}
  ],
  "No es un cuadrado azul": [
    {"color": Colors.green, "shape": "circle", "ans": true},
    {"color": Colors.blue, "shape": "square", "ans": false},
    {"color": Colors.blue, "shape": "circle", "ans": true},
  ],
  "Es un cuadrado azul": [
    {"color": Colors.green, "shape": "circle", "ans": false},
    {"color": Colors.green, "shape": "square", "ans": false},
    {"color": Colors.blue, "shape": "circle", "ans": false},
    {"color": Colors.blue, "shape": "square", "ans": true}
  ],
  "No es un circulo rojo": [
    {"color": Colors.red, "shape": "circle", "ans": false},
    {"color": Colors.red, "shape": "square", "ans": true},
    {"color": Colors.black, "shape": "circle", "ans": true},
  ],
  "Es un circulo rojo": [
    {"color": Colors.red, "shape": "circle", "ans": true},
    {"color": Colors.red, "shape": "square", "ans": false},
    {"color": Colors.black, "shape": "circle", "ans": false},
    {"color": Colors.black, "shape": "square", "ans": false}
  ],
  "No es un cuadrado rojo": [
    {"color": Colors.red, "shape": "circle", "ans": true},
    {"color": Colors.red, "shape": "square", "ans": false},
    {"color": Colors.black, "shape": "circle", "ans": true},
  ],
  "Es un cuadrado rojo": [
    {"color": Colors.red, "shape": "circle", "ans": false},
    {"color": Colors.red, "shape": "square", "ans": true},
    {"color": Colors.black, "shape": "circle", "ans": false},
    {"color": Colors.black, "shape": "square", "ans": false}
  ],
  "No es un circulo negro": [
    {"color": Colors.red, "shape": "circle", "ans": true},
    {"color": Colors.black, "shape": "square", "ans": true},
    {"color": Colors.black, "shape": "circle", "ans": false},
  ],
  "Es un circulo negro": [
    {"color": Colors.red, "shape": "circle", "ans": false},
    {"color": Colors.red, "shape": "square", "ans": false},
    {"color": Colors.black, "shape": "circle", "ans": true},
    {"color": Colors.black, "shape": "square", "ans": false}
  ],
  "No es un cuadrado negro": [
    {"color": Colors.red, "shape": "circle", "ans": true},
    {"color": Colors.black, "shape": "square", "ans": false},
    {"color": Colors.black, "shape": "circle", "ans": true},
  ],
  "Es un cuadrado negro": [
    {"color": Colors.red, "shape": "circle", "ans": false},
    {"color": Colors.red, "shape": "square", "ans": false},
    {"color": Colors.black, "shape": "circle", "ans": false},
    {"color": Colors.black, "shape": "square", "ans": true}
  ],
};

class Puzzle3 extends StatefulWidget {
  final Size gameSize;
  static Function initialize;
  final Function gotoMainScreen;

  Puzzle3({Key key, this.gameSize, this.gotoMainScreen}) {
    print('Puzzle 3 constructed');
    if (initialize != null) {
      initialize();
    }
  }

  @override
  _Puzzle3State createState() => _Puzzle3State();
}

class _Puzzle3State extends State<Puzzle3> {
  PuzzleTimer _puzzleTimer;
  String msg;

  List questions;
  List answers;
  int curIndex;
  bool isGameOver;
  String tapScreenMsg;
  String tapScreenMsg1;
  bool isWrongAns;

  bool isWin;
  int retries = 0;

  @override
  void initState() {
    // TODO: implement initState
    print("Init");
    super.initState();
    Puzzle3.initialize = () {
      initialize();
    };
    initialize();
  }

  void generateData() {
    questions = [];
    answers = [];
    Random rand = Random();
    for (int i = 0; i < 6; i++) {
      int index = rand.nextInt(puzzle3Data.length);
      questions.add(puzzle3Data.keys.elementAt(index));
      List allAns = puzzle3Data.values.elementAt(index);
      index = rand.nextInt(allAns.length);
      answers.add(allAns[index]);
    }
  }

  void initialize() {
    print("New data loaded");
    msg = "Toque para comenzar";
    // Set Timer
    isWin = false;
    _puzzleTimer = PuzzleTimer(
      gameDuration: Duration(seconds: 20),
      gameOver: updateGameStatus,
    );

    // Game Data
    generateData();
    curIndex = 0;
    isGameOver = true;
    isWrongAns = false;
  }

  @override
  Widget build(BuildContext context) {
    print("Retries: $retries");
    return Container(
      color: Colors.white.withOpacity(0.7),
      child: Stack(
        children: [
          if (!isGameOver) _puzzleTimer,
          if (!isGameOver)
            Positioned(
              top: widget.gameSize.height * 0.2,
              child: Container(
                width: widget.gameSize.width,
                child: Center(
                    child: Text(
                  questions[curIndex],
                  style: TextStyle(fontSize: 20),
                )),
              ),
            ),
          if (!isGameOver)
            Positioned(
              top: widget.gameSize.height * 0.3,
              child: Container(
                width: widget.gameSize.width,
                child: Center(
                  child: Container(
                    height: widget.gameSize.width * 0.33,
                    width: widget.gameSize.width * 0.33,
                    decoration: BoxDecoration(
                        shape: answers[curIndex]["shape"] == "circle"
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                        border: Border.all(
                            width: 5, color: answers[curIndex]["color"])),
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
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          color: Colors.deepOrangeAccent,
                          child: IconButton(
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (answers[curIndex]["ans"] == true) {
                                updateQue(true);
                              } else {
                                updateQue(false);
                              }
                            },
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.deepOrange, width: 3)),
                    ),
                    SizedBox(
                      width: widget.gameSize.width * 0.30,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          color: Colors.deepOrangeAccent,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (answers[curIndex]["ans"] == false) {
                                updateQue(true);
                              } else {
                                updateQue(false);
                              }
                            },
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.deepOrange, width: 3)),
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
                        'Escoja la opción correcta',
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
                  index: 3,
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
      if (curIndex >= puzzle3MaxQuestion) {
        // TODO: GameOver.
        setState(() {
          curIndex = 0;
          isWrongAns = false;
          isWin = true;
          msg = "Toca para comenzar";
          isGameOver = !isGameOver;
        });
      } else {
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
    generateData();
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
