import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/screen/module_controller.dart';
import 'package:fortuna/screen/module_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'data.dart';


class MakeBox extends StatefulWidget {
  final int index;
  final int activeIndex;
  bool isLarge;
  bool isIntro;
  Function updateBox;

  MakeBox({Key key,  @required this.index,
    @required this.activeIndex,
    this.isLarge = false,
    this.isIntro = false,
    this.updateBox}) : super(key: key);
  @override
  _MakeBoxState createState() => _MakeBoxState();
}

class _MakeBoxState extends State<MakeBox> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: Next Button Glow
    // if(widget.isLarge == true){
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 4.0).animate(_animationController)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    // }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
          left: size.width * 0.05,
          right: size.width * 0.05,
          bottom: size.height * 0.0062,
          top: size.height * 0.0062),
      child: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  if (widget.isIntro == false && widget.isLarge == false && (widget.index <= Prefs().activeIndex)) {
                    await Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.center,
                        duration: Duration(seconds: 1),
                        child: ModuleController(
                          index: widget.index,
                        ),
                      ),
                    );
                    _animationController.repeat(reverse: true);
                    print("Screen popped");
                    ModuleScreen.of(context).updateState();
                  }else{
                    if(widget.updateBox != null)
                      widget.updateBox(widget.index);
                    if(widget.activeIndex == widget.index){
                      _animationController.repeat(reverse: true);
                    }
                  }

                },
                child: Container(
                  width: widget.isLarge == false
                      ? size.width / 6
                      : widget.activeIndex != widget.index
                      ? size.width / 6
                      : size.width / 5.9,
                  height: widget.isLarge == false
                      ? size.height * 0.0869
                      : widget.activeIndex != widget.index
                      ? size.height * 0.086
                      : size.height * 0.095,
                  child: Opacity(
                    opacity: widget.isLarge == true
                        ? 1
                        : widget.activeIndex >= widget.index
                        ? 1
                        : 0.5,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.025,
                          top: size.height * 0.0125,
                          bottom: size.height * 0.0125,
                          right: size.width * 0.025),
                      child: Image.asset(
                        "asset/image/module${widget.index + 1}_icon.png",
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: data[index]["color"],
                      boxShadow: [
                        BoxShadow(
                            color: widget.isLarge == true && widget.activeIndex == widget.index ? data[widget.index]["color"] : data[widget.index]["color"],
                            blurRadius: widget.isLarge == true && widget.activeIndex == widget.index ?  _animation.value : widget.isIntro == false && widget.index <= Prefs().activeIndex ?_animation.value : 0,
                            spreadRadius: widget.isLarge == true && widget.activeIndex == widget.index ?  _animation.value : widget.isIntro == false && widget.index <= Prefs().activeIndex ? _animation.value : 0)
                      ],
                      color: widget.isLarge == true
                          ? widget.activeIndex == widget.index ? data[widget.index]["color"] : data[widget.index]["color"].withOpacity(0.5)
                          : widget.activeIndex >= widget.index
                          ? data[widget.index]["color"]
                          : data[widget.index]["color"].withOpacity(0.5)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: size.height * 0.009, top: size.height * 0.0062),
                child: SizedBox(
                  width: size.width / 4.5,
                  height: size.height * 0.042,
                  child: AutoSizeText(
                    '${data[widget.index]["name"]}',
                    textAlign: TextAlign.center,
                    minFontSize: (size.height * 0.016).roundToDouble(),
                    style: TextStyle(
                      color: widget.isIntro == false && widget.index <= widget.activeIndex ? Colors.black : widget.index == widget.activeIndex ? Colors.black:  Color.lerp(Colors.black, Colors.transparent, .5),
                      fontSize: size.height * 0.016,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
