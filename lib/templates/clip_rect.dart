import 'package:flutter/material.dart';

class CustomRect extends CustomClipper<Path> {

  // ignore: non_constant_identifier_names
  final bool design_flag;

  // ignore: non_constant_identifier_names
  CustomRect({this.design_flag = false});
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);

    if (design_flag){
      path.lineTo(size.width, size.height * 0.984);
      path.lineTo(0, size.height * 0.584);
      path.lineTo(0, size.height * 0.589);
      path.lineTo(size.width, size.height * 0.989);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height * 1.8 / 3);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

}