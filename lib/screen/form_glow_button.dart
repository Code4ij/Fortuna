import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class FormGlowButton extends StatefulWidget {
  final String buttonText;

  FormGlowButton({Key key, this.buttonText}) : super(key: key);

  @override
  _FormGlowButtonState createState() => _FormGlowButtonState();
}

class _FormGlowButtonState extends State<FormGlowButton>
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
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: _animation.value,
              spreadRadius: _animation.value
          )],
          border: Border.all(
              color: Colors.black, width: 0),
          borderRadius: BorderRadius.all(
              Radius.circular(
                  size.height * 0.05 * 0.4)),
          color: Colors.black.withOpacity(0.3)),
      width: size.width * 0.3,
      height: size.height * 0.05,
      child: Center(
          child: AutoSizeText(
            "${widget.buttonText}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: size.height * 0.020),
          )),
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
