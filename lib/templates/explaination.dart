import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/data.dart';
import 'package:fortuna/templates/clip_rect.dart';
import 'package:fortuna/templates/next_button.dart';

import 'app_bar.dart';
import 'image_button.dart';

class ExplainationPage extends StatefulWidget {
  final String data;
  final String image;
  final String icon;
  final Color color;
  final String title;
  final Function jumpPage;
  final Function onWillPop;
  final int index;
  const ExplainationPage({Key key, @required this.data,@required this.title,@required this.image,@required this.icon,@required this.color, this.jumpPage, this.onWillPop, this.index}) : super(key: key);

  @override
  _ExplainationPageState createState() => _ExplainationPageState();
}

class _ExplainationPageState extends State<ExplainationPage> with WidgetsBindingObserver {

  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _assetsAudioPlayer.open(Audio("asset/audio/exp_module${widget.index}.mp3"), volume: 0.7);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.inactive) {
      _assetsAudioPlayer.pause();
    } else if(state == AppLifecycleState.resumed) {
      _assetsAudioPlayer.play();
    }
  }

  @override
  void dispose() {
    _assetsAudioPlayer.stop();
    _assetsAudioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: Column(
        children: [
          CustomAppBar(color: widget.color, icon: widget.icon),
          Expanded(
            child: Stack(
              children: [
                ImageButton(size,size.height*0.755),
                ClipPath(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage(
                                  widget.image
                              ),
                            )
                        ),
                      ),
                      Container(
                        color: widget.color.withOpacity(0.2),
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.2),
                      )
                    ],
                  ),
                  clipper: CustomRect(),
                ),
                Align(
                  alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.36),
                  child: Container(
                    width: size.width/1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200].withOpacity(0.7),
                    ),
                    child: Wrap(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(top:size.height*0.0156, bottom: size.height*0.025),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              height: size.height * 0.05,
                              child: AutoSizeText(
                                '¿Cómo jugar?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.height * 0.039,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: size.width*0.075,right: size.width*0.075,bottom: size.height*0.03125),
                          child: AutoSizeText(
                            '${data[widget.index]["explaination"]}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: size.height * 0.025,
                              wordSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                NextButton(
                  color: widget.color,
                  jumpPage: () {
                    _assetsAudioPlayer.stop();
                    widget.jumpPage();
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