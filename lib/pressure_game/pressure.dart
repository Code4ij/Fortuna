import 'package:flutter/material.dart';
import 'package:fortuna/pressure_game/fruits.dart';

class Pressure extends StatefulWidget {
  final Size gameSize;
  int scoreA = 0;
  int scoreB = 0;
  int scoreC = 0;
  final DropFruits dropFruits;
  final Function gameOver;

  Pressure({Key key, this.gameSize, this.dropFruits, this.gameOver}) : super(key: key);

  @override
  _PressureState createState() => _PressureState();
}

class _PressureState extends State<Pressure> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.dropFruits.updateScore = updateScore;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.gameSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: widget.gameSize.width / 4,
            height: widget.gameSize.height * 0.05,
            decoration: BoxDecoration(
              color: scoreColors[widget.scoreA ~/ 100],
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.all(
                  Radius.circular(widget.gameSize.height * 0.05)),
            ),
            child: Center(
              child: Text(
                widget.scoreA.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: widget.gameSize.width / 4,
            height: widget.gameSize.height * 0.05,
            decoration: BoxDecoration(
              color: scoreColors[widget.scoreB ~/ 100],
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.all(
                  Radius.circular(widget.gameSize.height * 0.05)),
            ),
            child: Center(
              child: Text(
                widget.scoreB.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: widget.gameSize.width / 4,
            height: widget.gameSize.height * 0.05,
            decoration: BoxDecoration(
              color: scoreColors[widget.scoreC ~/ 100],
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.all(
                  Radius.circular(widget.gameSize.height * 0.05)),
            ),
            child: Center(
              child: Text(
                widget.scoreC.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateScore(int coocker) {
    if(coocker == 1) {
      widget.scoreA += 100;
    } else if (coocker == 2) {
      widget.scoreB += 100;
    } else if (coocker == 3) {
      widget.scoreC += 100;
    }
    if(widget.scoreA > 1000 || widget.scoreB > 1000 || widget.scoreC > 1000) {
      widget.gameOver();
    }
    setState(() {});
  }
}

List<Color> scoreColors= [
  Color(0xFF0047AB),
  Color(0xFF0047AB),
  Color(0xFF554A72),
  Color(0xFF74525D),
  Color(0xFF89574F),
  Color(0xFF995C44),
  Color(0xFFA55F3C),
  Color(0xFFBF5C2B),
  Color(0xFFC85325),
  Color(0xFFD5471D),
  Color(0xFFE63711),
  Color(0xFFFF0000),
];