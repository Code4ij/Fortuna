import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/screen/background_audio.dart';
import 'package:fortuna/templates/clip_rect.dart';
import 'package:fortuna/templates/image_button.dart';
import 'package:fortuna/templates/next_button.dart';

import 'app_bar.dart';

class NamePage extends StatefulWidget {

  final String name;
  final String image;
  final String icon;
  final Color color;
  final Function jumpPage;
  final Function onWillPop;
  final AssetsAudioPlayer assetsAudioPlayer;

  const NamePage({Key key, this.name, this.image, this.icon, this.color, this.jumpPage, this.onWillPop, this.assetsAudioPlayer}) : super(key: key);
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> with WidgetsBindingObserver {

  bool shouldJump = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(seconds: 3), () {
      if(shouldJump)
        widget.jumpPage();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.assetsAudioPlayer.play();
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.inactive) {
      widget.assetsAudioPlayer.pause();
    } else if(state == AppLifecycleState.resumed) {
      widget.assetsAudioPlayer.play();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addObserver(this);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: Column(
        children: [
          CustomAppBar(color: widget.color, icon: widget.icon),
          Expanded(
            child: Stack(
              children: [
                ImageButton(size,size.height*0.755,),
                ClipPath(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              // colorFilter:
                              // ColorFilter.mode(Colors.purple.withOpacity(0.4),
                              //     BlendMode.colorDodge),
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
                  alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.85),
                  child: Padding(
                    padding: EdgeInsets.only(left:size.width*0.05,right:size.width*0.05),
                    child: AutoSizeText(
                      '${widget.name}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.0625,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                NextButton(
                  jumpPage: () {
                    shouldJump = false;
                    widget.jumpPage();
                  },
                  color: widget.color,
                  backVisible: false,
                  nextAvailable: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
