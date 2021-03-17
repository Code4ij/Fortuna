import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

abstract class Car {
  double x, y;
  int column;
  bool alive = true;
  static double width, height, padding, screenWidth, screenHeight;
  String asset;
  void updatePosition() {
    y += Car.screenHeight * 0.005;
  }

  double get imageWidth;
  double get imageHeight;
  double get imagePadding;

  bool checkCollision(UserCar userCar) {
    double rightSide = x + imageWidth;
    double leftSide = x;
    if(userCar.positionX > rightSide || userCar.positionX + userCar.imageWidth < leftSide) {
      return false;
    }
    double topSide = y;
    double bottomSide = y + imageHeight;
    if(userCar.y > bottomSide || userCar.y + userCar.imageHeight < topSide) {
      return false;
    }
    // print('Collision Car: ${this.column} userCar: ${userCar.column}  ');
    // print(' Positions UserCar leftSide: ${userCar.positionX} rightSide: ${userCar.positionX + userCar.imageWidth} x: ${userCar.x}');
    // print(' Positions ComputerCar leftSide: $leftSide rightSide: $rightSide');

    return true;

    // if(column != userCar.column)
    //   return false;
    // if(y > userCar.y + userCar.imageHeight)
    //   return false;
    // if(y + this.imageHeight < userCar.y)
    //   return false;
    // if(this is ComputerCar)
    //   print('Collision Car: ${this.column} userCar: ${userCar.column}');
    // return true;
  }

  // bool shouldCheckCollision(UserCar userCar) {
  //   // if(imageHeight + y >= userCar.y && y <= userCar.y + userCar.imageHeight)
  //   //   return true;
  //   // return false;
  //   return (4 * userCar.positionX ~/ Car.screenWidth) == this.column;
  // }
}

class UserCar extends Car {
  AnimationController _positionController;
  Animation<double> _positionAnimation;

  Function gameOver;

  UserCar(int gameIndex, int carIndex) {
    asset = 'asset/cars/$gameIndex/user_$carIndex.png';
    x = 0;
    y = Car.screenHeight - imageHeight * 1.2;
    column = 0;
  }

  void reset() {
    columnX = 0;
    x = 0;
    y = Car.screenHeight - imageHeight * 1.2;
    column = 0;
  }

  double get imageWidth => Car.width;
  double get imageHeight => Car.height;
  double get imagePadding => Car.padding;
  double finalPos;

  void initController(TickerProvider sync) {
    _positionController = AnimationController(vsync: sync, lowerBound: 0, upperBound: 1);
    _positionController.reset();
  }
  Animation animation;
  void moveToTop() {
    finalPos = Car.screenWidth/2 - Car.padding*1.5;
    _positionController.duration = Duration(seconds: 3);
    animation = Tween<double>(begin: y, end: -imageHeight).animate(_positionController);
    _positionController.forward(from: 0);
    animation.addListener(moveToTopListener);
    animation.addStatusListener(moveToTopStatusListener);
  }

  void moveToTopListener() {
    if(animation == null) {
      return;
    }
     x = finalPos - Car.padding;
     y = animation.value;
     // print('Updating y');
   }
  void moveToTopStatusListener(AnimationStatus status) {
    if(status == AnimationStatus.completed && animation != null) {
      gameOver(finish: true);
      animation.removeStatusListener((status) {});
      animation.removeListener(() {});
      animation = null;
    }
  }

  int columnX = 0;
  void updateColumn(int column) {
    // print('Update column called');
    if(column == this.column)
      return;
    else if(column < this.column) {
      column = this.column - 1;
      if(columnX>0)
        columnX--;
    } else {
      column = this.column + 1;
      if(columnX<3)
        columnX++;
    }

    // print("Current Column: ${this.column} New Column: $column Column: $columnX");

    Tween<double> tween = Tween<double>(begin: this.x, end: columnX * 0.25 * Car.screenWidth);
    double multiplier = (x - columnX * 0.25 * Car.screenWidth) / (0.25 * Car.screenWidth);
    if(multiplier < 0)
      multiplier *= -1;
    _positionController.duration = Duration(milliseconds: (200 * multiplier).toInt());
    try{
      _positionAnimation.removeListener(listener);
    } catch(e) {
      // print("Error in removing listener");
    }

    _positionController.reset();
    _positionAnimation = tween.animate(_positionController)..addListener(listener);
    _positionAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed)
        this.column = this.columnX;
    });
    _positionController.forward();
  }
  double get positionX => x + imagePadding;

  void listener() {
    // print('Position updated');
    this.x = _positionAnimation.value;
  }
}

class ComputerCar extends Car {
  ComputerCar(int c , String path) {
    asset = path;
    x = 0;
    column = c;
    x = column * Car.screenWidth * 0.25 + imagePadding;
    y = -imageHeight;
  }
  double get imageWidth => Car.width;
  double get imageHeight => Car.height;
  double get imagePadding => Car.padding;


}

class Coin extends Car {
  double get imageWidth => Car.screenWidth * 0.25 * 0.5;
  double get imageHeight => Car.screenWidth * 0.25 * 0.5;
  double get imagePadding => Car.screenWidth * 0.25 * 0.25;

  Coin(int c) {
    asset = 'asset/image/coin.png';
    x = 0;
    column = c;
    x = column * Car.screenWidth * 0.25 + imagePadding;
    y = -imageHeight;
  }
}

class TestCar extends Car {
  double get imageWidth => Car.width;
  double get imageHeight => Car.height;
  double get imagePadding => Car.padding;

  TestCar(double x, double y) {
    this.x = x;
    this.y = y;
    asset = 'asset/image/dead.png';
  }

  @override
  bool checkCollision(UserCar userCar) => false;
}