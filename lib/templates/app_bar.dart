import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/common/data.dart';
import 'package:fortuna/screen/background_audio.dart';

class CustomAppBar extends StatefulWidget {
  final Color color;
  final String icon;
  final bool isMusicEnabled;

  CustomAppBar(
      {Key key,
      @required this.color,
      @required this.icon,
      this.isMusicEnabled = true})
      : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  static bool volumePage = false;
  int musicIndex;
  bool isMusicOn;
  double musicVolume;

  @override
  void initState() {
    musicIndex = Prefs().musicIndex;
    musicVolume = Prefs().musicVolume;
    if (musicIndex == -1)
      isMusicOn = false;
    else
      isMusicOn = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.115,
      width: size.width,
      color: widget.color,
      child: Container(
        height: size.height * 0.115,
        width: size.width,
        color: Colors.black.withOpacity(volumePage ? 0.5 : 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: volumePage ? getSound() : getIcon(),
              ),
              Divider(
                color: Colors.white,
                thickness: 2,
              )
            ]),
      ),
    );
  }

  Widget getIcon() {
    final size = MediaQuery.of(context).size;
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.only(left: 18),
            iconSize: size.height * 0.04,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              buttonClick();
              Navigator.of(context).pop();
            },
          ),
          Image.asset(widget.icon),
          volumeIcon()
        ],
      ),
    ));
  }

  Widget getSound() {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: size.height * 0.095,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isMusicOn && widget.isMusicEnabled)
                  Container(
                    height: size.height * 0.045,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          iconSize: size.height * 0.02,
                          onPressed: () async {
                            musicIndex = (musicIndex - 1) % 12;
                            await BackGroundAudio().setAudio(musicIndex);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                        CustomSelector(
                          size: size,
                          index: musicIndex,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          iconSize: size.height * 0.02,
                          onPressed: () async {
                            musicIndex = (musicIndex + 1) % 12;
                            await BackGroundAudio().setAudio(musicIndex);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                Container(
                  height: size.height * 0.045,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.isMusicEnabled)
                        Switch(
                          activeColor: Colors.blue,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          value: isMusicOn,
                          onChanged: (val) async {
                            if (val == true && musicIndex == -1) musicIndex = 0;
                            setState(() {
                              isMusicOn = val;
                            });
                            if (val == false) {
                              await BackGroundAudio().setAudio(-1);
                            } else {
                              await BackGroundAudio().setAudio(musicIndex);
                            }
                          },
                        ),
                      Slider(
                        activeColor: Colors.blue,
                        inactiveColor: Colors.grey,
                        value: musicVolume,
                        min: 0,
                        max: 1,
                        divisions: 20,
                        onChanged: (val) {
                          setState(() {
                            Prefs().musicVolume = val;
                            musicVolume = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          volumeIcon()
        ],
      ),
    );
  }

  Widget volumeIcon() {
    final size = MediaQuery.of(context).size;
    return IconButton(
      padding: EdgeInsets.only(right: 18),
      icon: Icon(
        volumePage ? Icons.cancel : Icons.volume_up_rounded,
        color: Colors.white,
      ),
      iconSize: size.height * 0.04,
      onPressed: () {
        setState(() {
          volumePage = !volumePage;
        });
      },
    );
  }
}

class CustomSelector extends StatefulWidget {
  final Size size;
  final int index;

  const CustomSelector({Key key, this.size, this.index}) : super(key: key);

  @override
  _CustomSelectorState createState() => _CustomSelectorState();
}

class _CustomSelectorState extends State<CustomSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width * 0.35,
      child: Center(
          child: AutoSizeText(
        "Canción de fondo ${widget.index}",
        style: TextStyle(color: Colors.white, fontSize: 15),
      )),
    );
  }
}
