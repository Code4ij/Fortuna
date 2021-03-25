import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/make_box.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/screen/login_screen.dart';
import 'package:fortuna/screen/module_screen.dart';
import 'package:fortuna/templates/clip_rect.dart';
import 'package:fortuna/common/data.dart';
import 'package:fortuna/templates/next_button.dart';
import 'package:fortuna/screen/background_audio.dart';

class ModuleScreen1 extends StatefulWidget {
  final bool isFirstTime;

  const ModuleScreen1({Key key, this.isFirstTime = true}) : super(key: key);
  @override
  _ModuleScreen1State createState() => _ModuleScreen1State();
}

class _ModuleScreen1State extends State<ModuleScreen1> with WidgetsBindingObserver{

  final assetsAudioPlayer = AssetsAudioPlayer();
  final backAudioPlayer = AssetsAudioPlayer();

  int activeIndex = 0;
  int activeScreen = 1;

  Color screen1Color = Color(0xffF6892B);
  Color screen2Color = Color(0xff0072B2);

  @override
  void initState() {
    super.initState();
    BackGroundAudio().pauseAudio();
    WidgetsBinding.instance.addObserver(this);
    assetsAudioPlayer.open(
        Audio("asset/audio/def_module0.mp3"), volume: 0.7
    );
    backAudioPlayer.open(
        Audio("asset/audio/home_background.mp3"), volume: Prefs().musicVolume * 0.15
    );
    backAudioPlayer.play();
    assetsAudioPlayer.play();
    NextButton.prevPage = () {
      activeIndex = 0;
      activeScreen = 1;
      updateBox(0);
//      setState(() {});
    };
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.inactive) {
      assetsAudioPlayer.pause();
      backAudioPlayer.pause();
    } else if(state == AppLifecycleState.resumed) {
      assetsAudioPlayer.play();
      backAudioPlayer.play();
    }
  }

  @override
  void dispose() {
    // print('Observer removed');
    assetsAudioPlayer.stop();
    backAudioPlayer.stop();
    assetsAudioPlayer.dispose();
    backAudioPlayer.dispose();
    BackGroundAudio().resumeAudio();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void updateBox(int acIndex) async {
    print(acIndex);
    activeIndex = acIndex;
    await assetsAudioPlayer.stop();
    await assetsAudioPlayer.open(
        Audio("asset/audio/def_module$activeIndex.mp3"), volume: 0.7
    );
    assetsAudioPlayer.play();
    setState(()  {});
  }

  Widget getBox(int index){
    return MakeBox(activeIndex: activeIndex,index: index,isLarge: true,isIntro:true,updateBox: updateBox);
  }
  @override
  Widget build(BuildContext context) {
    print(activeIndex);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        assetsAudioPlayer.pause();
        // ignore: missing_return, missing_return, missing_return
        if(widget.isFirstTime) {
          return onWillPop(false, context, size).then((result) {
            if (result == false) {
              assetsAudioPlayer.play();
            } else {
              assetsAudioPlayer.stop();
            }
            return result;
          });
        } else {
          return await assetsAudioPlayer.stop().then((value) => true);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            ClipPath(
              child: Stack(
                children: [
                  Container(
                    color: screen1Color.withOpacity(0.2),
                  ),
                  Container(
                    color: Colors.white.withOpacity(0.2),
                  )
                ],
              ),
              clipper: CustomRect(),
            ),

            Column(
              children: [

                Padding(
                  padding:
                  EdgeInsets.only(top: size.height * 0.039,bottom: size.height * 0.0125),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      activeIndex <= 4 ? getBox(0) : getBox(5),
                      activeIndex <= 4 ? getBox(1) : getBox(6),
                      activeIndex <= 4 ? getBox(2) : getBox(7)
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    activeIndex <= 4 ? getBox(3) : getBox(8),
                    activeIndex <= 4 ? getBox(4) : getBox(9),
                    if(activeIndex > 4)
                      getBox(10)
                  ],
                ),
                Container(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Padding(
                        padding: EdgeInsets.only(top:size.height * 0.1218,left: size.width * 0.15),
                        child: SizedBox(
                          width: size.width/3.5,
                          height: size.height/18,
                          child: AutoSizeText(
                            "Presiona uno \nde los módulos",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: activeScreen == 1 ? screen1Color: screen2Color,
                                fontSize: size.height * 0.021
                            ),
                          ),
                        ),
                      ),
                      Image.asset("asset/image/girl.gif",width: size.width/3,height: size.height/5.5,fit: BoxFit.fill,),
                    ],
                  ),
                ),
                Divider(height:0,thickness: 4,color: activeScreen == 0 ? screen1Color: screen2Color,indent: size.width * 0.0937,endIndent: size.width * 0.156,),

                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.039),
                  child: SizedBox(
                    width: size.width/1.5,
                    height: size.height/3.5,
                    child: AutoSizeText(
                      //'${activeScreen == 1 ? moduleScreen1Data : moduleScreen2Data}',
                      '${data[activeIndex]["initialData"]}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          wordSpacing: 2,
                          fontSize: size.height * 0.023
                      ),
                    ),
                  ),
                )
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom:size.height*0.01,right: size.width * 0.0625),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("asset/image/logo1.png",width: size.width/2,height: size.height * 0.0781,fit: BoxFit.fill,),
                    NextButton(
                      backVisible: activeScreen == 2 ? true : false,
                      color: Colors.blueAccent,
                      jumpPage: () async {
                        buttonClick();
                        if(activeIndex < 5){
                          activeIndex = 5;
                          activeScreen = 2;
                          updateBox(activeIndex);
                        } else {
                          if(!widget.isFirstTime) {
                            Navigator.of(context).pop();
                          } else if(Prefs().currentUser != -1) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ModuleScreen()));
                          } else {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginScreen()));
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
