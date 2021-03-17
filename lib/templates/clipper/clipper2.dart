import 'dart:math';

import 'package:flutter/material.dart';

class Clipper2 extends CustomClipper<Path> {

  final Size screenSize;

  Clipper2(this.screenSize, this.height);
  final double height;

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, screenSize.height * height);
    path.lineTo(screenSize.width, screenSize.height * height + (screenSize.width * tan(radians(40))));
    path.lineTo(screenSize.width, screenSize.height);
    path.lineTo(0, screenSize.height);
    path.lineTo(0, screenSize.height * height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}


double radians(double degree) => degree * pi / 180;