import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortuna/common/data.dart';

class NextButton extends StatefulWidget {
  static Function prevPage;
  final Color color;
  final Function jumpPage;
  final bool nextAvailable;
  final bool backVisible;

  NextButton(
      {Key key,
      this.color,
      this.jumpPage,
      this.nextAvailable = true,
      this.backVisible = true})
      : super(key: key);

  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: Next Button Glow
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 5.0).animate(_animationController)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment:
          Alignment.lerp(Alignment.bottomCenter, Alignment.bottomRight, 0.9),
      child: Padding(
        padding: EdgeInsets.only(bottom: size.height * 0.05, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.backVisible)
              InkWell(
                onTap: () {
                  NextButton.prevPage();
                  buttonClick();
                },
                child: Container(
                  width: size.height * 0.06,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.color, width: 4),
                      boxShadow: [
                        BoxShadow(
                            color: widget.color,
                            blurRadius: _animation.value,
                            spreadRadius: _animation.value)
                      ]),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color,
                        border: Border.all(color: Colors.white, width: 4)),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: size.height * 0.0281,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(
              width: size.width * 0.03,
            ),
            InkWell(
              onTap: widget.nextAvailable
                  ? () {
                      widget.jumpPage();
                      buttonClick();
                    }
                  : () {
                      Fluttertoast.showToast(
                          msg:
                              "Tienes que completar este módulo para ir más allá",
                          textColor: Colors.white,
                          backgroundColor: Colors.black);
                    },
              child: Container(
                width: size.height * 0.06,
                height: size.height * 0.06,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.color, width: 4),
                    boxShadow: [
                      BoxShadow(
                          color: widget.color,
                          blurRadius: _animation.value,
                          spreadRadius: _animation.value)
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                      border: Border.all(color: Colors.white, width: 4)),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: size.height * 0.0281,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.stop();
    _animation.removeListener(() {});
    super.dispose();
  }
}
