import 'package:flutter/material.dart';

class ItemImage {
  final String image;
  final double imagePosX;
  double imagePosY;
  bool isNeeded = true;
  double width;
  double height;
  final Size gameSize;
  final double speed = 1.5; // Should be between 1 and 2

  ItemImage(
      {this.image, this.imagePosX, this.imagePosY, this.gameSize}) {
    if (image == "watch" || image == "shoes") {
      this.isNeeded = false;
    }
    this.height = gameSize.height / 20;
    switch (image) {
      case "watch":
        this.width = gameSize.width / 12;
        break;
      case "shoes":
        this.width = gameSize.width / 6;
        break;
      case "milk":
        this.width = gameSize.width / 10;
        break;
      case "basket_apple":
        this.width = gameSize.width / 8;
        break;
      case "bread":
        this.width = gameSize.width / 8;
        break;
      case "water":
        this.width = gameSize.width / 14;
        break;
    }
  }
}
