import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/data.dart';
import 'package:fortuna/common/make_box.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/screen/FAQ.dart';
import 'package:fortuna/screen/ad_screen.dart';
import 'package:fortuna/screen/background_audio.dart';
import 'package:fortuna/screen/setting_screen.dart';
import 'package:page_transition/page_transition.dart';

class ModuleScreen extends StatefulWidget {
  @override
  ModuleScreenState createState() => ModuleScreenState();

  static ModuleScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<ModuleScreenState>();
}

class ModuleScreenState extends State<ModuleScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool activeScreen = false;
  ConnectivityResult _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

//    // Start Background Audio
//    BackGroundAudio().startAudio();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      BackGroundAudio().pauseAudio();
    } else if (state == AppLifecycleState.resumed) {
      BackGroundAudio().resumeAudio();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = result;
          activeScreen = false;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final activeIndex = Prefs().activeIndex;
    File imageFile = new File(Prefs().imageUrl);
    Color color = Prefs().color;
    String troffy;
    int totalScore = Prefs().totalScore;
    if (totalScore > 0 && totalScore < 160)
      troffy = "platinum.png";
    else if (totalScore >= 160 && totalScore < 200)
      troffy = "gold.png";
    else if (totalScore >= 200) troffy = "diamond.png";


    print("Module Screen: $activeIndex");
    return WillPopScope(
      onWillPop: () {
        return onWillPop(true, context, size);
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: size.height * 0.2,
              color: color,
              child: Stack(alignment: Alignment.center, children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.1, bottom: size.height * 0.018),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.17,
                          height: size.width * 0.17,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(imageFile),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 3),
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: size.width * 0.046,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width * 0.4,
                              height: size.height * 0.03,
                              child: AutoSizeText(
                                Prefs().name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height * 0.025),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.4,
                              height: size.height * 0.025,
                              child: AutoSizeText(
                                Prefs().profession,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.015),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.12,
                                  height: size.height * 0.035,
                                  child: AutoSizeText(
                                    '${Prefs().totalScore}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height * 0.035,
                                    ),
                                  ),
                                ),
                                if (troffy != null)
                                  Image.asset(
                                    "asset/image/$troffy",
                                    height: size.height * 0.035,
                                  ),
                              ],
                            )
                          ],
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(size.height * 0.02),
                    child: Image.asset(
                      "asset/image/icon0.png",
                      width: size.width * 0.07,
                      height: size.height * 0.05,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Divider(
                    color: Colors.white,
                    thickness: 3,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(
                          Icons.settings,
                          size: size.width * 0.07,
                        ),
                        onPressed: () {
                          buttonClick();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SettingScreen()));
                        },
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.8,
                    decoration: BoxDecoration(
                        image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage("asset/image/home_background.png"),
                    )),
                  ),
                  Container(
                    height: size.height * 0.8,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  Container(
                    height: size.height * 0.66,
                    child: activeScreen == false
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: size.height * 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MakeBox(
                                      activeIndex: activeIndex,
                                      index: 0,
                                    ),
                                    MakeBox(
                                      activeIndex: activeIndex,
                                      index: 1,
                                    ),
                                    MakeBox(
                                      activeIndex: activeIndex,
                                      index: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: size.height * 0.01),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MakeBox(
                                      activeIndex: activeIndex,
                                      index: 3,
                                    ),
                                    MakeBox(
                                      activeIndex: activeIndex,
                                      index: 4,
                                    ),
                                    MakeBox(
                                      activeIndex: activeIndex,
                                      index: 5,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: size.height * 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MakeBox(
                                      activeIndex: activeIndex,
                                      index: 6,
                                    ),
                                    MakeBox(
                                      activeIndex: activeIndex,
                                      index: 7,
                                    ),
                                    MakeBox(
                                      activeIndex: activeIndex,
                                      index: 8,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MakeBox(
                                    activeIndex: activeIndex,
                                    index: 9,
                                  ),
                                  MakeBox(
                                    activeIndex: activeIndex,
                                    index: 10,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : AdScreen(
                            size: size,
                          ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height * 0.14,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (activeScreen == false &&
                              (_connectionStatus == ConnectivityResult.mobile ||
                                  _connectionStatus == ConnectivityResult.wifi))
                            CircleIcon(
                              id: 1,
                              data: "Información",
                              image: 'asset/image/ad_icon.png',
                              size: size,
                              toggleScreen: toggleAdScreen,
                            ),
                          if (activeScreen == true &&
                              (_connectionStatus == ConnectivityResult.mobile ||
                                  _connectionStatus == ConnectivityResult.wifi))
                            CircleIcon(
                              id: 1,
                              data: "Modulos",
                              image: 'asset/image/module_icon.png',
                              size: size,
                              toggleScreen: toggleAdScreen,
                            ),
                          CircleIcon(
                            id: 2,
                            data: "¿En que te puedo ayudar?",
                            image: 'asset/image/circle_girl.png',
                            size: size,
                            toggleScreen: toggleAdScreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AdContainer(String image, Size size) {
    print("Ads");
    return Container(
      height: size.height * 0.2,
      width: size.width * 0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: Image(
          image: new AssetImage('asset/image/$image'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  void toggleAdScreen() {
    setState(() {
      activeScreen = !activeScreen;
    });
  }
}

class CircleIcon extends StatefulWidget {
  final int id;
  final String data;
  final String image;
  final Size size;
  final Function toggleScreen;

  CircleIcon(
      {Key key,
      this.size,
      this.id,
      this.data,
      this.image,
      this.toggleScreen})
      : super(key: key);

  @override
  _CircleIconState createState() => _CircleIconState();
}

class _CircleIconState extends State<CircleIcon>
    with SingleTickerProviderStateMixin {
  // Glow Effect Animation
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 6.0).animate(_animationController)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.stop();
    _animation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.size.height * 0.005),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              buttonClick();
              if (widget.id == 1) {
                widget.toggleScreen();
              } else {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FAQ()));
              }
            },
            child: Container(
              width: widget.size.width * 0.15,
              height: widget.size.width * 0.15,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.image), fit: BoxFit.fill),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xff0073b1),
                      blurRadius: _animation.value,
                      spreadRadius: _animation.value)
                ],
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xff0073b1), width: 3),
//                  color: Colors.white,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.size.height * 0.008),
              child: Center(
                child: Container(
                  width: widget.size.width / 3,
                  child: AutoSizeText(
                    '${widget.data}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (widget.size.height * 0.018),
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
