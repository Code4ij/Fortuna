import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/screen/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String profilePath = appDocumentsDirectory.path;

  String defaultPath = "$profilePath/profile_default.jpg";
  final byteData = await rootBundle.load('asset/image/user.jpg');
  final file = await File('$defaultPath').create();
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  Prefs.initialise(sharedPreferences, profilePath);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('es')
      ],
      debugShowCheckedModeBanner: false,
      title: 'Fortuna',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins'
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SplashScreen(),
      ),
    );
  }
}
