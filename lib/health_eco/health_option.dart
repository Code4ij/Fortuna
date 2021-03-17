import 'package:flutter/material.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/templates/gamepage.dart';
import 'game.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HealthOption extends StatefulWidget {
  final int index;

  const HealthOption({Key key, this.index}) : super(key: key);

  @override
  _HealthOptionState createState() => _HealthOptionState();
}

class _HealthOptionState extends State<HealthOption> {
  final prefs = Prefs();
  Map data;

  @override
  void initState() {
    // TODO: implement initState
    data = prefs.data[widget.index];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleOption(context, size, 1, 'game1Score'),
            Padding(
              padding: EdgeInsets.only(
                  bottom: size.height * 0.05, top: size.height * 0.0125),
              child: Container(
                width: size.width / 3,
                child: AutoSizeText(
                  'Pague usted mismo primero',
                  textAlign: TextAlign.center,
                  minFontSize: (size.height * 0.0218).roundToDouble(),
                ),
              ),
            ),
            CircleOption(context, size, 2, 'game2Score'),
            Padding(
              padding: EdgeInsets.all(size.width * 0.025),
              child: Container(
                width: size.width / 3,
                child: AutoSizeText(
                  'Pague usted mismo primero',
                  textAlign: TextAlign.center,
                  minFontSize: (size.height * 0.0218).roundToDouble(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CircleOption(BuildContext context, Size size, int index, String key) {
    return InkWell(
      // onTap: () => setGame(index, context),
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Game(
                index: index,
                moduleIndex: widget.index,
              );
            }).then((value) {
          level(context).then((value) {
            setState(() {
              data = prefs.data[widget.index];
            });
          });
        });
      },
      child: Container(
        width: size.width / 5,
        height: size.height / 10,
        child: Stack(children: [
          Container(
            width: size.width / 5,
            height: size.height / 10,
            decoration: BoxDecoration(
                color: Color(0xff17467A),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 6)),
          ),
          Align(
            child: data[key] != 0
                ? Image.asset(
                    data[key] > 0 && data[key] <= 4
                        ? 'asset/image/platinum.png'
                        : data[key] <= 7
                            ? 'asset/image/gold.png'
                            : 'asset/image/diamond.png',
                    width: size.width * 0.0694,
                    height: size.height * 0.039,
                    fit: BoxFit.contain,
                  )
                : Container(),
          )
        ]),
      ),
    );
  }

  void setGame(i, context) {}

  Future<bool> level(context) {
    GamePage.of(context).finishGame();
    Size size = MediaQuery.of(context).size;
    return showDialog(
          context: context,
          builder: (context) => Container(
            height: size.height * 0.5,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  bottom: size.height * 0.225,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: 1,
                      child: Image.asset(
                        'asset/image/empty_level.png',
                        height: size.height * 0.5,
                        fit: BoxFit.contain,
                        width: size.width * 0.5,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: size.height * 0.225,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: data['total'] / 20,
                      child: Image.asset(
                        'asset/image/full_level.png',
                        height: size.height * 0.5,
                        fit: BoxFit.contain,
                        width: size.width * 0.5,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.lerp(
                      Alignment.center, Alignment.bottomCenter, 0.7),
                  child: ButtonTheme(
                    minWidth: size.width * 0.222,
                    height: size.height * 0.046,
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.03),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.028),
                          side: BorderSide(color: Colors.red),
                        ),
                        color: Colors.redAccent,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: AutoSizeText(
                          "Ok",
                          minFontSize:
                              (size.height * 0.0218).round().toDouble(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ) ??
        false;
  }
}
