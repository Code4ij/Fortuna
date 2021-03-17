import 'dart:math';

import 'package:flutter/material.dart';

class Clipper3 extends CustomClipper<Path> {

  final Size screenSize;
  final double start;
  final bool moveDown;

  Clipper3(this.screenSize, this.height, this.start, {this.moveDown = true});
  final double height;

  @override
  Path getClip(Size size) {
    final path = Path();
    if(moveDown) {
      double hf = start * screenSize.width / tan(radians(22));
      path.moveTo(screenSize.width * start, screenSize.height * height + hf);
      path.lineTo(screenSize.width, hf + screenSize.height*height - (screenSize.width * tan(radians(22))));
      path.lineTo(screenSize.width, screenSize.height);
      path.lineTo(screenSize.width * start, screenSize.height);
      path.lineTo(screenSize.width * start, screenSize.height * height);
    } else {
      double hf = start * screenSize.width / tan(radians(68));
      path.moveTo(screenSize.width * start, screenSize.height * height - hf);
      path.lineTo(screenSize.width, screenSize.height*height - (screenSize.width * tan(radians(22))));
      path.lineTo(screenSize.width, screenSize.height*(height + 0.1) - (screenSize.width * tan(radians(22))));
      path.lineTo(screenSize.width * start, screenSize.height * (height + 0.1)-hf);
      path.lineTo(screenSize.width * start, screenSize.height * height-hf);
    }


    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}


double radians(double degree) => degree * pi / 180;