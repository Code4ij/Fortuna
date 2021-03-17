import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/car_game/startButton.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/screen/background_audio.dart';
import 'package:fortuna/templates/game_template.dart';
import 'package:fortuna/templates/gamepage.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'car.dart';
import 'computer.dart';

class CarGameRunner extends StatelessWidget {
  final int index;

  CarGameRunner({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameTemplate(
        index: index,
        color: Color(0xfff8cd35),
        name: 'Yo Me Aseguro',
        title: 'SEGUROS',
        icon: 'asset/image/module2_icon.png',
        image: 'asset/image/module2_background.png',
        data: '',
        discription: 'Los seguros son contratos en los cuales a cambio de cobrar una prima (precio del seguro), la entidad aseguradora se compromete en caso de que se produzca algún siniestro cubierto por dicho contrato, a indemnizar el daño producido, satisfacer un capital (o renta) u otra prestación convenida.',
        gamemode: CarGameMode());
  }
}
//CarGame(size: MediaQuery.of(context).size,)
class CarGameMode extends StatefulWidget {
  @override
  _CarGameModeState createState() => _CarGameModeState();
}

class _CarGameModeState extends State<CarGameMode> {
  bool selected = false;
  int gameIndex = 0, userCarIndex = 0;
  static List<int> userCarList = [2, 2, 2];
  void changeMode() {
    setState(() {
      selected = !selected;
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return selected
        ? CarGame(size: MediaQuery.of(context).size, gameIndex: gameIndex, changeMode: changeMode, userCarIndex: userCarIndex,)
        :Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Escoja un sitio',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),
          ),
          ...List.generate(3, (index) => GestureDetector(
              child: Container(
                margin: EdgeInsets.all(size.height * 0.01),
                width: size.width * 0.8,
                height: size.height * 0.15,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('asset/cars/$index/background.png'),
                        fit: BoxFit.fill
                    ),
                  border: Border.all(
                    color: Colors.white,
                    width: gameIndex == index ? 3 : 0
                  )
                ),
                child: Center(
                  child: Text(
                    const <String>['Ciudad', 'Desierto', 'Bosque'][index],
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            onTap: () {
                setState(() {
                  // selected = true;
                  gameIndex = index;
                  userCarIndex = 0;
                });
            },
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(userCarList[gameIndex], (index) => GestureDetector(
              child: Container(
                margin: EdgeInsets.all(size.width * 0.02),
                padding: EdgeInsets.all(size.width * 0.01),
                height: size.height * 0.08,
                width: size.width * 0.25 * 0.4,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        width: userCarIndex == index ? 3 : 0
                    )
                ),
                child: Image.asset('asset/cars/$gameIndex/user_$index.png'),
              ),
              onTap: () {
                setState(() {
                  userCarIndex = index;
                });
              },
            )),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selected = true;
              });
            },
            //TODO: Change the theme of the button if required
            child: StartButton(),
          )
        ],
      ),
    );
  }
}

class CarGame extends StatefulWidget {
  static int index = 1;
  final Size size;
  final int gameIndex;
  final int userCarIndex;
  final Function changeMode;

  CarGame({Key key, this.size, this.gameIndex, this.changeMode, this.userCarIndex}) {
    final width = size.width * 0.75;
    final height = size.height * 0.6;
    Car.width = width * 0.25 * 0.6;
    Car.height = height * 0.15;
    Car.padding = width * 0.25 * 0.2;
    Car.screenWidth = width;
    Car.screenHeight = height;
  }
  @override
  _CarGameState createState() => _CarGameState();
}

