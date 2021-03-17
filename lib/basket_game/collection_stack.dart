import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/basket_game/item_image.dart';
import 'package:fortuna/basket_game/items.dart';

// ignore: must_be_immutable
class CollectionStack extends StatefulWidget {
  final DropItems dropItems;
  List<ItemImage> collectedItems = List();
  int basketCapacity = 20;
  int necessaryItems = 0;
  int luxuryItems = 0;
  final Function updateState;
  bool isFirstItem = true;

  final Size gameSize;

  CollectionStack({Key key, this.gameSize, this.dropItems, this.updateState}) : super(key: key);

  @override
  _CollectionStackState createState() => _CollectionStackState();
}

class _CollectionStackState extends State<CollectionStack> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.dropItems.collectItem = collectItem;
    widget.dropItems.consumeItem = consumeFood;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.gameSize.height * 0.9,
      child: Container(
        width: widget.gameSize.width,
        height: widget.gameSize.height * 0.12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText("Capacidad de la cesta: ${widget.basketCapacity}", style: TextStyle(fontSize: 16),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if(widget.necessaryItems < 15)
                  AnimatedStack(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("asset/image/water.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                        Image.asset("asset/image/bread.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                        Image.asset("asset/image/basket_apple.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                        Image.asset("asset/image/milk.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                        AutoSizeText(" : ${widget.necessaryItems}", style: TextStyle(fontSize: 16, color: Colors.white),),
                      ],
                    ),
                  ),
                if(widget.necessaryItems >= 15)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("asset/image/water.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                      Image.asset("asset/image/bread.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                      Image.asset("asset/image/basket_apple.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                      Image.asset("asset/image/milk.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                      AutoSizeText(" : ${widget.necessaryItems}", style: TextStyle(fontSize: 16),),
                    ],
                  ),
                if(widget.necessaryItems < 15)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("asset/image/shoes.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                      Image.asset("asset/image/watch.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                      AutoSizeText(" : ${widget.luxuryItems}", style: TextStyle(fontSize: 16),),
                    ],
                  ),
                if(widget.necessaryItems >= 15)
                  AnimatedStack(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("asset/image/shoes.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                        Image.asset("asset/image/watch.png", height: widget.gameSize.height * 0.05, fit: BoxFit.contain,),
                        AutoSizeText(" : ${widget.luxuryItems}", style: TextStyle(fontSize: 16, color: Colors.white),),
                      ],
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getAllCollectedItems() {
    List<Widget> collection = List();
    for (ItemImage item in widget.collectedItems) {
      Widget itemBox = Container(
        width: widget.gameSize.width / 4,
        height: widget.gameSize.height * 0.07,
        child: Image.asset(
          "asset/image/${item.image}.png",
        ),
      );
      collection.add(itemBox);
    }
    return collection;
  }

  void collectItem(ItemImage item) {
    if(mounted) {
      setState(() {
        widget.basketCapacity--;
        widget.isFirstItem = false;
        if(item.isNeeded) {
          widget.necessaryItems++;
        } else {
          if(widget.necessaryItems < 15) {
            widget.dropItems.controller.stop();
            widget.dropItems.timer.cancel();
            widget.updateState(i: 1);
          } else {
            widget.luxuryItems++;
          }
        }

        if(widget.basketCapacity == 0 && (widget.necessaryItems < 15 || widget.luxuryItems < 3)) {
          widget.dropItems.controller.stop();
          widget.dropItems.timer.cancel();
          widget.updateState(i: 4);
        }
        else if(widget.basketCapacity == 0) {
          widget.dropItems.controller.stop();
          widget.dropItems.timer.cancel();
          widget.updateState(i: 2);
        }
      });
    }
  }

  void consumeFood() {
    if(mounted) {
      if(widget.necessaryItems == 0) {
        if(!widget.isFirstItem) {
          widget.dropItems.controller.stop();
          widget.dropItems.timer.cancel();
          widget.updateState(i: 3);
        }
      } else {
        widget.necessaryItems--;
        widget.basketCapacity++;
      }
      setState(() {});
    }
  }
}

class AnimatedStack extends StatefulWidget {
  final Widget child;

  const AnimatedStack({Key key, this.child}) : super(key: key);
  @override
  _AnimatedStackState createState() => _AnimatedStackState();
}

class _AnimatedStackState extends State<AnimatedStack> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: Next Button Glow
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 3.0).animate(_animationController)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.stop();
    _animation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
              color: Colors.black,
              blurRadius: _animation.value,
              spreadRadius: _animation.value)
        ],
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: widget.child,
      ),
    );
  }
}
