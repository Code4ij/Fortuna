import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/screen/module_controller.dart';
import 'package:fortuna/templates/Certificate.dart';
import 'package:fortuna/templates/clip_rect.dart';
import 'package:fortuna/templates/image_button.dart';

import 'next_button.dart';

class ResultPage extends StatelessWidget {
  final String data;
  final String icon;
  final Color color;
  final Function onWillPop;

  const ResultPage(
      {Key key,
      @required this.data,
      @required this.icon,
      @required this.color,
      this.onWillPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ImageButton(size, size.height * 0.87),
              ClipPath(
                child: Container(
                  color: color,
                ),
                clipper: CustomRect(design_flag: true),
              ),
              Align(
                alignment:
                    Alignment(0, 0.36),
                child: Container(
                  width: size.width / 1.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.07),
                        child: Center(
                          child: Image.asset(
                            icon,
                            width: size.width / 3,
                            height: size.height / 5,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      data != null
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * 0.0375,
                                  right: size.width * 0.03,
                                  left: size.width * 0.03),
                              child: Center(
                                child: AutoSizeText(
                                  '$data',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              NextButton(
                color: color,
                jumpPage: () {
                  int index = ModuleController.of(context).index;
                  if (index >= 10) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Certificate()));
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomIcon extends CustomClipper<Path> {
  // ignore: non_constant_identifier_names
  final bool design_flag;

  // ignore: non_constant_identifier_names
  CustomIcon({this.design_flag = false});

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(5, 0);
    path.lineTo(size.width, size.height / 2);

    path.lineTo(5, size.height);
    path.lineTo(0, size.height - 5);
    path.lineTo(size.width - 5, size.height / 2);
    path.lineTo(0, 5);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
