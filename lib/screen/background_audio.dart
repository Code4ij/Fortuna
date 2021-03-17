import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:fortuna/common/prefs.dart';

class BackGroundAudio {
  double volume = 0.1 * Prefs().musicVolume;
  AssetsAudioPlayer _assetsAudioPlayer;
  StreamSubscription _streamSubscription;

  static final BackGroundAudio _singleton = BackGroundAudio._internal();

  factory BackGroundAudio() {
    if(_singleton._streamSubscription == null) {
      print("Start Listening...");
      _singleton._streamSubscription = Prefs().volumeStream.listen((event) {
        _singleton.changeVolume();
      });
    } else {
      print("Not Listening...");
    }
    return _singleton;
  }

  BackGroundAudio._internal();

  Future<void> setAudio(int index) async {
    Prefs().musicIndex = index;

    try {
      await _assetsAudioPlayer.stop();
      _assetsAudioPlayer = null;
    } catch(e) {
      print("Error in Setting: $e");
    }

    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    if(index == -1) {
      return;
    }

    await _assetsAudioPlayer.open(Audio("asset/audio/music/music$index.mpeg"), autoStart: false, volume: volume, showNotification: false, loopMode: LoopMode.single);
    _assetsAudioPlayer.play();
  }

  Future<void> startAudio() async {
    int index = Prefs().musicIndex;
    if(index == -1) {
      return;
    }

    _assetsAudioPlayer = null;
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    await _assetsAudioPlayer.open(Audio("asset/audio/music/music$index.mpeg"), autoStart: false, volume: volume, showNotification: false, loopMode: LoopMode.single);

    _assetsAudioPlayer.play();
  }

  Future<void> resumeAudio() async {
    if(Prefs().musicIndex == -1) {
      return;
    }

    try {
      _assetsAudioPlayer?.play();
    } catch(e) {
      print(e);
    }
  }

  Future<void> pauseAudio() async {
    if(Prefs().musicIndex == -1) {
      return;
    }

    try {
      _assetsAudioPlayer?.pause();
    } catch(e) {
      print(e);
    }
  }

  Future<void> stopAudio() async {
    await _streamSubscription.cancel();
    _streamSubscription = null;
    if(Prefs().musicIndex == -1) {
      return;
    }

    try {
      await _assetsAudioPlayer?.stop();
      _assetsAudioPlayer = null;
    } catch(e) {
      print(e);
    }
  }

  void changeVolume() {
    if(_assetsAudioPlayer != null) {
      double volumeScale = Prefs().musicVolume;
      _assetsAudioPlayer.setVolume(0.1 * volumeScale);
    }
  }
}