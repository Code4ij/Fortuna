import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/pressure_game/complicated_methods.dart';
import 'package:fortuna/pressure_game/fruit_image.dart';

class DropFruits extends StatefulWidget {
  List<String> allFruits;
  final Size gameSize;
  final Size size;
  int nextSpawnTime = DateTime.now().millisecondsSinceEpoch;
  Function updateScore;
  int count = 0;
  static Map<int, FruitImage> fruitMap = Map();

  DropFruits({Key key, this.gameSize, this.size}) : super(key: key);

  @override
  _DropFruitsState createState() => _DropFruitsState();
}

class _DropFruitsState extends State<DropFruits>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.allFruits = ['fruit1', 'fruit2', 'fruit3', 'fruit4', 'fruit5'];

    // Initialize Animation Controller
    _controller = null;
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() {
            animationListener();
          });
    _controller.repeat();
    ComplicatedFunctions.myFunction = stopController;
  }

  void stopController() {
    _controller.stop();
  }

  void animationListener() {
    int curTime = DateTime.now().millisecondsSinceEpoch;
    if (curTime >= widget.nextSpawnTime && widget.count < 30) {
      spawnFruit();
      widget.nextSpawnTime = curTime + Random().nextInt(2000) + 500;
    }

    for (FruitImage fruit in DropFruits.fruitMap.values) {
      fruit.imagePosY += 1;
      if (fruit.imagePosY >= (widget.gameSize.height * 0.58 - fruit.height)) {
        if(fruit.isAlive) {
          fruit.isAlive = false;
          double fruitPos = fruit.imagePosX + widget.gameSize.width / 10;
          if (fruitPos < widget.gameSize.width / 3) {
            widget.updateScore(1);
          } else if (fruitPos >= widget.gameSize.width / 3 &&
              fruitPos < widget.gameSize.width * 2 / 3) {
            widget.updateScore(2);
          } else if (fruitPos >= widget.gameSize.width * 2 / 3) {
            widget.updateScore(3);
          }
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void spawnFruit() {
    int index = Random().nextInt(widget.allFruits.length);
    FruitImage ff = generateFruit(widget.allFruits[index]);
    DropFruits.fruitMap[widget.count] = ff;
    widget.count++;
  }

  FruitImage generateFruit(String imageName) {
    return FruitImage(
        image: imageName,
        imagePosX: generateX(),
        imagePosY: 0,
        gameSize: widget.gameSize,
        speed: Random().nextDouble() + 1,
        id: widget.count
    );
  }

  double generateX() {
    double a = widget.gameSize.width * (4 / 5);
    double b = widget.gameSize.width / 5;
    return (Random().nextDouble() * a) + b / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: getAllFruits(),
    );
  }

  List<Widget> getAllFruits() {
    List<Widget> curList = List();
    for (FruitImage fruitImage in DropFruits.fruitMap.values) {
      if (fruitImage.isAlive) {
        curList.add(DraggableFruit(
          gameSize: widget.gameSize,
          size: widget.size,
          fruitImage: fruitImage,
          id: fruitImage.id,
        ));
      }
    }
    return curList;
  }
}

class DraggableFruit extends StatefulWidget {
  final FruitImage fruitImage;
  final Size size;
  final Size gameSize;
  static int index = -1;
  final int id;

  DraggableFruit({Key key, this.fruitImage, this.size, this.gameSize, this.id})
      : super(key: key);

  @override
  _DraggableFruitState createState() => _DraggableFruitState();
}

class _DraggableFruitState extends State<DraggableFruit> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.fruitImage.imagePosX,
      top: widget.fruitImage.imagePosY,
      child: GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onHorizontalDragStart: (details) {
          if(DraggableFruit.index == -1) {
            DraggableFruit.index = widget.fruitImage.id;
            print('Starting id: ${widget.id} static index: ${DraggableFruit.index}');
          }
        },
        onHorizontalDragEnd: (data) {
          DraggableFruit.index = -1;
          print('End called');
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (details.globalPosition.dx <=
                  (widget.size.width - widget.gameSize.width) / 2 ||
              details.globalPosition.dx >= widget.gameSize.width * (4 / 5)) {
            return;
          }
          DropFruits.fruitMap[DraggableFruit.index].imagePosX = details.globalPosition.dx;
        },
        child: Container(
          child: Image.asset(
            "asset/image/${widget.fruitImage.image}.png",
            fit: BoxFit.contain,
            width: widget.fruitImage.width,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

