import 'package:flutter/material.dart';

class FruitImage {
  final String image;
  double imagePosX;
  double imagePosY;
  double width;
  double height;
  final Size gameSize;
  bool isAlive = true;
  int id;
  final double speed; // Should be between 1 and 2

  FruitImage(
      {@required this.image,
      @required this.imagePosX,
      @required this.imagePosY,
      @required this.gameSize,
      @required this.speed,
      @required this.id}) {
    this.height = this.width = gameSize.width / 5;
  }
}
