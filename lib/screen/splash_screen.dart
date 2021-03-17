import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/screen/login_screen.dart';
import 'package:fortuna/services/syncup_service.dart';
import 'package:fortuna/templates/FlashScreen.dart';
import 'package:fortuna/screen/home_screen.dart';
import 'package:fortuna/screen/module_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fortuna/screen/background_audio.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 5750;

  bool isItFirst = false;
  bool isTimerOver = false;
  bool isSyncUpOver = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Start Background Audio
    BackGroundAudio().startAudio();
    checkIsItFirstTime();
    startSyncUp();
    loadWidget();
  }


  Future<void> startSyncUp() async {
    var listener;
    listener = SyncUpService().syncUpAllUsers().listen((event) {
      if (event) {
        if (mounted) {
          if (isTimerOver == true) {
            navigationPage();
          }
          print("Cur User Synced up.");
          setState(() {
            isSyncUpOver = true;
          });
        }
        listener.cancel();
      }
    });
  }

  Future<Timer> loadWidget() async {
    var duration = Duration(milliseconds: splashDelay);
    return Timer(duration, () {
      print("Time Over");
      if (mounted) {
        if (isSyncUpOver == true) {
          navigationPage();
        }
        setState(() {
          isTimerOver = true;
        });
      }
    });
  }

  void checkIsItFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isItFirst = prefs.getBool("isItFirst") ?? true;
    if (isItFirst == true) prefs.setBool("isItFirst", false);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => isItFirst == true
                ? HomeScreen()
                : Prefs().currentUser == -1
                    ? LoginScreen()
                    : ModuleScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          FlashScreen(),
          Align(
            alignment: Alignment(0, -0.1),
            child: Image.asset(
              "asset/image/icon2.png",
              height: size.height * 0.1,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment(0, 0.1),
            child: AutoSizeText(
              "Fortuna",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: size.height * 0.065,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..color = Colors.black
                  ..strokeWidth = 3
                  ..style = PaintingStyle.stroke,
              ),
            ),
          ),
          if (isTimerOver && !isSyncUpOver)
            Positioned(
              bottom: size.height * 0.15,
              child: Container(
                width: size.width,
                child: Center(
                  child: Column(
                    children: [
                      SpinKitFadingCircle(
                        color: Colors.black,
                      ),
                      Text("Sync Up Data..."),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
