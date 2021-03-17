import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/basket_game/basket.dart';
import 'package:fortuna/basket_game/collection_stack.dart';
import 'package:fortuna/basket_game/items.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/templates/game_template.dart';
import 'package:fortuna/templates/gamepage.dart';

// ignore: must_be_immutable
class BasketScreen extends StatefulWidget {
  final Size size;
  Size gameSize;
  bool isStarted = false;
  String msg = "Toque para comenzar.\nLa comida se consumirá cada 10 segundos.";

  BasketScreen({Key key, this.size}) {
    gameSize = Size(this.size.width, this.size.height * 0.7);
  }

  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  DragBasket _dragBasket;
  DropItems _dropItems;
  CollectionStack _collectionStack;
  int retries = 0;

  @override
  void initState() {
    // TODO: implement initState
    print("Basket Game is Started or What??");
    super.initState();
    retryGame();
  }

  @override
  Widget build(BuildContext context) {
    return getGameState();
  }

  void retryGame() {
    _dragBasket = DragBasket(gameSize: widget.gameSize);
    _dropItems = DropItems(
      gameSize: widget.gameSize,
      dragBasket: _dragBasket,
    );
    _collectionStack = CollectionStack(
      gameSize: widget.gameSize,
      dropItems: _dropItems,
      updateState: updateState,
    );
  }

  void updateState({int i = 0}) {
    if (i == 0) {
      widget.msg = "Toque para comenzar.\nLa comida se consumirá cada 10 segundos.";
    } else if (i == 1) {
      retries++;
      widget.msg =
          "Toque para reintentar.\nPrimero debes recolectar 15 artículos necesarios, luego ir a por artículos de lujo.\nLa comida se consumirá cada 10 segundos.";
    } else if (i == 2) {
      // TODO: Update Score
      updateScore();
      widget.msg = "¡Felicidades!\nToque para jugar de nuevo";
    } else if (i == 3) {
      retries++;
      widget.msg =
      "Toque para reintentar.\nNo tienes suficiente comida.\nLa comida se consumirá cada 10 segundos.";
    } else if (i == 4) {
      retries++;
      widget.msg =
      "Toque para reintentar.\nDebes recolectar al menos 15 artículos necesarios y al menos 3 artículos de lujo.\nLa comida se consumirá cada 10 segundos.";
    }
    setState(() {
      this.widget.isStarted = false;
    });
  }

  void updateScore() {
    final prefs = Prefs();
    Map score = prefs.data[9];
    print(score);

    int roundScore = retries < 1
        ? 20
        : retries < 2
            ? 15
            : 10;
    int curScore = score['total'];

    score['total'] = max(curScore, roundScore);
    int total = score['total'];
    print(score);
    Prefs().updateScore(9, score);
    GameTemplate.of(context).trophyIndex = total >= 20
        ? 0
        : total >= 15
            ? 1
            : 2;
    GamePage.of(context).finishGame();
  }

  void startGame() {
    setState(() {
      this.widget.isStarted = true;
    });
    retryGame();
  }

  Widget getGameState() {
    if (widget.isStarted) {
      _dropItems.shouldStart = true;
    }
    return widget.isStarted
        ? Container(
            height: widget.gameSize.height * 1.1,
            width: widget.gameSize.width,
            child: Stack(
              children: [_dropItems, _dragBasket, _collectionStack],
            ),
          )
        : Stack(
            children: [
              Container(
                height: widget.gameSize.height * 1.1,
                width: widget.gameSize.width,
                child: Stack(
                  children: [_dragBasket, _collectionStack],
                ),
              ),
              GestureDetector(
                  child: Container(
                    width: widget.size.width,
                    height: widget.size.height,
                    color: Colors.white.withOpacity(0.5),
                    child: Align(
                      alignment: Alignment(0, -0.2),
                      child: Text(
                        widget.msg,
                        style: TextStyle(fontSize: widget.size.height * 0.02),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: startGame),
            ],
          );
  }
}
