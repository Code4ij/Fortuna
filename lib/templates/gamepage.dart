import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/patikda.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/screen/module_controller.dart';
import 'package:fortuna/templates/clip_rect.dart';
import 'package:fortuna/templates/game_template.dart';
import 'package:fortuna/templates/image_button.dart';
import 'package:fortuna/templates/next_button.dart';

import 'app_bar.dart';

class GamePage extends StatefulWidget {
  final String image;
  final String icon;
  final Color color;
  final Widget game;
  final Function jumpPage;
  final Function onWillPop;

  const GamePage(
      {Key key,
      @required this.icon,
      @required this.color,
      @required this.image,
      @required this.game,
      this.jumpPage,
      this.onWillPop})
      : super(key: key);

  static GamePageState of(BuildContext context) =>
      context.findAncestorStateOfType<GamePageState>();

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  bool gameFinished = false;
  bool showButtons = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final id = GameTemplate.of(context).widget.index;
    print("Id: $id");
    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: Column(
        children: [
          CustomAppBar(color: widget.color, icon: widget.icon, isMusicEnabled: id == 1 ? false : true,),
          Expanded(
            child: Stack(
              children: [
                ClipPath(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new AssetImage(widget.image),
                        )),
                      ),
                      Container(
                        color: widget.color.withOpacity(0.7),
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ],
                  ),
                  clipper: CustomRect(),
                ),
                widget.game,
                ImageButton(size, size.height * 0.755, showFAQ: false),
                if (showButtons)
                  NextButton(
                    jumpPage: () {
                      int index = ModuleController.of(context).index;
                      print('Game index: $index prefsIndex: ${Prefs().activeIndex}');
                      Prefs().activeIndex = index + 1;
                      widget.jumpPage();
                    },
                    color: widget.color, nextAvailable: gameFinished || Prefs().activeIndex > ModuleController.of(context).index,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void finishGame() {
    print("Finish Called");
    setState(() {
      gameFinished = true;
    });
    // widget.jumpPage();
  }

  void setShowButton(bool val) {
    setState(() {
      showButtons = val;
    });
    // widget.jumpPage();
  }
}
