import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/templates/game_template.dart';
import 'package:fortuna/templates/gamepage.dart';

import 'Model/Box1.dart';

class oneCollum {
  List<FramerImage> farmers;
  int flower = -1;
  String flowerUrl;
  int ksa = 9;

  oneCollum({this.farmers, this.flowerUrl});

  String ksaUrl = "asset/Flowers/Flower6.png";

  void increament(bool iskas) {
    if (flower > ksa) {
      print("greate   ..........");
    }
    print(flower.toString());
    if (flower != -1 && (flower + 1) != 9) {
      flower++;
      farmers[flower].image = flowerUrl;
      if (flower == ksa) {
        ksa++;
      }
      if (iskas && (ksa - 1) != flower) {
        ksa--;
        farmers[ksa].image = ksaUrl;
      }
    } else {
      if (iskas && (ksa - 1) != 0) {
        ksa--;
        farmers[ksa].image = ksaUrl;
      }
    }
  }
}

class gameModel {
  bool isAvailabel = true;
  int activation = 0;
  int inactiveFarmer = 5;
  bool isSelectingOther = false;
  AnimationController controller;
  List<oneCollum> _col = List();

  gameModel({this.controller}) {
    for (int i = 0; i < 6; i++) {
      List<FramerImage> _sin = List();
      for (int j = 0; j < 10; j++) {
        if (j == 0) {
          _sin.add(FramerImage(
              image: "asset/Framer/Framer${i}.png", isActive: false));
        } else if (j == 9) {
          _sin.add(FramerImage(image: "asset/Framer/Framer6.png"));
        } else {
          if (i % 2 == 0) {
            if (j % 2 == 0)
              _sin.add(GameBox(backgroundiamge: "asset/Framer/back1.png"));
            else
              _sin.add(GameBox(backgroundiamge: "asset/Framer/back2.png"));
          } else {
            if (j % 2 == 0)
              _sin.add(GameBox(backgroundiamge: "asset/Framer/back2.png"));
            else
              _sin.add(GameBox(backgroundiamge: "asset/Framer/back1.png"));
          }
        }
      }
      _col.add(
          oneCollum(farmers: _sin, flowerUrl: "asset/Flowers/Flower$i.png"));
    }
    Random random = Random();
    int a = random.nextInt(6);
    _col[a].flower = 0;
  }

  void calIsAvailable() {
    for (oneCollum o in _col) {
      if (o.flower + 1 != o.ksa) {
        isAvailabel = true;
        return;
      }
    }
    isAvailabel = false;
  }

  void nextStep() {
    calIsAvailable();
    Random random = Random();
    int n = random.nextInt(6);
    while ((_col[n].flower + 1) == _col[n].ksa || _col[n].ksa == 1) {
      if (!isAvailabel) {
        break;
      }
      n = random.nextInt(6);
    }
    for (int i = 0; i < _col.length; i++) {
      if (i == n && isAvailabel) {
        _col[i].increament(true);
      } else {
        _col[i].increament(false);
      }
    }
    print("//////////////////////////");
  }

  void ActiveFarmer(int index) {
    _col[index].farmers[0].isActive = true;
    _col[index].flower = 0;
    inactiveFarmer--;
    activation--;
  }

  void setNotFor(int index) {
    _col[index].farmers[0].isFour = false;
    // print("beforeeeee" + _col[index].flower.toString());
    _col[index].flower = _col[index].flower - 4;
    // print("clicked" +index.toString() +"  //// "+_col[index].flower.toString());
    for (int i = _col[index].flower + 1; i < _col[index].flower + 5; i++) {
      _col[index].farmers[i].image = null;
    }
    activation++;
  }

  int checkStatus() {
    for (int i = 0; i < _col.length; i++) {
      if (_col[i].ksa == 1) {
        return -1;
      }
    }
    for (int i = 0; i < _col.length; i++) {
      print("in CheckStatus" + _col[i].ksa.toString());
      if (_col[i].flower != 8) {
        return 0;
      }
    }
    return 1;
  }

