import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/screen/module_controller.dart';
import 'package:fortuna/templates/Certificate.dart';
import 'package:fortuna/templates/clip_rect.dart';
import 'package:fortuna/templates/next_button.dart';

import 'app_bar.dart';
import 'image_button.dart';

class WinPage extends StatefulWidget {
  final String data;
  final String image;
  final String icon;
  final Color color;
  final int trophyindex;
  final bool notLast;

  final Function jumpPage;
  final Function onWillPop;

  const WinPage(
      {Key key,
      @required this.data,
      @required this.image,
      @required this.icon,
      @required this.color,
      this.jumpPage,
      this.onWillPop,
      this.trophyindex,
      this.notLast})
      : super(key: key);

  @override
  _WinPageState createState() => _WinPageState();
}

class _WinPageState extends State<WinPage> {
  ConfettiController _controller;
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 5));
    _assetsAudioPlayer.open(Audio("asset/audio/celebration.aac"), volume: 0.7);
    _assetsAudioPlayer.play();
    startConfetti();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  void startConfetti() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      _controller.play();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> _image = [
      "asset/image/diamond.png",
      'asset/image/gold.png',
      'asset/image/platinum.png'
    ];
    final size = MediaQuery.of(context).size;
    final fontweight = FontWeight.bold;
    double fontsize = size.height * 0.026;
    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: Column(
        children: [
          CustomAppBar(color: widget.color, icon: widget.icon),
          Expanded(
            child: Stack(
              children: [
                ImageButton(size, size.height * 0.755),
                ClipPath(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new AssetImage(widget.image),
                        )),
                      ),
                      Container(
                        color: widget.color.withOpacity(0.5),
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ],
                  ),
                  clipper: CustomRect(),
                ),
                Align(
                  child: ConfettiWidget(
                    blastDirectionality: BlastDirectionality.explosive,
                    confettiController: _controller,
                    gravity: 0.05,
                    shouldLoop: true,
                    numberOfParticles: 15,
                    colors: [
                      Colors.green,
                      Colors.red,
                      Colors.yellow,
                      Colors.blue,
                      Colors.pink
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment(0.0, -0.2),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          _image[widget.trophyindex],
                          height: size.height * 0.2,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          width: size.width * 0.7,
                          child: AutoSizeText(
                            'Lo lograste, puedes continuar con los demás módulos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: fontweight,
                              fontSize: fontsize,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                NextButton(
                  color: widget.color,
                  jumpPage: () {
                    if(widget.notLast)
                      widget.jumpPage();
                    else {
                      int index = ModuleController.of(context).index;
                      if (index >= 10) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Certificate()));
                      } else {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

