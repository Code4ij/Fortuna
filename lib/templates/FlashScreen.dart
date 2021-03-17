import 'package:flutter/material.dart';
import 'package:fortuna/templates/clipper/clipper1.dart';

import 'clipper/clipper2.dart';
import 'clipper/clipper3.dart';
import 'clipper/clipper4.dart';

class FlashScreen extends StatefulWidget {
  final Function timeOver;

  FlashScreen({Key key, this.timeOver}) : super(key: key);

  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  AnimationController _controller2;
  AnimationController _controller3;
  AnimationController _controller4;

  Animation _animation1;
  Animation _animation2;
  Animation _animation3;
  Animation _animation4;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        duration: Duration(milliseconds: 2100), vsync: this);

    _controller2 = AnimationController(
      duration: Duration(milliseconds: 1600),
      vsync: this,
    );

    _controller3 = AnimationController(
      duration: Duration(milliseconds: 1900),
      vsync: this,
    );

    _controller4 = AnimationController(
      duration: Duration(milliseconds: 1600),
      vsync: this,
    );
    _animation1 = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(curve: Curves.linear, parent: _controller1))
          ..addListener(() {
            setState(() {});
          });
    _animation2 = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(curve: Curves.linear, parent: _controller2))
          ..addListener(() {
            setState(() {});
          });
    _animation3 = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(curve: Curves.linear, parent: _controller3))
          ..addListener(() {
            setState(() {});
          });
    _animation4 = Tween<double>(begin: 0.5, end: 0)
        .animate(CurvedAnimation(curve: Curves.linear, parent: _controller4))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Future.delayed(Duration(seconds: 1), () {
                _controller1.duration = Duration(milliseconds: 1500);
                _controller1.reverse();
                _controller2.reverse();
                _controller3.reverse();
                _controller4.duration = Duration(milliseconds: 2600);
                _controller4.reverse();
              });
            }
          });
    _controller1.forward();
    _controller2.forward();
    _controller3.forward();
    _controller4.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // 3
        ClipPath(
          clipper:
              Clipper1(Size(size.width, size.height), 0.45, _animation1.value),
          child: Container(
            color: Color(0xff98b0ca),
          ),
        ),
        // 2
        ClipPath(
          clipper: Clipper1(size, 0.35, _animation2.value),
          child: Container(
            color: Color(0xff326195),
          ),
        ),
        // 1
        ClipPath(
          clipper: Clipper1(size, 0.25, 0),
          child: Container(
            color: Color(0xff224076),
          ),
        ),
        // 4
        ClipPath(
          clipper: Clipper4(size, 0.192, 0.45 * (1 - _animation2.value)),
          child: Container(
            color: Color(0xff006AAC),
          ),
        ),
        // 5
        ClipPath(
          clipper: Clipper3(size, 0.45, _animation3.value, moveDown: false),
          child: Container(
            color: Colors.yellow,
          ),
        ),
        // 6
        ClipPath(
          clipper: Clipper3(size, 0.55, _animation4.value),
          child: Container(
            color: Color(0xff006AAC),
          ),
        ),
        // 7
        ClipPath(
          clipper: Clipper2(size, 0.45),
          child: Container(
            color: Colors.orange,
          ),
        ),
        ClipPath(
          clipper: Clipper2(size, 0.55),
          child: Container(
            color: Colors.white,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "asset/image/logo3.png",
                    height: size.height * 0.3125,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "asset/image/logo2.png",
                        width: size.width / 2,
                        height: size.height * 0.0781,
                      ),
                      Image.asset("asset/image/logo1.png",
                          width: size.width / 2, height: size.height * 0.0781),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }
}
