import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/templates/game_template.dart';
import 'dart:math' as math;

import 'package:fortuna/templates/gamepage.dart';

class CardGame extends StatefulWidget {
  final Function function;

  const CardGame({Key key, this.function}) : super(key: key);

  @override
  _CardGameState createState() => _CardGameState();
}

class _CardGameState extends State<CardGame>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> AnticlockWis;
  Animation<double> Anticlock2;
  double x1 = -0.8, x2 = 0, x3 = 0.8, y1 = 0, y2 = 0, y3 = 0;
  GlobalKey<FlipCardState> key1 = GlobalKey();
  GlobalKey<FlipCardState> key2 = GlobalKey();
  GlobalKey<FlipCardState> key3 = GlobalKey();
  double currentRadius = 0;
  int turn;
  bool isNormal;
  bool isminus;
  int rotationCount = 0;
  bool isFreshGame = true;
  bool isSelected = false;
  int selected = 0;
  bool isRunning = false;
  int win = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    AnticlockWis = Tween<double>(begin: 0, end: 1 * math.pi).animate(controller)
      ..addListener(() {
        calulate(turn);

        setState(() {});
      });
    AnticlockWis
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (rotationCount < 6) {
            rotate();
            rotationCount++;
          } else {
            rotationCount = 0;
            isFreshGame = false;
          }
        }
      });
    Anticlock2 = Tween<double>(begin: 1 * math.pi, end: 2 * math.pi)
        .animate(controller)
          ..addListener(() {});
  }

  void calulate(int turn) {
    switch (turn) {
      case 0:
        {
          if (isNormal) {
            double newx1 = math.cos(Anticlock2.value) * currentRadius;
            double newy1 = math.sin(Anticlock2.value) * currentRadius;
            double newx2 = math.cos(AnticlockWis.value) * currentRadius;
            double newy2 = math.sin(AnticlockWis.value) * currentRadius;
            x1 = newx1;
            x2 = newx2;
            y1 = newy1;
            y2 = newy2;
            if (currentRadius < 0.5) {
              if (isminus) {
                x2 = x2 - currentRadius;
                x1 = x1 - currentRadius;
              } else {
                x2 = x2 + currentRadius;
                x1 = x1 + currentRadius;
              }
            }
            break;
          } else {
            double newx1 = math.cos(AnticlockWis.value) * currentRadius;
            double newy1 = math.sin(AnticlockWis.value) * currentRadius;
            double newx2 = math.cos(Anticlock2.value) * currentRadius;
            double newy2 = math.sin(Anticlock2.value) * currentRadius;
            x1 = newx1;
            x2 = newx2;
            y1 = newy1;
            y2 = newy2;
            if (currentRadius < 0.5) {
              if (isminus) {
                x2 = x2 - currentRadius;
                x1 = x1 - currentRadius;
              } else {
                x2 = x2 + currentRadius;
                x1 = x1 + currentRadius;
              }
            }
            break;
          }
          break;
        }
      case 1:
        {
          if (isNormal) {
            double newx1 = math.cos(Anticlock2.value) * currentRadius;
            double newy1 = math.sin(Anticlock2.value) * currentRadius;
            double newx2 = math.cos(AnticlockWis.value) * currentRadius;
            double newy2 = math.sin(AnticlockWis.value) * currentRadius;
            x1 = newx1;
            x3 = newx2;
            y1 = newy1;
            y3 = newy2;
            if (currentRadius < 0.5) {
              if (isminus) {
                x3 = x3 - currentRadius;
                x1 = x1 - currentRadius;
              } else {
                x3 = x3 + currentRadius;
                x1 = x1 + currentRadius;
              }
            }
            break;
          } else {
            double newx1 = math.cos(AnticlockWis.value) * currentRadius;
            double newy1 = math.sin(AnticlockWis.value) * currentRadius;
            double newx2 = math.cos(Anticlock2.value) * currentRadius;
            double newy2 = math.sin(Anticlock2.value) * currentRadius;
            x1 = newx1;
            x3 = newx2;
            y1 = newy1;
            y3 = newy2;
            if (currentRadius < 0.5) {
              if (isminus) {
                x3 = x3 - currentRadius;
                x1 = x1 - currentRadius;
              } else {
                x3 = x3 + currentRadius;
                x1 = x1 + currentRadius;
              }
            }
            break;
          }
          break;
        }
      case 2:
        {
          if (isNormal) {
            double newx1 = math.cos(Anticlock2.value) * currentRadius;
            double newy1 = math.sin(Anticlock2.value) * currentRadius;
            double newx2 = math.cos(AnticlockWis.value) * currentRadius;
            double newy2 = math.sin(AnticlockWis.value) * currentRadius;
            x2 = newx1;
            x3 = newx2;
            y2 = newy1;
            y3 = newy2;
            if (currentRadius < 0.5) {
              if (isminus) {
                x3 = x3 - currentRadius;
                x2 = x2 - currentRadius;
              } else {
                x3 = x3 + currentRadius;
                x2 = x2 + currentRadius;
              }
            }
            break;
          } else {
            double newx1 = math.cos(AnticlockWis.value) * currentRadius;
            double newy1 = math.sin(AnticlockWis.value) * currentRadius;
            double newx2 = math.cos(Anticlock2.value) * currentRadius;
            double newy2 = math.sin(Anticlock2.value) * currentRadius;
            x2 = newx1;
            x3 = newx2;
            y2 = newy1;
            y3 = newy2;
            if (currentRadius < 0.5) {
              if (isminus) {
                x3 = x3 - currentRadius;
                x2 = x2 - currentRadius;
              } else {
                x3 = x3 + currentRadius;
                x2 = x2 + currentRadius;
              }
            }
            break;
          }
        }
    }
  }

  void rotationAgain() {}

  BoxShadow getBoxShadow(int a) {
    switch (a) {
      case -1:
        return BoxShadow(
          color: Colors.red,
          blurRadius: 25,
          spreadRadius: 15,
        );
      case 0:
        return BoxShadow(
          color: Colors.white,
          blurRadius: 25,
          spreadRadius: 15,
        );
      case 1:
        return BoxShadow(
          color: Colors.green,
          blurRadius: 25,
          spreadRadius: 15,
        );
    }
  }

  void rotate() {
    isRunning = true;

    math.Random random = math.Random();
    turn = random.nextInt(3);
    switch (turn) {
      case 0:
        {
          currentRadius = (x1 - x2).abs() / 2;
          print(currentRadius.toString());
          if (x1 < x2) {
            isNormal = true;
            if (x2 == 0) {
              isminus = true;
            } else if (x1 == 0) {
              isminus = false;
            }
          } else {
            isNormal = false;
            if (x2 == 0) {
              isminus = false;
            } else if (x1 == 0) {
              isminus = true;
            }
          }

          break;
        }
      case 1:
        {
          currentRadius = (x1 - x3).abs() / 2;
          if (x1 < x3) {
            isNormal = true;
            if (x3 == 0) {
              isminus = true;
            } else if (x1 == 0) {
              isminus = false;
            }
          } else {
            isNormal = false;
            if (x3 == 0) {
              isminus = false;
            } else if (x1 == 0) {
              isminus = true;
            }
          }
          break;
        }
      case 2:
        {
          currentRadius = (x2 - x3).abs() / 2;
          if (x2 < x3) {
            isNormal = true;
            if (x2 == 0) {
              isminus = false;
            } else if (x3 == 0) {
              isminus = true;
            }
          } else {
            isNormal = false;
            if (x2 == 0) {
              isminus = true;
            } else if (x3 == 0) {
              isminus = false;
            }
          }
          break;
        }
    }
    controller.forward(from: 0);
  }

  void flipCard() {
    key1.currentState.toggleCard();
    key2.currentState.toggleCard();
    key3.currentState.toggleCard();
    key1.currentState.controller
      ..addStatusListener((status) {
        if (isFreshGame) {
          if (status == AnimationStatus.completed) {
            rotate();
          }
        }
      });
  }

  void setWinScrore(){
    final prefs = Prefs();
    Map data = prefs.data[2];
    data['modules'][0]['total'] = 10;
    data["total"] = data["modules"][1]["total"] + data["modules"][0]["total"];
    prefs.updateScore(2,data);
    print(prefs.totalScore);
    if(mounted) {
      print('finsh');
      GamePage.of(context).finishGame();
      GameTemplate.of(context).trophyIndex = data["total"] > 15
          ? 0
          : data['total'] > 10
              ? 1
              : 2;
    }
  }
  void setlossScroce(){
    final prefs = Prefs();
    Map data = prefs.data[2];
    int counter = data["modules"][0]["counter"];
    if(counter < 3) {
      data["modules"][0]['counter'] = data["modules"][0]['counter'] + 1;
      prefs.updateScore(2,data);
      print(data["modules"][0]['counter']);
      if(data["modules"][0]['counter'] == 3){
        data['modules'][0]['total'] = math.max<int>(data['modules'][0]['total'], 5);
        data["total"] = data["modules"][1]["total"] + data["modules"][0]["total"];
        prefs.updateScore(2,data);
        print(prefs.totalScore);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cardWidth = size.width * 0.2;
    double cardHeight = size.height * 0.15;

    return Align(
      alignment:
          Alignment.lerp(Alignment.topCenter, Alignment.bottomCenter, .15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            "Habilidad",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 40,
          ),
          Card(
            shadowColor: Colors.green,
            elevation: 5,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                boxShadow: [
                  getBoxShadow(win),
                ],
                image: DecorationImage(
                    image: AssetImage(
                      "asset/Module3/carpet.png",
                    ),
                    fit: BoxFit.fill),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        widget.function();
                      },
                      icon: Icon(Icons.cancel_rounded),
                      color: Colors.red,
                      iconSize: 30,
                    ),
                  ),
                  Align(
                      alignment: Alignment(x1, y1),
                      child: FlipCard(
                        flipOnTouch: false,
                        key: key1,
                        front: Container(
                          height: cardHeight,
                          width: cardWidth,
                          child: Image.asset(
                            "asset/Module3/ace.png",
                            fit: BoxFit.fill,
                          ),
                          // color: Colors.yellow,
                        ),
                        back: GestureDetector(
                          onTap: () {
                            if (AnticlockWis.isCompleted && !isSelected) {
                              key1.currentState.toggleCard();
                              key2.currentState.toggleCard();
                              key3.currentState.toggleCard();
                              isSelected = true;
                              selected = 1;
                              isRunning = false;
                              setState(() {
                                setWinScrore();
                                win = 1;
                              });
                            }
                          },
                          child: Container(
                            height: cardHeight,
                            width: cardWidth,
                            child: Image.asset(
                              "asset/Module3/cardback.png",
                              fit: BoxFit.fill,
                            ),
                            // color: Colors.pink,
                          ),
                        ),
                      )),
                  Align(
                      alignment: Alignment(x2, y2),
                      child: FlipCard(
                        flipOnTouch: false,
                        key: key2,
                        front: Container(
                          height: cardHeight,
                          width: cardWidth,
                          child: Image.asset(
                            "asset/Module3/king.png",
                            fit: BoxFit.fill,
                          ),
                          // color: Colors.green,
                        ),
                        back: GestureDetector(
                          onTap: () {
                            if (AnticlockWis.isCompleted && !isSelected) {
                              key1.currentState.toggleCard();
                              key2.currentState.toggleCard();
                              key3.currentState.toggleCard();
                              isSelected = true;
                              selected = 2;
                              isRunning = false;
                              setState(() {
                                setlossScroce();
                                win = -1;
                              });
                            }
                          },
                          child: Container(
                            height: cardHeight,
                            width: cardWidth,
                            // color: Colors.pink,
                            child: Image.asset(
                              "asset/Module3/cardback.png",
                              fit: BoxFit.fill,
                            ),
                            // child: Image.asset("asset/ace.png",fit: BoxFit.fill,),
                          ),
                        ),
                      )),
                  Align(
                      alignment: Alignment(x3, y3),
                      child: FlipCard(
                        flipOnTouch: false,
                        key: key3,
                        front: Container(
                          height: cardHeight,
                          width: cardWidth,
                          child: Image.asset(
                            "asset/Module3/king.png",
                            fit: BoxFit.fill,
                          ),
                          // color: Colors.red,
                        ),
                        back: GestureDetector(
                          onTap: () {
                            if (AnticlockWis.isCompleted && !isSelected) {
                              key1.currentState.toggleCard();
                              key2.currentState.toggleCard();
                              key3.currentState.toggleCard();
                              isSelected = true;
                              selected = 3;
                              isRunning = false;
                              setState(() {
                                win = -1;
                                setlossScroce();
                              });
                            }
                          },
                          child: Container(
                            height: cardHeight,
                            width: cardWidth,
                            // color: Colors.pink,
                            child: Image.asset(
                              "asset/Module3/cardback.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.03),
                      child: GestureDetector(
                        onTap: () {
                          if (!isRunning) {
                            isFreshGame = true;
                            win = 0;
                            isSelected = false;
                            selected = 0;
                            // rotate();
                            flipCard();
                          }
                        },
                        child: AnimatedButton(isRunning: isRunning,),
                      ),
                    ),
                 )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final bool isRunning;

  AnimatedButton({Key key, this.isRunning}) : super(key: key);
  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: Next Button Glow
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 4.0).animate(_animationController)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.stop();
    _animation = null;
    _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.height * 0.035,
      height: size.height * 0.035,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Color(0xff9aabc8),
                blurRadius: _animation.value,
                spreadRadius: _animation.value)
          ]),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff9aabc8),),
        child: Center(
          child: Icon(
            widget.isRunning
                ? Icons.pause_circle_filled
                : Icons.play_circle_fill,
            size: size.height * 0.035,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
