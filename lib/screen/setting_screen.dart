import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/common/data.dart';
import 'package:fortuna/models/user_model.dart';
import 'package:fortuna/screen/background_audio.dart';
import 'package:fortuna/screen/form_glow_button.dart';
import 'package:fortuna/screen/login_screen.dart';
import 'package:fortuna/screen/module_screen.dart';
import 'package:fortuna/screen/module_screen1.dart';
import 'package:fortuna/services/user_service.dart';
import 'package:fortuna/templates/clip_rect.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  File imageFile;
  Color color = Prefs().color;
  bool isLoading = false;
  final picker = ImagePicker();

  bool isMusicOn;
  int musicIndex;
  double musicVolume;

  static const List<Color> colors = [
    Color(0xff17467A),
    Color(0xffF8CD35),
    Color(0xff8EA5C2),
    Color(0xffF6892B),
    Color(0xff0072B2),
    Color(0xffFFF200)
  ];

  @override
  void initState() {
    // TODO: implement initState

    imageFile = File(Prefs().imageUrl);
    musicIndex = Prefs().musicIndex;
    musicVolume = Prefs().musicVolume;
    if(musicIndex == -1)
      isMusicOn = false;
    else
      isMusicOn = true;

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _showImageOption(Size size) {
    showModalBottomSheet(
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      builder: (builder) {
        return Container(
          height: size.height * 0.15,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 0.03,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await _selectImage(true);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: size.height * 0.07,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
//                      color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        size: size.height * 0.04,
                      ),
                    ),
                  ),
                  AutoSizeText("Cámara")
                ],
              ),
              SizedBox(
                width: size.width * 0.1,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await _selectImage(false);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: size.height * 0.07,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.photo_camera_back,
                        size: size.height * 0.04,
                      ),
                    ),
                  ),
                  AutoSizeText("Fotos"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectImage(bool isCamera) async {
    final status = await Permission.storage.request();
    print(status);
    if (status != PermissionStatus.granted) {
      UserService().flutterToast("Permiso denegado.");
      return;
    }

    final pickedFile = await picker.getImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      final File _image = File(pickedFile.path);

      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
      );

      if (croppedFile != null) {
        // TODO: Save Image Locally
        File profilePhoto = File(Prefs().imageUrl);
        await profilePhoto.delete();

        File newProfilePhoto = await croppedFile.copy(Prefs().imageUrl);
        imageFile = croppedFile;
        imageCache.clear();

        UserModel userModel =
            UserModel.fromJson(Prefs().getUserByIndex(Prefs().currentUser));
        userModel.shouldUpdate = true;
        userModel.profilePhoto = "";
        Prefs().setUserByIndex(Prefs().currentUser, userModel);
      } else {
        print('Not Cropped');
      }
    } else {
      print('No image selected.');
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final prefs = Prefs();
    String troffy;
    int totalScore = prefs.totalScore;
    if (totalScore > 0 && totalScore < 160)
      troffy = "platinum.png";
    else if (totalScore >= 160 && totalScore < 200)
      troffy = "gold.png";
    else if (totalScore >= 200) troffy = "diamond.png";

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            ClipPath(
              clipper: CustomRect(),
              child: Container(
                height: size.height,
                width: size.width,
                color: color,
              ),
            ),
            // Setting icon
            Align(
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.settings, size: size.height * 0.04,),
                  color: Colors.white,
                  onPressed: () async {
                    await BackGroundAudio().stopAudio();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ModuleScreen()));
                  },
                ),
                margin: EdgeInsets.all(20),
              ),
              alignment: Alignment.topCenter,
            ),

            // Profile Data
            Align(
              alignment: Alignment(0, -0.75),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _showImageOption(size);
                      },
                      child: Container(
                        width: size.width * 0.25,
                        height: size.width * 0.25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(imageFile),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: size.width * 0.4,
                          height: size.height * 0.03,
                          child: AutoSizeText(
                            Prefs().name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: size.height * 0.025),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        SizedBox(
                          width: size.width * 0.4,
                          height: size.height * 0.025,
                          child: AutoSizeText(
                            Prefs().profession,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.015),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.12,
                              height: size.height * 0.035,
                              child: AutoSizeText(
                                '${Prefs().totalScore}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.035,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            if (troffy != null)
                              Image.asset(
                                "asset/image/$troffy",
                                height: size.height * 0.035,
                              ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            // Color Picker
            Align(
              alignment: Alignment(0, -0.2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: colors
                    .map((color) => GestureDetector(
                          onTap: () {
                            setState(() {
                              changeColor(color);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: color,
                                border: Border.all(color: Colors.white, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            margin: EdgeInsets.all(5),
                            width: size.width * 0.1,
                            height: size.width * 0.1,
                          ),
                        ))
                    .toList(),
              ),
            ),

            // Color Picker Text
            Align(
              alignment: Alignment(0, -0.35),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0),
                    borderRadius: BorderRadius.all(
                        Radius.circular(size.height * 0.05 * 0.4)),
                    color: Colors.black.withOpacity(0.25)),
                width: size.width * 0.9,
                height: size.height * 0.05,
                child: Center(
                    child: AutoSizeText(
                  "cambia el color de tu fondo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: size.height * 0.02),
                )),
              ),
            ),

            // Help
            Align(
              alignment: Alignment(0,0.03),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0),
                    borderRadius: BorderRadius.all(
                        Radius.circular(size.height * 0.05 * 0.4)),
                    color: Colors.black.withOpacity(0.25)),
                height: size.height * 0.1,
                width: size.width * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
//                        BackGroundAudio().pauseAudio();
                        await Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.scale,
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 500),
                              child: ModuleScreen1(isFirstTime: false,),
                            ));
