import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/health_eco/tile.dart';
import 'package:fortuna/common/data.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fortuna/templates/game_template.dart';

class Game extends StatefulWidget {

  final int index;
  final int moduleIndex;

  const Game({Key key, @required this.index, @required this.moduleIndex})
      : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<Item> _data;
  final prefs = Prefs();
  Map scoreData;

  @override
  void initState() {
    scoreData = prefs.data[widget.moduleIndex];
    _data = generateItems(widget.index == 1 ? game1Data : game2Data,
        widget.index == 1 ? scoreData['game1'] : scoreData['game2']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Dialog(
      insetPadding: EdgeInsets.only(left: size.width * 0.05,
          right: size.width * 0.05,
          top: size.height * 0.1171,
          bottom: size.height * 0.0625),
      backgroundColor: Color.lerp(Colors.white, Colors.transparent, .5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: size.width * 0.0111,
            right: size.width * 0.0111,
            top: size.height * 0.0117,
            bottom: size.height * 0.0195),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Tiles(data: _data,
                scoreData: widget.index == 1
                    ? scoreData['game1']
                    : scoreData['game2'],),
              ButtonTheme(
                minWidth: size.width * 0.3,
                height: size.height * 0.046,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.03),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(size.height * 0.028),
                      side: BorderSide(color: Colors.red),
                    ),
                    color: Colors.redAccent,
                    onPressed: () {
                      int score = 0;
                      if (widget.index == 1) {
                        _data.forEach((Item i) {
                          if (i.isChecked == 1 || i.isChecked == 2)
                            score += 1;
                          if (i.isChecked == 1)
                            scoreData["game1"][i.index.toString()] = 2;
                        });
                        scoreData['game1Score'] = score;
                      } else {
                        _data.forEach((Item i) {
                          if (i.isChecked == 1 || i.isChecked == 2)
                            score += game2Data[i.index]['score'];
                          if (i.isChecked == 1)
                            scoreData["game2"][i.index.toString()] = 2;
                        });
                        scoreData['game2Score'] = score;
                      }
                      scoreData['total'] =
                          scoreData['game1Score'] + scoreData['game2Score'];
                      prefs.updateScore(widget.index, scoreData);
                      Navigator.pop(context);
                    },
                    child: AutoSizeText(
                      "Submit",
                      minFontSize: (size.height * 0.0218).round().toDouble(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


