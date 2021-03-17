import 'package:flutter/material.dart';
import 'package:fortuna/skillz_game/puzzle_win.dart';
import 'package:fortuna/skillz_game/puzzle5_data.dart';
import 'package:fortuna/skillz_game/puzzle5_model.dart';
import 'package:fortuna/skillz_game/puzzle_timer.dart';

class Puzzle5 extends StatefulWidget {
  final Size gameSize;
  static Function initialize;
  final Function gotoMainScreen;

  Puzzle5({Key key, this.gameSize, this.gotoMainScreen}) {
    print('Puzzle 5 constructed');
    if (initialize != null) {
      initialize();
    }
  }

  @override
  _Puzzle5State createState() => _Puzzle5State();
}

class _Puzzle5State extends State<Puzzle5> {
  PuzzleTimer _puzzleTimer;
  String msg;

  List<TileModel> gridViewTiles = new List<TileModel>();
  List<TileModel> questionPairs = new List<TileModel>();
  bool isGameOver;

  int retries = 0;

  @override
  void initState() {
    print("Init");
    super.initState();
    Puzzle5.initialize = () {
      initialize();
    };
    initialize();
  }

  void initialize() {
    // Set Timer
    _puzzleTimer = PuzzleTimer(
      gameDuration: Duration(seconds: 65),
      gameOver: updateGameStatus,
    );

    // Game Data
    msg = "Toque para comenzar";
    points = 0;
    isGameOver = true;
    myPairs = getPairs();
    myPairs.shuffle();
    gridViewTiles = myPairs;
  }

  @override
  Widget build(BuildContext context) {
    print("Retries: $retries");
    if(points >= 800)
      _puzzleTimer.timer.cancel();
    return Container(
      color: Colors.white.withOpacity((!isGameOver && points < 800) ? 0.7 : 0),
      child: Stack(
        children: [
          if(!isGameOver)
            _puzzleTimer,
          if(!isGameOver && points < 800)
            Positioned(
            top: widget.gameSize.height * 0.1,
            child: Container(
              width: widget.gameSize.width,
              height: widget.gameSize.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tile(
                        imagePathUrl: gridViewTiles[0].getImageAssetPath(),
                        tileIndex: 0,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[1].getImageAssetPath(),
                        tileIndex: 1,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[2].getImageAssetPath(),
                        tileIndex: 2,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[3].getImageAssetPath(),
                        tileIndex: 3,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tile(
                        imagePathUrl: gridViewTiles[4].getImageAssetPath(),
                        tileIndex: 4,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[5].getImageAssetPath(),
                        tileIndex: 5,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[6].getImageAssetPath(),
                        tileIndex: 6,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[7].getImageAssetPath(),
                        tileIndex: 7,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tile(
                        imagePathUrl: gridViewTiles[8].getImageAssetPath(),
                        tileIndex: 8,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[9].getImageAssetPath(),
                        tileIndex: 9,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[10].getImageAssetPath(),
                        tileIndex: 10,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[11].getImageAssetPath(),
                        tileIndex: 11,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tile(
                        imagePathUrl: gridViewTiles[12].getImageAssetPath(),
                        tileIndex: 12,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[13].getImageAssetPath(),
                        tileIndex: 13,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[14].getImageAssetPath(),
                        tileIndex: 14,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                      Tile(
                        imagePathUrl: gridViewTiles[15].getImageAssetPath(),
                        tileIndex: 15,
                        parent: this,
                        gameSize: widget.gameSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (points >= 800)
            Positioned(
              child: Container(
                color: Colors.white.withOpacity(0.5),
                width: widget.gameSize.width,
                height: widget.gameSize.height,
                child: PuzzleWin(
                  gameSize: widget.gameSize,
                  index: 5,
                  retries: retries,
                  gotoMainScreen: widget.gotoMainScreen,
                ),
              ),
            ),
          if (isGameOver)
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
                      Center(child: Text(msg, textAlign: TextAlign.center, style: textStyle,)),
                      Center(child: Text('Memorice y empareje', textAlign: TextAlign.center, style: textStyle,)),
                    ]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void updateGameStatus({bool isTime: true}) {
    if(isTime)
      retries++;
    setState(() {
      msg = "Se acabó el tiempo.\nToque para reintentar.";
      isGameOver = !isGameOver;
      myPairs = getPairs();
      myPairs.shuffle();
      gridViewTiles = myPairs;
      points = 0;
      if(isGameOver == false) {
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              print("5 seconds done");
              questionPairs = getQuestionPairs();
              gridViewTiles = questionPairs;
              selected = false;
            });
          }
        });
      }
    });
  }
}

class Tile extends StatefulWidget {
  String imagePathUrl;
  int tileIndex;
  _Puzzle5State parent;
  final Size gameSize;

  Tile({this.imagePathUrl, this.tileIndex, this.parent, this.gameSize});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          setState(() {
            myPairs[widget.tileIndex].setIsSelected(true);
          });
          if (selectedTile != "") {
            if (selectedTile == myPairs[widget.tileIndex].getImageAssetPath()) {
              points = points + 100;
              TileModel tileModel = new TileModel();
              selected = true;
              Future.delayed(const Duration(milliseconds: 500), () {
                tileModel.setImageAssetPath("");
                myPairs[widget.tileIndex] = tileModel;
                myPairs[selectedIndex] = tileModel;
                this.widget.parent.setState(() {});
                setState(() {
                  selected = false;
                });
                selectedTile = "";
              });
            } else {
              selected = true;
              Future.delayed(const Duration(milliseconds: 500), () {
                this.widget.parent.setState(() {
                  myPairs[widget.tileIndex].setIsSelected(false);
                  myPairs[selectedIndex].setIsSelected(false);
                });
                setState(() {
                  selected = false;
                });
              });

              selectedTile = "";
            }
          } else {
            setState(() {
              selectedTile = myPairs[widget.tileIndex].getImageAssetPath();
              selectedIndex = widget.tileIndex;
            });
          }
        }
      },
      child: Container(
        height: widget.gameSize.height * 0.1,
        width: widget.gameSize.width * 0.20,
        margin: EdgeInsets.all(5),
        child: myPairs[widget.tileIndex].getImageAssetPath() != ""
            ? Image.asset(
                myPairs[widget.tileIndex].getIsSelected()
                    ? myPairs[widget.tileIndex].getImageAssetPath()
                    : widget.imagePathUrl,
                fit: BoxFit.contain,
              )
            : Image.asset(
                "asset/image/correct.png",
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}


final textStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);