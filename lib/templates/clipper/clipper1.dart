import 'dart:math';

import 'package:flutter/material.dart';

class Clipper1 extends CustomClipper<Path> {

  final Size screenSize;
  final double start;

  Clipper1(this.screenSize, this.height, this.start);
  final double height;

  @override
  Path getClip(Size size) {
    final path = Path();

    double hf = start * screenSize.width / tan(radians(68));

    path.moveTo(screenSize.width * start, 0);
    path.lineTo(screenSize.width * start, screenSize.height * height - hf);
    path.lineTo(screenSize.width, screenSize.height*height - (screenSize.width * tan(radians(22))));

    path.lineTo(screenSize.width, 0);
    path.lineTo(screenSize.width * start, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}


double radians(double degree) => degree * pi / 180;