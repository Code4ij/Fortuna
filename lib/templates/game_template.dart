import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/templates/WinPage.dart';
import 'package:fortuna/templates/description.dart';
import 'package:fortuna/templates/explaination.dart';
import 'package:fortuna/templates/gamepage.dart';
import 'package:fortuna/templates/namepage.dart';
import 'package:fortuna/templates/next_button.dart';
import 'package:fortuna/templates/resultpage.dart';

class GameTemplate extends StatefulWidget {
  final int index;
  final Color color;
  final String name;
  final String title;
  final String icon;
  final String image;
  final String data;
  final String discription;
  final Widget gamemode;

  const GameTemplate(
      {Key key,
      @required this.color,
      @required this.name,
      @required this.title,
      @required this.icon,
      @required this.image,
      @required this.data,
      @required this.discription,
      @required this.gamemode,
      @required this.index})
      : super(key: key);

  @override
  GameTemplateState createState() => GameTemplateState();

  static GameTemplateState of(BuildContext context) =>
      context.findAncestorStateOfType<GameTemplateState>();
}

class GameTemplateState extends State<GameTemplate> {
  final _controller = PageController(initialPage: 0);
  final assetsAudioPlayer = AssetsAudioPlayer();
  int pageIndex = 0;
  int trophyIndex = 0;
  // ignore: non_constant_identifier_names
  bool gameFlag = false;

  @override
  void initState() {
    // TODO: implement initState
    assetsAudioPlayer.open(
      Audio("asset/audio/module${widget.index}.mp3"), volume: 0.7
    );
    NextButton.prevPage = prevPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Index $pageIndex');
    return Scaffold(
      resizeToAvoidBottomInset: widget.index == 0 || widget.index == 3 ? true : false,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          NamePage(
            color: widget.color,
            icon: widget.icon,
            name: widget.name,
            image: widget.image,
            jumpPage: JumpPage,
            onWillPop: onWillPop,
            assetsAudioPlayer: assetsAudioPlayer,
          ),
          DescriptionPage(
            color: widget.color,
            icon: widget.icon,
            title: widget.title,
            data: widget.discription,
            image: widget.image,
            jumpPage: JumpPage,
            onWillPop: onWillPop,
            assetsAudioPlayer: assetsAudioPlayer,
          ),
          ExplainationPage(
            color: widget.color,
            icon: widget.icon,
            title: widget.title,
            data: widget.discription,
            image: widget.image,
            jumpPage: JumpPage,
            onWillPop: onWillPop,
            index: widget.index,
          ),
          GamePage(
            color: widget.color,
            icon: widget.icon,
            image: widget.image,
            game: widget.gamemode,
            jumpPage: JumpPage,
            onWillPop: onWillPop,
          ),
          WinPage(
            color: widget.color,
            icon: widget.icon,
            trophyindex: trophyIndex,
            data: widget.discription,
            image: widget.image,
            jumpPage: JumpPage,
            onWillPop: onWillPop,
            notLast: widget.data != null && widget.data.length > 0
          ),
          if(widget.data != null && widget.data.length > 0)
            ResultPage(
            color: widget.color,
            icon: widget.icon,
            data: widget.data,
            onWillPop: onWillPop,
          )
        ],
      ),
    );
  }

  void prevPage() {
    setState(() {
      pageIndex-=1;
      _controller.previousPage(
          duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  // ignore: non_constant_identifier_names
  void JumpPage() {
    setState(() {
      pageIndex += 1;
      _controller.nextPage(
          duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  // ignore: non_constant_identifier_names
  void SetFlag() => gameFlag = true;

  Future<bool> onWillPop() {
    if(pageIndex < 2)
      assetsAudioPlayer.pause();
    return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('¿Estas seguro?', textAlign: TextAlign.center,),
            content: Text('¿Quieres salir del Módulo?', textAlign: TextAlign.center),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if(pageIndex < 2)
                    assetsAudioPlayer.play();
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('SI'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }
}