class _CarGameState extends State<CarGame> with TickerProviderStateMixin {
  //TODO: revert duration to 180s
  final Duration _gameDuration = Duration(seconds: 180);
  Duration _time;
  Timer _timer;
  AnimationController _controller;
  Computer _computer;
  GameStatus _status = GameStatus.start;
  bool gameFinished = false;
  bool shouldChange = false;
  bool fullScreen = false;
  AnimationController _parkingController;
  Animation _park;
  // AssetsAudioPlayer _player = AssetsAudioPlayer.newPlayer();
  @override
  void initState() {
    // Stopping Background Audio
    BackGroundAudio().pauseAudio();
    _parkingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5)
    );


        // _player.setVolume(0.1);
    // _player.open(Audio('asset/audio/engine.mp3'), autoStart: false, showNotification: false, loopMode: LoopMode.single);
    _time = _gameDuration;
    _computer = Computer(gameOver: gameOver, updateState: updateState, gameIndex: widget.gameIndex, userCarIndex: widget.userCarIndex);
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    _controller.addListener(() {
      calculateFrame();
    });
    _computer.userCar.initController(this);
    super.initState();
  }

  @override
  void dispose() {
    // Start Background Audio Again
    BackGroundAudio().resumeAudio();

    _controller.dispose();
    _timer.cancel();
    // _player.dispose();
    _computer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = size.width * 0.75;
    double height = size.height * 0.6;
    double scale = 0.83 / 0.6;
    if(shouldChange)
      return Transform.scale(
        scale: scale,
        child: Container(
          // margin: EdgeInsets.fromLTRB(0, size.height * 0.05, 0, 0),
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('asset/image/${widget.gameIndex}/background.png'),
              fit: BoxFit.fill
            )
          ),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: 2,
                  height: height,
                  color: Colors.white,
                ),
                left: width * 0.5,
              ),
              Positioned(
                child: Container(
                  width: 1,
                  height: height,
                  color: Colors.white,
                ),
                left: width * 0.25,
              ),
              Positioned(
                child: Container(
                  width: 1,
                  height: height,
                  color: Colors.white,
                ),
                left: width * 0.75,
              ),
            ]
          ),

        ),
      );

    return Stack(children: [
      Column(
        children: [
          Transform.scale(
            scale: fullScreen ? scale : 1,
            child: GestureDetector(
              child: Container(
                // margin: EdgeInsets.fromLTRB(0, size.height * 0.05 * 0, 0, 0),
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('asset/cars/${widget.gameIndex}/background.png'),
                    fit: BoxFit.fill
                  )
                ),
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        width: 2,
                        height: height,
                        color: Colors.white,
                      ),
                      left: width * 0.5,
                    ),
                    Positioned(
                      child: Container(
                        width: 1,
                        height: height,
                        color: Colors.white,
                      ),
                      left: width * 0.25,
                    ),
                    Positioned(
                      child: Container(
                        width: 1,
                        height: height,
                        color: Colors.white,
                      ),
                      left: width * 0.75,
                    ),
                  ]
                    ..addAll(_computer.cars.map((car) => Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(car.asset),
                                    fit: BoxFit.fill)),
                            width: car.imageWidth,
                            height: car.imageHeight,
                          ),
                          left: car.x,
                          top: car.y,
                        )))
                    ..add(Positioned(
                      top: _park?.value ?? -width,
                      child: Container(
                        width: width,
                        child: Image.asset('asset/image/park.jpg', fit: BoxFit.fitWidth,),
                      ),
                    ))
                    ..add(Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(_computer.userCar.asset),
                                fit: BoxFit.fill)),
                        width: _computer.userCar.imageWidth,
                        height: _computer.userCar.imageHeight,
                      ),
                      top: _computer.userCar.y,
                      left: _computer.userCar.positionX,
                    ))..add(Align(
                      child: TimerWidget(),
                      alignment: Alignment.topCenter,
                    ))
                ),
              ),
              onTapDown: (details) {
                // if(!gameFinished)
                  _computer.updateColumn(4 * details.localPosition.dx ~/ width);
              } ,
            ),
          ),
          SizedBox(
            height: height * 0.05 + (fullScreen ? 0.115 * size.height : 0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!fullScreen)
              IconButton(
                iconSize: Car.screenWidth * 0.125 * (fullScreen ? scale / scale : 1),
                onPressed: () {
                  setState(() {
                    widget.changeMode();
                  });
                },
                icon: Icon(Icons.home, color: Colors.black,),
              ),
              if(fullScreen)
                SizedBox(width: size.width * 0.15,),
              Container(
                width: width * 0.20,
                height: width * 0.20 / 45 * 27,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('asset/image/car-money.png'),
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                width: width * 0.1,
              ),
              Container(
                width: width * 0.3,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(100)),
                child: Center(child: Text(_computer.money.toString())),
              ),
              Transform.rotate(
                angle: 3.14 / 4,
                child: IconButton(
                  iconSize: Car.screenWidth * 0.125 * (fullScreen ? scale : 1),
                  onPressed: () {
                    setState(() {
                      fullScreen = !fullScreen;
                    });
                    GamePage.of(context).setShowButton(!fullScreen);
                  },
                  icon: Icon(Icons.height, color: Colors.black,),
                ),
              )
            ],
          ),
        ],
      ),
      // Positioned(
      //   right: fullScreen ? 0 : Car.screenWidth * 0.14,
      //   top: fullScreen ? 0 : 0,
      //   child: Column(
      //     children: [
      //
      //     ],
      //   ),
      // ),
      if (_status == GameStatus.start)
        Transform.scale(
          scale: fullScreen ? scale : 1,
          child: GestureDetector(
            child: Container(
              height: size.height * 0.9,
              color: Colors.orange.withOpacity(0.6),
              child: Align(
                alignment: Alignment(0, -0.3),
                child: AutoSizeText(
                  'Toque para comenzar',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            onTap: () {
              _timer = Timer.periodic(Duration(seconds: 1), (timer) {

                _time = _time-Duration(seconds: 1);
              });
              setState(() {
                _status = GameStatus.running;
                play();
              });
            },
          ),
        ),
      if (_status == GameStatus.over)
        Transform.scale(
          scale: fullScreen ? scale : 1,
          child: GestureDetector(
            child: Container(
              height: size.height * 0.9,
              color: Colors.orange.withOpacity(0.6),
              child: Align(
                alignment: Alignment(0, -0.3),
                child: AutoSizeText(
                  'Toque para reintentar',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            onTap: () {
              _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                _time = _time-Duration(seconds: 1);
              });
              setState(() {
                _time = _gameDuration;
                _status = GameStatus.running;
                _computer.reset();
                play();
              });
            },
          ),
        )
    ]);
  }

  void calculateFrame() {
    if(!gameFinished && _time <= Duration(seconds: 0)) {
      _timer.cancel();
      gameFinished = true;
      _computer.userCar.moveToTop();
    }
    setState(() {
      _computer.update(shouldAdd: _time > const Duration(seconds: 10));
      if(_time <= const Duration(seconds: 5)) {
        if(_parkingController.isDismissed) {
          _park = Tween<double>(begin: -MediaQuery.of(context).size.width * 0.75, end: -MediaQuery.of(context).size.width * 0.13).animate(_parkingController);
          _parkingController.forward(from: 0);

        }
      }
    });

  }


  void gameOver({bool finish = false}) {
    _timer.cancel();
    if(finish) {
      _status = GameStatus.finished;
      final prefs = Prefs();
      Map data = prefs.data[CarGame.index];
      int score;
      if(_computer.money >= 1000) {
        score = 20;
        GameTemplate.of(context).trophyIndex = 0;
      }
      else if(_computer.money >= 500) {
        score = 10;
        Prefs().activeIndex = 2;
        GameTemplate.of(context).trophyIndex = 1;
      }
      else {
        score = 5;
        GameTemplate.of(context).trophyIndex = 2;
      }
      if(data['total'] < score){
        data['total'] = score;
        prefs.updateScore(CarGame.index, data);
      }
      GameTemplate.of(context).JumpPage();
      shouldChange = true;
    }
    setState(() {
      stop();
      _status = GameStatus.over;
    });
  }

  void play() {
    _controller.forward();
    _computer.play();
  }

  void stop() {
    _controller.stop();
    _computer.pause();
  }
  void updateState() {
    setState(() {});
  }


  // ignore: non_constant_identifier_names
  Widget TimerWidget() {
    final size = MediaQuery.of(context).size;
    final seconds = _time.inSeconds % 60;
    int minutes = (_time.inSeconds - seconds) ~/ 60;
    String timeString = '${format(minutes)} : ${format(seconds)}';
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1
        ),
        color: Colors.white
      ),
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.2,
      height: size.height * 0.035,
      child: Center(
        child: Text(timeString),
      ),
    );
  }

  String format(int x) {
    if(x == 0)
      return '00';
    else if(x < 10)
      return '0' + x.toString();
    else
      return x.toString();
  }
}

enum GameStatus { start, over, running, finished }
