import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DragBasket extends StatefulWidget {
  Size gameSize;
  double basketPosY;

  DragBasket({Key key, this.gameSize}) {
    basketPosY = gameSize.width * (1 / 2 - 1 / 6);
  }

  @override
  _DragBasketState createState() => _DragBasketState();
}

class _DragBasketState extends State<DragBasket> {
  void _onBasketDragUpdate(DragUpdateDetails details) {
    if (details.globalPosition.dx <= -1 * (widget.gameSize.width / 6) ||
        details.globalPosition.dx >= widget.gameSize.width) {
      return;
    }
    setState(() {
      widget.basketPosY = details.globalPosition.dx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.gameSize.height * 0.65,
      left: widget.basketPosY - widget.gameSize.width / 6,
      child: GestureDetector(
        onHorizontalDragUpdate: _onBasketDragUpdate,
        child: Container(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'asset/image/basket.png',
            alignment: Alignment.topCenter,
            fit: BoxFit.contain,
            width: widget.gameSize.width / 3,
            height: widget.gameSize.height * 0.3,
          ),
        ),
      ),
    );
  }
}
