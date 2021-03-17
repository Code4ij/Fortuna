import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class Certificate extends StatefulWidget {
  @override
  _CertificateState createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  ConfettiController _controller;

  @override
  void initState() {
    _controller = ConfettiController(duration: Duration(seconds: 10));
    startConfetti();
  }

  void startConfetti() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      _controller.play();
      setState(() {});
    });
  }

  DateTime now = DateTime.now();
  ScreenshotController screenshotController = ScreenshotController();
  List monthInSpain = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            child: Image.asset(
              'asset/image/home_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.5),
          ),

          // Confetti
          Align(
            alignment: Alignment(0, -0.5),
            child: ConfettiWidget(
              blastDirectionality: BlastDirectionality.explosive,
              confettiController: _controller,
              gravity: 0.05,
              shouldLoop: true,
              numberOfParticles: 25,
              colors: [
                Colors.green,
                Colors.red,
                Colors.yellow,
                Colors.blue,
                Colors.pink
              ],
            ),
          ),

          // Certificate UI
          Stack(
            children: [
              Align(
                alignment: Alignment(0.0, -0.6),
                child: AutoSizeText(
                  '¡FELICIDADES!',
                  style: TextStyle(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Screenshot(
                controller: screenshotController,
                child: Certi(context),
              ),
              Align(
                alignment: Alignment(0.0, 0.6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          color: Colors.black54,
                          child: IconButton(
                            icon: Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3)),
                    ),
                    SizedBox(width: size.width * 0.1,),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          color: Colors.black54,
                          child: IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await screenshotController.capture().then((image) async {
                                Share.shareFiles([image.path],
                                    text: "¡¡Viva!! He completado todos los módulos -FORTUNA");
                              });
                            },
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Certificate Image
  Widget Certi(BuildContext context) {
    final prefs = Prefs();
    final size = MediaQuery.of(context).size;
    return Align(
        alignment: Alignment(0.0, 0.0),
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.35,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'asset/certificate/background.png',
                ),
                fit: BoxFit.fill
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment(0.0, -0.8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'asset/certificate/flower.png',
                      height: size.height * 0.03,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ' SOLVENTE',

                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.02),
                        ),
                        Text(
                          ' EDUCACIÓN ECONOMICA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.007),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0.0, -0.5),
                child: AutoSizeText(
                  'certifica a',
                  minFontSize: (size.height * 0.013).roundToDouble(),
                  style: TextStyle(
                      fontSize: size.height * 0.016,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Align(
                alignment: Alignment(0.0, -0.35),
                child: Container(
                  width: size.width * 0.63,
                  child: AutoSizeText(
                    prefs.name.toString(),
                    minFontSize: (size.height * 0.013).roundToDouble(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.height * 0.016,),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment(0.0, -0.1),
                  child: Container(
                    width: size.width * 0.9,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoSizeText(
                          'Por haber superado todos los módulos interactivos',
                          minFontSize: (size.height * 0.016).roundToDouble(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: size.height * 0.0124,
                              fontWeight: FontWeight.w800),
                        ),
                        AutoSizeText(
                          'y de aprendizaje sobre un excelente manejo',
                          minFontSize: (size.height * 0.016).roundToDouble(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: size.height * 0.0128,
                              fontWeight: FontWeight.w800),
                        ),
                        AutoSizeText(
                          'económico. Por lo tanto se le otorga este',
                          minFontSize: (size.height * 0.016).roundToDouble(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: size.height * 0.0128,
                              fontWeight: FontWeight.w800),
                        )
                      ],
                    ),
                  )),
              Align(
                  alignment: Alignment(0.0, 0.25),
                  child: Container(
                    width: size.width * 0.63,
                    child: AutoSizeText(
                      'DIPLOMA',
                      minFontSize: (size.height * 0.02).roundToDouble(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: size.height * 0.017,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Align(
                  alignment: Alignment(0.0, 0.5),

                  child: AutoSizeText(
                    now.day.toString() +
                        " de ${monthInSpain[now.month - 1]} del " +
                        now.year.toString(),
                    minFontSize: (size.height * 0.020).roundToDouble(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: size.height * 0.016,
                        fontWeight: FontWeight.w600),
                  )),
              Align(
                  alignment: Alignment(0.0, 0.8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'asset/certificate/symbolLeft.png',
                        height: size.height * 0.04,
                      ),
                      Image.asset(
                        'asset/certificate/SymbolRight.png',
                        height: size.height * 0.03,
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