//                        BackGroundAudio().resumeAudio();
                      },
                      child: Container(
                        width: size.width * 0.1,
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          Icons.help_outline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      child: AutoSizeText(
                        "Ayuda",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Music
            Align(
              alignment: Alignment(0, 0.45),
              child: Container(
                width: size.width * 0.9,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(size.height * 0.05 * 0.4)),
                      color: Colors.black.withOpacity(0.65)),
                  height: size.height * 0.18,
                  width: size.width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: AutoSizeText(
                              "Canción de fondo",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          Switch(
                            activeColor: Colors.blue,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                            value: isMusicOn,
                            onChanged: (val) async {
                              if(val == true && musicIndex == -1)
                                  musicIndex = 0;
                              setState(() {
                                isMusicOn = val;
                              });
                              if(val == false) {
                                await BackGroundAudio().setAudio(-1);
                              } else {
                                await BackGroundAudio().setAudio(musicIndex);
                              }
                            },
                          ),
                        ],
                      ),
                      if(isMusicOn)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                              iconSize: size.height * 0.025,
                              onPressed: () async {
                                musicIndex = (musicIndex - 1) % 12;
                                await BackGroundAudio().setAudio(musicIndex);
                                if(mounted) {
                                  setState(() {});
                                }
                              },
                            ),
                            CustomSelector(size: size, index: musicIndex,),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                              iconSize: size.height * 0.025,
                              onPressed: () async {
                                musicIndex = (musicIndex + 1) % 12;
                                await BackGroundAudio().setAudio(musicIndex);
                                if(mounted) {
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      if(isMusicOn)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: AutoSizeText(
                                "Volumen",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
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
//                                print(val);
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Logout
            Align(
              alignment: Alignment(0, 0.7),
              child: GestureDetector(
                child: FormGlowButton(
                  buttonText: "Cerrar sesión",
                ),
                onTap: () async {
                  print("Logout");
                  if (mounted) {
                    setState(() {
                      isLoading = true;
                    });
                  }
//                  await BackGroundAudio().stopAudio();
                  await UserService().signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                },
              ),
            ),

            // Home Icon
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                child: IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.home),
                  onPressed: () async {
//                    await BackGroundAudio().stopAudio();
                    buttonClick();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ModuleScreen()));
                  },
                ),
              ),
            ),

            if (isLoading)
              Container(
                width: size.width,
                height: size.height,
                color: Colors.white.withOpacity(0.5),
                child: SpinKitFadingCircle(
                  color: Colors.black,
                ),
              )
          ],
        ),
      ),
    );
  }

  void changeColor(Color color) {
    this.color = color;
    Prefs().color = color;
  }
}

var textStyle = TextStyle(
  color: Colors.white,
);


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
      width: widget.size.width * 0.5,
      child: Center(child: AutoSizeText("Canción de fondo ${widget.index}", style: TextStyle(color: Colors.white, fontSize: 16),)),
    );
  }
}
