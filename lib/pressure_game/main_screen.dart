import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/pressure_game/complicated_methods.dart';
import 'package:fortuna/pressure_game/fruits.dart';
import 'package:fortuna/pressure_game/pressure.dart';

// ignore: must_be_immutable
class PressureGame extends StatefulWidget {
  final Size size;
  Size gameSize;
  GameStatus gameStatus = GameStatus.START;
  DropFruits dropFruits;
  Pressure pressure;
  AnimationController animationController;

  PressureGame({Key key, this.size}) {
    gameSize = Size(this.size.width * 0.9, this.size.height * 0.8);
  }

  @override
  _PressureGameState createState() => _PressureGameState();
}

class _PressureGameState extends State<PressureGame> {
  @override
  void initState() {
    // TODO: implement initState
    widget.dropFruits = DropFruits(
      gameSize: widget.gameSize,
      size: widget.size,
    );
    widget.pressure = Pressure(
      gameSize: widget.gameSize,
      dropFruits: widget.dropFruits,
      gameOver: gameOver,
    );
  }

  @override
  Widget build(BuildContext context) {
    return getGameState();
  }

  Widget getGameState() {
//    DropFruits dropFruits = DropFruits(
//      gameSize: widget.gameSize,
//      size: widget.size,
//    );
//    Pressure pressure = Pressure(
//      gameSize: widget.gameSize,
//      dropFruits: dropFruits,
//      gameOver: gameOver,
//    );
    return widget.gameStatus == GameStatus.PLAYING
        ? Center(
            child: Container(
              height: widget.gameSize.height,
              width: widget.gameSize.width,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(-1 / 3, -1),
                    child: Container(
                      width: 1,
                      height: widget.gameSize.height * 0.55,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Align(
                    alignment: Alignment(1 / 3, -1),
                    child: Container(
                      width: 1,
                      height: widget.gameSize.height * 0.55,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  widget.dropFruits,
                  Positioned(
                    top: widget.gameSize.height * 0.55,
                    child: Container(
                      width: widget.gameSize.width,
                      height: widget.gameSize.height / 100,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                    ),
                  ),
                  Positioned(
                    top: widget.gameSize.height * 0.60,
                    child: Container(
                      width: widget.gameSize.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: widget.gameSize.height * 0.20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  "asset/image/pressure_coocker.png",
                                  width: widget.gameSize.width / 4,
                                  fit: BoxFit.contain,
                                ),
                                Image.asset(
                                  "asset/image/fire1.png",
                                  width: widget.gameSize.width / 12,
                                  fit: BoxFit.contain,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: widget.gameSize.height * 0.20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  "asset/image/pressure_coocker.png",
                                  width: widget.gameSize.width / 4,
                                  fit: BoxFit.contain,
                                ),
                                Image.asset(
                                  "asset/image/fire2.png",
                                  width: widget.gameSize.width / 12,
                                  fit: BoxFit.contain,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: widget.gameSize.height * 0.20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  "asset/image/pressure_coocker.png",
                                  width: widget.gameSize.width / 4,
                                  fit: BoxFit.contain,
                                ),
                                Image.asset(
                                  "asset/image/fire3.png",
                                  width: widget.gameSize.width / 12,
                                  fit: BoxFit.contain,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: widget.gameSize.height * 0.8,
                    child: widget.pressure,
                  ),
                ],
              ),
            ),
          )
        : Stack(
            children: [
              Center(
                child: Container(
                  height: widget.gameSize.height,
                  width: widget.gameSize.width,
                  child: Stack(
                    children: [
                      Positioned(
                        top: widget.gameSize.height * 0.55,
                        child: Container(
                          width: widget.gameSize.width,
                          height: widget.gameSize.height / 100,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            border: Border.all(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                        ),
                      ),
                      Positioned(
                        top: widget.gameSize.height * 0.60,
                        child: Container(
                          width: widget.gameSize.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: widget.gameSize.height * 0.20,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                      "asset/image/pressure_coocker.png",
                                      width: widget.gameSize.width / 4,
                                      fit: BoxFit.contain,
                                    ),
                                    Image.asset(
                                      "asset/image/fire1.png",
                                      width: widget.gameSize.width / 12,
                                      fit: BoxFit.contain,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: widget.gameSize.height * 0.20,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                      "asset/image/pressure_coocker.png",
                                      width: widget.gameSize.width / 4,
                                      fit: BoxFit.contain,
                                    ),
                                    Image.asset(
                                      "asset/image/fire2.png",
                                      width: widget.gameSize.width / 12,
                                      fit: BoxFit.contain,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: widget.gameSize.height * 0.20,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                      "asset/image/pressure_coocker.png",
                                      width: widget.gameSize.width / 4,
                                      fit: BoxFit.contain,
                                    ),
                                    Image.asset(
                                      "asset/image/fire3.png",
                                      width: widget.gameSize.width / 12,
                                      fit: BoxFit.contain,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: widget.gameSize.height * 0.8,
                        child: widget.pressure,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: widget.size.width,
                  height: widget.size.height,
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      widget.gameStatus == GameStatus.START ? "Tap To Start" : "Tap To Retry",
                    ),
                  ),
                ),
                onTap: widget.gameStatus == GameStatus.START ? onTapStart : onTapRetry,
              ),
            ],
          );
  }

  void gameOver() {
    ComplicatedFunctions.myFunction();
    setState(() {
      widget.gameStatus = GameStatus.OVER;
    });
  }

  void onTapStart() {
    setState(() {
      widget.gameStatus = GameStatus.PLAYING;
    });
  }

  void onTapRetry() {
    setState(() {
      widget.gameStatus = GameStatus.PLAYING;
      DropFruits.fruitMap.clear();
      widget.dropFruits.count = 0;
      widget.pressure.scoreA = 0;
      widget.pressure.scoreB = 0;
      widget.pressure.scoreC = 0;
    });
  }
}

enum GameStatus { START, PLAYING, OVER }
