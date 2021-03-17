import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/atm_game/atm_operation.dart';
import 'package:fortuna/templates/gamepage.dart';

class Atm extends StatefulWidget {
  @override
  _AtmState createState() => _AtmState();
}

class _AtmState extends State<Atm> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      GamePage.of(context).finishGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Align(
          alignment:
              Alignment.lerp(Alignment.topCenter, Alignment.center, 0.36),
          child: Container(
            child: Image.asset(
              "asset/image/module7_atm.png",
              width: size.width * 0.9,
              height: size.height * 0.65,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Align(
          alignment:
              Alignment.lerp(Alignment.topCenter, Alignment.center, 0.19),
          child: AutoSizeText(
            'CAJERO\nAUTOMATICO',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        AtmOperation()
      ],
    );
  }
}