  Widget getLayout(Function set) {
    List<FramerImage> _list = List(60);
    for (int i = 0; i < _col.length; i++) {
      if (_col[i].flower > -1) {
        _col[i].farmers[0].isActive = true;
      }
      final _s = _col[i].farmers;
      bool isFour = _col[i].flower > 3;
      for (int j = 0; j < _s.length; j++) {
        int pos = i + (j * 6);
        _list[pos] = _s[j];
        // _list.insert(pos,_s[j]);
      }
      if (isFour) {
        _col[i].farmers[0].isFour = true;
      } else {
        _col[i].farmers[0].isFour = false;
      }
    }
    getDecoration(FramerImage image) {
      GameBox g;
      if (image is GameBox) {
        g = image as GameBox;
      }
      if (g != null) {
        return BoxDecoration(
            image: DecorationImage(
          image: AssetImage(g.backgroundiamge),
          fit: BoxFit.fill,
        ));
      }
      if (image.isFour) {
        return BoxDecoration(
          border: Border.all(color: Colors.green),
        );
      }
      return BoxDecoration();
    }

    return GridView.builder(
        itemCount: 10 * 6,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemBuilder: (context, index) {
          GameBox g;
          if (_list[index] is GameBox) {
            g = _list[index] as GameBox;
          }
          return GestureDetector(
            onTap: () {
              if (inactiveFarmer != 0) {
                if (activation != 0 && _col[index].flower == -1) {
                  ActiveFarmer(index);

                  set();
                }
                if (_list[index].isFour) {
                  setNotFor(index);

                  set();
                }
              }
            },
            child: Opacity(
              opacity: (_list[index].isActive) ? 1 : .2,
              child: Container(
                decoration: getDecoration(_list[index]),
                child: g == null
                    ? (_list[index].image != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              _list[index].image,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Container())
                    : OneBox(
                        image: _list[index].image ?? "s",
                      ),
                // child: OneBox(image: _list[index].image ?? "s"),
              ),
            ),
          );
        });
  }
}

class Module5 extends StatefulWidget {
  @override
  _Module5State createState() => _Module5State();
}

class _Module5State extends State<Module5> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  gameModel model;

  double opacity = 0.7;

  String result = "Toque para jugar";

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Calculate();
              if (model.checkStatus() == 1) {
                print("winnnnnnnn");
                _controller.stop();
                opacity = 0.7;
                result = "¡Felicidades!\nToque para repetir";
                final prefs = Prefs();
                Map data = prefs.data[4];
                data['total'] = 20;
                prefs.updateScore(4, data);
                if (mounted) {
                  print('finsh');
                  GamePage.of(context).finishGame();
                  GameTemplate.of(context).trophyIndex = 0;
                }
                print('Total Score: ${Prefs().totalScore}');
                // return Text("winn");
              } else if (model.checkStatus() == -1) {
                print("game over");
                result = "Juego terminado\nToca para volver a intentarlo";
                _controller.stop();

                opacity = 0.7;
              } else {
                _controller.forward(from: 0);
              }
              setState(() {});
            }
          });
    model = gameModel(controller: _controller);
    // _controller.forward(from:0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void Calculate() {
    model.nextStep();
  }

  Widget getLayout() {
    return model.getLayout(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: getLayout()),
        ),
        if (opacity != 0)
          Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTap: () {
                opacity = 0;
                model = gameModel(controller: _controller);
                _controller.forward(from: 0);
                setState(() {});
              },
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
        if (opacity != 0)
          GestureDetector(
            onTap: () {
              opacity = 0;
              model = gameModel(controller: _controller);
              _controller.forward(from: 0);
              setState(() {});
            },
            child: Center(
              child: Text(
                result,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class OneBox extends ImplicitlyAnimatedWidget {
  String image;

  OneBox({this.image}) : super(duration: Duration(milliseconds: 200));

  @override
  _OneBoxState createState() => _OneBoxState();
}

class _OneBoxState extends AnimatedWidgetBaseState<OneBox> {
  CustomOpacity opacity;
  StringTween stringTween;

  @override
  Widget build(BuildContext context) {
    String s = stringTween.evaluate(animation);
    return Opacity(
      opacity: opacity.evaluate(animation) ?? 1,
      child: s == "s"
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                s,
                fit: BoxFit.contain,
              ),
            ),
    );
  }

  @override
  void forEachTween(visitor) {
    opacity = visitor(
      opacity,
      1.0,
      (val) => CustomOpacity(),
    );
    stringTween = visitor(
      stringTween,
      widget.image,
      (vali) => StringTween(begin: vali),
    );
  }
}

class CustomOpacity extends Tween<double> {
  CustomOpacity() : super();

  double lerp(double t) {
    if (t < 0.5) {
      return (1 - t * 2);
    } else {
      return (t - 0.5) * 2;
    }
  }
}

class StringTween extends Tween<String> {
  StringTween({String begin, String end}) : super(begin: begin, end: end);

  String lerp(double t) {
    if (t < 0.5) {
      return begin;
    } else {
      return end;
    }
  }
}
