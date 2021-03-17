import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/screen/FAQ.dart';
import 'package:fortuna/common/data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fortuna/templates/game_template.dart';
// ignore: non_constant_identifier_names

class ImageButton extends StatefulWidget {
  final bool showFAQ;
  final double top_padding;
  final Size size;

  ImageButton(this.size, this.top_padding, {this.showFAQ = true});

  @override
  _ImageButtonState createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _animationController;
  Animation _animation;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    // TODO: Next Button Glow
    WidgetsBinding.instance.addObserver(this);
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 5.0).animate(_animationController)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      assetsAudioPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      assetsAudioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(widget.showFAQ)
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: widget.size.width * 0.06, top: widget.top_padding),
                child: GestureDetector(
                  onTap: () {
                    buttonClick();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => FAQ()));
                  },
                  child: Container(
                    width: widget.size.width * 0.125,
                    height: widget.size.width * 0.125,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/image/circle_girl.png'),
                          fit: BoxFit.fill),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff0073b1),
                            blurRadius: _animation.value,
                            spreadRadius: _animation.value)
                      ],
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xff0073b1), width: 3),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: widget.size.width * 0.0437,
                      bottom: widget.size.width * 0.0125),
                  child: Center(
                    child: SizedBox(
                      width: widget.size.width * 0.24,
                      height: widget.size.height * 0.2,
                      child: AutoSizeText(
                        '¿En que te puedo \n ayudar?',
                        textAlign: TextAlign.center,
                        minFontSize: (widget.size.height * 0.013).roundToDouble(),
                        style: TextStyle(
                            fontSize: widget.size.height * 0.01,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: widget.size.width * 0.04, top: widget.top_padding),
              child: GestureDetector(
                onTap: () async {
                  print("Clicked");
                  buttonClick();
                },
                child: Container(
                  width: widget.size.width * 0.125,
                  height: widget.size.width * 0.125,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('asset/image/hint.png'),
                        fit: BoxFit.fill),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xfff8ce34),
                          blurRadius: _animation.value,
                          spreadRadius: _animation.value)
                    ],
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xfff8ce34), width: 3),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                    left: widget.size.width * 0.0437,
                    bottom: widget.size.width * 0.0125),
                child: Center(
                  child: SizedBox(
                    width: widget.size.width * 0.24,
                    height: widget.size.height * 0.1,
                    child: AutoSizeText(
                      '¿Quieres aprender \nmas?',
                      textAlign: TextAlign.center,
                      minFontSize: (widget.size.height * 0.013).roundToDouble(),
                      style: TextStyle(
                          fontSize: widget.size.height * 0.01,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.stop();
    _animation.removeListener(() {});
    assetsAudioPlayer?.dispose();
    super.dispose();
  }
}
