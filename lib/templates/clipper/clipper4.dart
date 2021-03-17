import 'dart:math';

import 'package:flutter/material.dart';

class Clipper4 extends CustomClipper<Path> {

  final Size screenSize;

  Clipper4(this.screenSize, this.height, this.end);
  final double height;
  final double end;

  @override
  Path getClip(Size size) {
    final path = Path();
    double dh = tan(radians(22)) * (screenSize.width * (0.45 - end));
    path.moveTo(0, screenSize.height * height + dh);
    double th = screenSize.height * height + (end * screenSize.width * tan(radians(40))) + dh;
    path.lineTo(screenSize.width * end, th);
    path.lineTo(0, th + screenSize.width * end * tan(radians(22)));
    path.lineTo(0, screenSize.height * height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}


double radians(double degree) => degree * pi / 180;