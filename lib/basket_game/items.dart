import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fortuna/basket_game/basket.dart';
import 'package:fortuna/basket_game/item_image.dart';

// ignore: must_be_immutable
class DropItems extends StatefulWidget {
  List<String> allImages = [
    "basket_apple",
    "milk",
    "shoes",
    "watch",
    "bread",
    "water",
  ];
  final Size gameSize;
  List<ItemImage> items = List();
  int nextSpawnTime = DateTime.now().millisecondsSinceEpoch;
  Function collectItem;
  Function consumeItem;
  final DragBasket dragBasket;
  AnimationController controller;
  Timer timer;
  DropItems({Key key, this.gameSize, this.dragBasket}) : super(key: key);
  bool shouldStart = false;

  @override
  _DropItemsState createState() => _DropItemsState();
}

class _DropItemsState extends State<DropItems>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller = AnimationController(
        duration: Duration(milliseconds: 2500), vsync: this)
      ..addListener(() {
        if(widget.shouldStart) {
          widget.items.clear();
          widget.shouldStart = false;
        }
        int curTime = DateTime.now().millisecondsSinceEpoch;
        if (curTime >= widget.nextSpawnTime) {
          spawnItems();
          widget.nextSpawnTime = curTime + Random().nextInt(1300) + 400;
        }
        List removable = List();
        for (ItemImage item in widget.items) {
          item.imagePosY += item.speed;
          if (item.imagePosY >= widget.gameSize.height * 0.7)
            removable.add(item);
        }
        for (ItemImage removableItem in removable) {
          removeItem(removableItem);
          double itemPos = (removableItem.imagePosX + removableItem.width / 2);
          if (itemPos >=
                  (widget.dragBasket.basketPosY - widget.gameSize.width / 6) &&
              itemPos <=
                  widget.dragBasket.basketPosY + widget.gameSize.width / 6)
            widget.collectItem(removableItem);
        }
        removable.clear();
        if (mounted) setState(() {});
      });

    widget.timer = Timer.periodic(Duration(seconds: 10), (timer) {
      widget.consumeItem();
    });
    widget.controller.repeat();
  }


  void spawnItems() {
    int n = Random().nextInt(widget.allImages.length);
    double pos = (Random().nextDouble() * (widget.gameSize.width * 0.8)) +
        widget.gameSize.width * 0.1;
    double speed = (Random().nextDouble()) + 1;
    ItemImage itemImage = ItemImage(
        image: widget.allImages[n],
        imagePosX: pos,
        imagePosY: 0,
        gameSize: widget.gameSize,);
    widget.items.add(itemImage);
  }

  void removeItem(ItemImage item) {
    widget.items.remove(item);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: getListOfItems(),
    );
  }

  List<Widget> getListOfItems() {
    List<Widget> allItems = List();
    for (var item in widget.items) {
      Widget dropItem = Positioned(
        left: item.imagePosX,
        top: item.imagePosY,
        child: Container(
          child: Image.asset(
            "asset/image/${item.image}.png",
            fit: BoxFit.contain,
            width: item.width,
          ),
        ),
      );
      allItems.add(dropItem);
    }
    return allItems;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.controller.dispose();
    super.dispose();
  }
}
