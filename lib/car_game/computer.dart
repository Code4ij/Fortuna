
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:fortuna/common/prefs.dart';

import 'car.dart';

class Computer {
  static List<int> botCarList = [2, 4, 4];
  AssetsAudioPlayer _crash = AssetsAudioPlayer.newPlayer()..open(Audio('asset/audio/crash.mp3'), volume: 0.4 * Prefs().musicVolume, autoStart: false, showNotification: false, loopMode: LoopMode.none);
  AssetsAudioPlayer _coin = AssetsAudioPlayer.newPlayer()..open(Audio('asset/audio/coin.mp3'), volume: 0.4 * Prefs().musicVolume, autoStart: false, showNotification: false, loopMode: LoopMode.none);
  AssetsAudioPlayer _player = AssetsAudioPlayer.newPlayer();
  List<Car> cars = [];
  Random _random = Random();
  double _carCounter = 0;
  double _coinCounter = 0;
  int lastAddedCar = 0;
  int lastAddedCoin = 0;
  UserCar userCar;
  Function gameOver;
  Function updateState;
  int money = 0;
  final int gameIndex;
  final int userCarIndex;
  Computer({@required this.gameOver, @required this.updateState, this.gameIndex, this.userCarIndex}) {
    addCar();
    userCar = UserCar(gameIndex, userCarIndex);
    userCar.gameOver = gameOver;
    _player.open(Audio('asset/audio/engine.mp3'), volume: 0.4 * Prefs().musicVolume ,autoStart: false, showNotification: false, loopMode: LoopMode.single);

    Prefs().volumeStream.listen((_) {
      final vol = Prefs().musicVolume;
      print("Changing: $vol");
      _player.setVolume(0.4 * vol);
      _coin.setVolume(0.4 * vol);
      _crash.setVolume(0.4 * vol);
    });
  }

  void addCar() {
    int column = lastAddedCoin;
    while(column == lastAddedCoin) {
      column = _random.nextInt(4);
    }
    lastAddedCar = column;
    String path = 'asset/cars/$gameIndex/bot_${_random.nextInt(botCarList[gameIndex])}.png';
    cars.add(ComputerCar(column, path));
  }

  void addCoin() {
    int column = lastAddedCar;
    while(column == lastAddedCar) {
      column = _random.nextInt(4);
    }
    lastAddedCoin = column;
    cars.add(Coin(column));
  }

  void reset() {
    cars = [TestCar(-100, -100)];
    userCar.reset();
    money = 0;
  }

  void update({bool shouldAdd = true}) {
    _carCounter += Car.screenHeight * 0.005;
    _coinCounter += Car.screenHeight * 0.005;
    cars.forEach((car) {
      car.updatePosition();
        if(car.checkCollision(userCar)) {
          if(!car.alive)
            return;
          car.alive = false;
          if(car is Coin) {
            _coin.play();
            money += 150;
            updateState();
          } else {
            _crash.play();
            cars[0] = TestCar(car.x, car.y);
            if(money >= 500) {
              money -= 500;
              updateState();
            } else {

              gameOver();
            }

          }
        }
    });
    cars.removeWhere((car) => car.y > Car.screenHeight || !car.alive);

    if(!shouldAdd) {
      return;
    }
    if(_carCounter >= 0.45 * Car.screenHeight) {
      addCar();
      _carCounter = 0;
    }
    if(_coinCounter >= Car.screenHeight) {
      addCoin();
      _coinCounter = 0;
    }

  }
  void dispose() {
    _crash.dispose();
    _coin.dispose();
    _player.dispose();
    _player=null;
    // print('Player Disposed');
  }

  void pause() {
    _player.pause();
  }
  void play() {
    _player.play();
  }

  // void _updatePlayer(Duration position) {
  //
  //   Duration a = Duration(milliseconds: -4200);
  //   Duration b = Duration(seconds: 7, milliseconds: 627);
  //   print(position);
  //   // if(position > b) {
  //   //   print('position backward by ${a.inMilliseconds}');
  //   //   _player.seekBy(a);
  //   // }
  // }
  void updateColumn(int index) {
    userCar.updateColumn(index);
//    restartPlayer();
  }
  void restartPlayer() {
    _player.stop().then((value) => _player.play());
  }
}