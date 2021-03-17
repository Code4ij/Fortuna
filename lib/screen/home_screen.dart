import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/data.dart';
import 'package:fortuna/screen/module_screen1.dart';
import 'package:fortuna/templates/next_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final String introduction =
      "¡Hola!\n\nBienvenidos a Fortuna, la aplicación creada por la Fundación Mundo Mujer que le ayudará a aprender de una manera divertida cómo manejar y administrar su dinero.";
  final assetsAudioPlayer = AssetsAudioPlayer();
  final backAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    assetsAudioPlayer.open(
      Audio("asset/audio/Portada.m4a"), volume: 0.7
    );
    backAudioPlayer.open(Audio("asset/audio/home_background.mp3"), volume: 0.2);
    Future.delayed(const Duration(milliseconds: 200), () {
      assetsAudioPlayer.play();
      backAudioPlayer.play();
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      assetsAudioPlayer.pause();
      backAudioPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      assetsAudioPlayer.play();
      backAudioPlayer.play();
    }
  }

  @override
  void dispose() {
    // print('Observer removed');
    assetsAudioPlayer.stop();
    backAudioPlayer.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        assetsAudioPlayer.pause();
        // ignore: missing_return, missing_return, missing_return
        return onWillPop(false, context, size).then((result) {
          if (result == false) {
            assetsAudioPlayer.play();
          } else {
            assetsAudioPlayer.stop();
          }
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "asset/image/home_screen.png",
              width: size.width,
              height: size.height / 2.8,
              fit: BoxFit.fill,
            ),
            Align(
              alignment:
                  Alignment.lerp(Alignment.topLeft, Alignment.topCenter, 0.25),
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.0625),
                child: SizedBox(
                  width: size.width * 0.6,
                  height: size.height * 0.15,
                  child: AutoSizeText(
                    "Fortuna",
                    minFontSize: (size.height * 0.055).roundToDouble(),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.055,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.lerp(
                    Alignment.center, Alignment.centerRight, 0.7),
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.125),
                  child: Image.asset(
                    "asset/image/full_girl.gif",
                    width: size.width / 2,
                    height: size.height / 1.7,
                    fit: BoxFit.fill,
                  ),
                )),
            Align(
              alignment:
                  Alignment.lerp(Alignment.centerLeft, Alignment.center, 0.3),
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.2656),
                child: Container(
                  width: size.width / 2.5,
                  child: AutoSizeText(
                    "$introduction",
                    textAlign: TextAlign.start,
                    minFontSize: (size.height * 0.02).round().toDouble(),
                    style: TextStyle(
                      wordSpacing: 2,
                       fontSize: size.height * 0.025
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: size.height * 0.01, right: size.width * 0.0625),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("asset/image/logo1.png",
                        width: size.width / 2, height: size.height * 0.0781),
                    NextButton(
                      backVisible: false,
                      color: Colors.blueAccent,
                      jumpPage: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ModuleScreen1()));
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
