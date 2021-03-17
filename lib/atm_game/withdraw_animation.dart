import 'package:flutter/material.dart';

class WithdrawAnimation extends StatefulWidget {

  final Function update;

  const WithdrawAnimation({Key key, this.update}) : super(key: key);
  @override
  _WithdrawAnimationState createState() => _WithdrawAnimationState();
}

class _WithdrawAnimationState extends State<WithdrawAnimation> with TickerProviderStateMixin{

  AnimationController animationController;
  AnimationController containerController;
  Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: Duration(seconds: 2));

    animation = Tween<double>(begin: 0.0, end: 50).animate(animationController);
    animationController.forward(from:0.0);

    containerController = AnimationController(
        vsync: this, duration: Duration(seconds: 2));

    containerController.forward(from: 0.0);
    containerController.addListener(() {

      if(containerController.status == AnimationStatus.completed)
        widget.update();
      else{
        setState(() {

        });
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
        builder: (context, anim){
          return Align(
            alignment: Alignment.lerp(Alignment.center, Alignment.bottomCenter,containerController.value*0.2 + 0.35),
            child: ClipPath(
                clipper: RectClipper(animation.value),
                child: Padding(
                  padding: EdgeInsets.only(left:size.width * 0.025),
                  child: Container(
                      width: size.width * 0.2812,
                      height: size.height * 0.078,
                      child: Image.asset("asset/image/money.png",fit: BoxFit.fill,)
                  ),
                )
            ),
          );
    },
      animation: animationController,
    );

  }
}

class RectClipper extends CustomClipper<Path> {

  final double value;

  RectClipper(this.value);

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, size.height - value);
    path.lineTo(size.width, size.height - value);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - value);
    return path;
  }

  @override
  bool shouldReclip( CustomClipper<Path> oldClipper) => true;

}
