import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/farmer_game/FramerGame.dart';

class FarmerGameScreen extends StatefulWidget {
  Size size;
  @override
  _FarmerGameScreenState createState() => _FarmerGameScreenState();
}

class _FarmerGameScreenState extends State<FarmerGameScreen> {

  double width;
  double hei;
  Icon icon = Icon(Icons.home,color: Colors.pink,);
  Color color = Colors.black ;
  bool isBlack = false;
  void _incrementCounter() {

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.size == null) {
      widget.size = MediaQuery.of(context).size;
      width = widget.size.width * 0.8;
      hei = widget.size.height * 0.8;
    }
    return Container(
      child: Center(
          child: GestureDetector(
            onTap: (){
              isBlack = !isBlack;
              setState(() {

              });
            },
            child: Container(

              child: Module5(),
            ),
          )
      ),
    );

  }
}

class oneContainer extends ImplicitlyAnimatedWidget  {
  String  image;
  oneContainer({this.image}) : super(duration: Duration(milliseconds: 200));
  @override
  _oneContainerState createState() => _oneContainerState() ;
}

class _oneContainerState extends AnimatedWidgetBaseState<oneContainer> {
  StringTween tween;
  CustomOpacity opacity;

  @override
  Widget build(BuildContext context) {
    String s = tween.evaluate(animation);
    return Opacity(
      // opacity: 1,
      opacity: opacity.evaluate(animation) ?? 0,
      child: Container(
        // decoration: s == "s" ? BoxDecoration() : BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.cover,
        //       image: AssetImage(tween.evaluate(animation)),
        //     )
        // ),
        child: s =="s" ? Container() : Image.asset(tween.evaluate(animation),fit: BoxFit.cover,),
      ),
    );
  }

  @override
  void forEachTween(visitor) {
    tween = visitor(
      tween,
      widget.image,
          (va) => StringTween(begin: va),
    );
    opacity = visitor(
      opacity,
      1.0,
          (val) => CustomOpacity(),
    );
  }

}
class CustomOpacity extends Tween<double>{
  CustomOpacity() : super();
  double lerp(double t){
    if(t < 0.5){
      return (1 - t*2);
    }
    else{
      return (t-0.5) * 2;
    }
  }
}
class StringTween extends Tween<String>{
  StringTween({String begin,String end}) : super(begin: begin,end: end);
  String lerp(double t){
    if(t < 0.5 ) {
      return begin;
    }
    else {
      return end;
    }
  }
}
class CustomTween extends Tween<Color>{
  final Color middle = Colors.red;
  CustomTween({Color begin,Color end}) : super(begin: begin,end: end);
  Color lerp(double t){
    if(t < 0 ){
      return Color.lerp(begin, middle, t*2);
    }
    else{
      return Color.lerp(middle, end, (t - 0.5)* 2);
    }
  }
}