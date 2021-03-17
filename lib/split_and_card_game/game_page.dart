import 'package:flutter/material.dart';
import 'package:fortuna/split_and_card_game/calculation_game.dart';
import 'package:fortuna/split_and_card_game/card_game.dart';

class SplitCardGame extends StatefulWidget {
  @override
  _SplitCardGameState createState() => _SplitCardGameState();
}

class _SplitCardGameState extends State<SplitCardGame> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (page == 0) {
      return Stack(
        children: [
          Align(
              alignment: Alignment.lerp(
                  Alignment.topCenter, Alignment.bottomCenter, .15),
              child: getSingleButton(
                  size: size,
                  text: 'Habilidad',
                  image: 'asset/Module3/game_button.png',
                  function: () {
                    setState(() {
                      page = 1;
                    });
                  })),
          Align(
              alignment: Alignment.lerp(
                  Alignment.topCenter, Alignment.bottomCenter, .60),
              child: getSingleButton(
                  size: size,
                  text: 'Herramienta',
                  image: 'asset/Module3/cal_button.png',
                  function: () {
                    setState(() {
                      page = 2;
                    });
                  }))
        ],
      );
    }
    if (page == 2) {
      return CalculationGame(
        function: () {
          setState(() {
            page = 0;
          });
        },
      );
    }
    if (page == 1) {
      return CardGame(
        function: () {
          setState(() {
            page = 0;
          });
        },
      );
    }
  }

  Widget getSingleButton(
      {Size size, String text, String image, Function function}) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: size.height * 0.15,
              width: size.height * 0.15,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
