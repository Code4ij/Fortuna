import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class StartButton extends StatefulWidget {
  @override
  _StartButtonState createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: Next Button Glow
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 3.0).animate(_animationController)
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
    return Container(
      margin: EdgeInsets.all(size.height*0.02),
      width: size.width * 0.25,
      height: size.height * 0.05,
      child: Center(
          child: AutoSizeText(
        'Comenzar',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.02),
      )),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: _animation.value,
                spreadRadius: _animation.value)
          ],
          borderRadius: BorderRadius.circular(size.height * 0.02)),
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
