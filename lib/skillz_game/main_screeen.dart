import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/skillz_game/puzzle1.dart';
import 'package:fortuna/skillz_game/puzzle2.dart';
import 'package:fortuna/skillz_game/puzzle3.dart';
import 'package:fortuna/skillz_game/puzzle4.dart';
import 'package:fortuna/skillz_game/puzzle5.dart';
import 'package:fortuna/skillz_game/puzzle6.dart';
import 'package:fortuna/templates/game_template.dart';
import 'package:fortuna/templates/gamepage.dart';

class PuzzleGame extends StatefulWidget {
  final Size size;
  Size gameSize;

  PuzzleGame({Key key, this.size}) : super(key: key) {
    gameSize = Size(size.width * 0.8, size.height * 0.7);
  }

  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  bool isHomeScreen = true;
  int curPuzzle = 0;
  int solvedPuzzle;

  @override
  Widget build(BuildContext context) {
    solvedPuzzle = Prefs().data[7]["solvedGame"];
    return Positioned(
      top: 0,
      left: widget.gameSize.width * 0.1,
      child: Container(
        width: widget.gameSize.width,
        height: widget.gameSize.height,
        child: isHomeScreen
            ? getHomeScreen()
            : PuzzleScreen(
                gameSize: widget.gameSize,
                returnToHome: updateScreen,
                puzzleNum: curPuzzle,
              ),
      ),
    );
  }

  Widget getHomeScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PuzzleButton(
              gameSize: widget.gameSize,
              i: 1,
              solvedPuzzle: solvedPuzzle,
              onPressed: () {
                onPuzzleSelect(1);
              },
            ),
            PuzzleButton(
              gameSize: widget.gameSize,
              i: 2,
              solvedPuzzle: solvedPuzzle,
              onPressed: () {
                onPuzzleSelect(2);
              },
            ),
            PuzzleButton(
              gameSize: widget.gameSize,
              i: 3,
              solvedPuzzle: solvedPuzzle,
              onPressed: () {
                onPuzzleSelect(3);
              },
            ),
          ],
        ),
        SizedBox(
          height: widget.gameSize.height * 0.1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PuzzleButton(
              gameSize: widget.gameSize,
              i: 4,
              solvedPuzzle: solvedPuzzle,
              onPressed: () {
                onPuzzleSelect(4);
              },
            ),
            PuzzleButton(
              gameSize: widget.gameSize,
              i: 5,
              solvedPuzzle: solvedPuzzle,
              onPressed: () {
                onPuzzleSelect(5);
              },
            ),
            PuzzleButton(
              gameSize: widget.gameSize,
              i: 6,
              solvedPuzzle: solvedPuzzle,
              onPressed: () {
                onPuzzleSelect(6);
              },
            ),
          ],
        ),
      ],
    );
  }

  void onPuzzleSelect(int i) {
    if (i >= 1 && i <= solvedPuzzle) {
      setState(() {
        curPuzzle = i;
        isHomeScreen = false;
      });
    }
  }

  void updateScreen() {
    if (curPuzzle == 6) {
      int solved = Prefs().data[7]["solvedGame"];
      int total = Prefs().data[7]['total'];
      if (solved > 6) {
        isHomeScreen = true;
        GameTemplate.of(context).trophyIndex = total >= 30
            ? 0
            : total >= 27
                ? 1
                : 2;
        GamePage.of(context).finishGame();
      }
    }
    setState(() {
      isHomeScreen = true;
    });
  }
}

class PuzzleButton extends StatefulWidget {
  final int i;
  final int solvedPuzzle;
  final Size gameSize;
  final Function onPressed;

  PuzzleButton(
      {Key key, this.i, this.solvedPuzzle, this.gameSize, this.onPressed})
      : super(key: key);

  @override
  _PuzzleButtonState createState() => _PuzzleButtonState();
}

class _PuzzleButtonState extends State<PuzzleButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: Next Button Glow
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 5.0).animate(_animationController)
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
    _animationController = null;
    _animation = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: (widget.i > widget.solvedPuzzle)
                          ? 0
                          : _animation.value,
                      spreadRadius: (widget.i > widget.solvedPuzzle)
                          ? 0
                          : _animation.value)
                ],
                color: Colors.orange.withOpacity(0.75),
                border: Border.all(width: 2),
                borderRadius: BorderRadius.all(
                    Radius.circular(widget.gameSize.width / 20))),
            width: widget.gameSize.width * 0.25,
            height: widget.gameSize.width * 0.25,
            child: Center(
              child: Text(
                "${widget.i}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          if (widget.i > widget.solvedPuzzle)
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.all(
                      Radius.circular(widget.gameSize.width / 20))),
              width: widget.gameSize.width * 0.25,
              height: widget.gameSize.width * 0.25,
            )
        ],
      ),
    );
  }
}

class PuzzleScreen extends StatefulWidget {
  final Size gameSize;
  final Function returnToHome;
  final int puzzleNum;

  PuzzleScreen({Key key, this.gameSize, this.returnToHome, this.puzzleNum})
      : super(key: key);

  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  Widget puzzle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createPuzzle();
  }

  void createPuzzle() {
    if (widget.puzzleNum == 1) {
      puzzle = Puzzle1(
        gameSize: widget.gameSize,
        gotoMainScreen: widget.returnToHome,
      );
    } else if (widget.puzzleNum == 2) {
      puzzle = Puzzle2(
        gameSize: widget.gameSize,
        gotoMainScreen: widget.returnToHome,
      );
    } else if (widget.puzzleNum == 3) {
      puzzle = Puzzle3(
        gameSize: widget.gameSize,
        gotoMainScreen: widget.returnToHome,
      );
    } else if (widget.puzzleNum == 4) {
      puzzle = Puzzle4(
        gameSize: widget.gameSize,
        gotoMainScreen: widget.returnToHome,
      );
    } else if (widget.puzzleNum == 5) {
      puzzle = Puzzle5(
        gameSize: widget.gameSize,
        gotoMainScreen: widget.returnToHome,
      );
    } else if (widget.puzzleNum == 6) {
      puzzle = Puzzle6(
        gameSize: widget.gameSize,
        gotoMainScreen: widget.returnToHome,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("puzzle");
    createPuzzle();
    return Stack(
      children: [
        Positioned(
          top: 0,
          child: Container(
            width: widget.gameSize.width,
            height: widget.gameSize.height * 0.85,
            child: puzzle,
          ),
        ),
        Positioned(
          top: widget.gameSize.height * 0.87,
          child: Container(
            width: widget.gameSize.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      color: Colors.black54,
                      child: IconButton(
                        icon: Icon(
                          Icons.replay,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            print("Replay");
                          });
                        },
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3)),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      color: Colors.black54,
                      child: IconButton(
                        icon: Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          widget.returnToHome();
                        },
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3)),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
