import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/inputDecoration.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/templates/game_template.dart';
import 'package:fortuna/templates/gamepage.dart';

class Module4 extends StatefulWidget {
  final String image;
  final String icon;
  final Color color;

  const Module4(
      {Key key,
      @required this.icon,
      @required this.color,
      @required this.image})
      : super(key: key);

  @override
  _Module4State createState() => _Module4State();
}

class _Module4State extends State<Module4> {
  double rent = 0;
  double health = 0;
  double monthlyincome = 0;
  double interestrate = 0;
  double monthlyemi = 0;
  double expectedemi = 0;

  double ratio = 0;
  double other = 0;
  double amountaithintrest = 0;
  double loanamount = 0;
  double happiness = 0;
  int month = 12;
  bool isplay = false;
  bool a1 = false;
  bool a2 = false;
  bool a3 = false;
  bool a4 = false;
  bool a5 = false;
  bool a6 = false;

  getsaving() {
    setState(() {
      //   print('bulid');
      final prefs = Prefs();
      Map data = prefs.data[3];
      int trophy = 0;
      double localinterest = loanamount * interestrate / 100;
      amountaithintrest = loanamount + localinterest;

      monthlyemi = amountaithintrest / month;

      double monthexpane = health + rent + other;
      double remaingamount = monthlyincome - monthexpane - monthlyemi;
      double localhappy = 0.0;
      if (remaingamount < -1) {
        //     print('-');
        localhappy = remaingamount / monthlyincome;
        localhappy = localhappy * 100;
        //  print(localhappy.toString());
        localhappy = localhappy.abs();
        localhappy = 50 + localhappy;
      } else if (remaingamount == 0.0) {
        //  print('=');
        localhappy = 50.0;
      } else {
        // print('+');
        localhappy = remaingamount / monthlyincome;
        localhappy = localhappy * 100;

        localhappy = 50.0 - localhappy;
      }

      if (localhappy > 100.0) {
        happiness = 100.0;
      } else if (localhappy < -1) {
        happiness = 0.0;
      } else {
        happiness = localhappy;
      }
      if (a1 == true &&
          a2 == true &&
          a3 == true &&
          a4 == true &&
          a5 == true &&
          a6 == true) {
        print('true all');
        if (!isplay) {
          if (data['Counter'] < 5) {
            data['total'] = data['Counter'] * 2;
            prefs.updateScore(3, data);
            print("counter : ${data['Counter']}");
            setState(() {
              isplay = true;
            });
          }
        }

        if (data['total'] <= 4) {
          trophy = 2;
        } else if (data['total'] > 4 && data['total'] < 8) {
          trophy = 1;
        } else {
          trophy = 0;
        }
        if (data['Counter'] < 5) {
          data['trophy'] = trophy;
          prefs.updateScore(3, data);
        }
        print('trophy' + trophy.toString());
      }
      if (mounted) {
        GamePage.of(context).finishGame();
        GameTemplate.of(context).trophyIndex = trophy;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Prefs();
    Map data = prefs.data[3];
    print('trophy' + data['trophy'].toString());
    // data['Counter'] =  0;
    // data['total'] =0;

    final size = MediaQuery.of(context).size;
    final fontweight = FontWeight.bold;
    double fontsize = size.height * 0.0175;
    double formTextfontsize = size.height * 0.02;
    // print(data['Counter']);
    print('Total Score: ${Prefs().totalScore}');

    monthlyemi = monthlyemi;
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          height: size.height * 0.88,
          child: Stack(
            children: [
              // loan line
              Align(
                alignment: Alignment(-0.1, -0.85),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      'El banco te presta ',
                      style: TextStyle(
                        fontWeight: fontweight,
                        fontSize: fontsize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Text(
                    // 'El banco te presta',
                    //
                    // style: TextStyle(
                    //   fontWeight: fontweight,
                    //   fontSize: fontsize,
                    // ),
                    // ),
                    SizedBox(
                      width: 1,
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: TextFormField(
                        // style: TextStyle(
                        //   color: Colors.green
                        // ),
                        style: TextStyle(fontSize: formTextfontsize),
                        initialValue:
                            loanamount.toString().replaceAll(RegExp(r'.0'), ''),
                        keyboardType: TextInputType.phone,
                        decoration: inputDecoration.copyWith(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: size.height * .002),
                            isDense: true),
                        textAlign: TextAlign.center,
                        onChanged: (val) {
                          setState(() {
                            loanamount = double.parse(val);
                            a1 = true;
                            getsaving();
                            getsaving();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    AutoSizeText(
                      'para tu educaión',
                      style: TextStyle(
                        fontWeight: fontweight,
                        fontSize: fontsize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Text(
                    //   'para tu educaión',
                    //
                    //   style: TextStyle(
                    //     fontWeight: fontweight,
                    //     fontSize: fontsize,
                    //   ),
                    // ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment(0.0, -0.7),
                child: Image.asset(
                  'asset/Module4/moneymore.png',
                  height: size.height * 0.09,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                  alignment: Alignment(0.0, -0.42),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                        vertical: size.height * 0.01),
                    height: size.height * 0.13,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2)),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              'tienes que pagar, arriendo de:',
                              style: TextStyle(
                                fontWeight: fontweight,
                                fontSize: fontsize,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Text(
                            //   'tienes que pagar, arriendo de:',
                            //
                            //   style: TextStyle(
                            //     fontWeight: fontweight,
                            //     fontSize: fontsize,
                            //   ),
                            // ),

                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                // style: TextStyle(
                                //   color: Colors.green
                                // ),
                                style: TextStyle(fontSize: formTextfontsize),
                                textAlign: TextAlign.center,
                                initialValue: rent
                                    .toString()
                                    .replaceAll(RegExp(r'.0'), ''),
                                keyboardType: TextInputType.phone,
                                decoration: module4input,
                                onChanged: (val) {
                                  setState(() {
                                    a2 = true;
                                    rent = double.parse(val);
                                    getsaving();
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: size.width * 0.05),
                            AutoSizeText(
                              'tienes que pagar salud:',
                              style: TextStyle(
                                fontWeight: fontweight,
                                fontSize: fontsize,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Text(
                            //   'tienes que pagar salud:',
                            //
                            //   style: TextStyle(
                            //     fontWeight: fontweight,
                            //     fontSize: fontsize,
                            //   ),
                            // ),
                            SizedBox(width: size.width * 0.02),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                // style: TextStyle(
                                //   color: Colors.green
                                // ),
                                style: TextStyle(fontSize: formTextfontsize),
                                initialValue: health
                                    .toString()
                                    .replaceAll(RegExp(r'.0'), ''),
                                keyboardType: TextInputType.phone,
                                decoration: module4input,
                                textAlign: TextAlign.center,
                                onChanged: (val) {
                                  setState(() {
                                    a3 = true;
                                    health = double.parse(val);
                                    getsaving();
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: size.width * 0.08),
                            AutoSizeText(
                              'otra extensión:',
                              style: TextStyle(
                                fontWeight: fontweight,
                                fontSize: fontsize,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Text(
                            //   'otra extensión:',
                            //
                            //   style: TextStyle(
                            //     fontWeight: fontweight,
                            //     fontSize: fontsize,
                            //   ),
                            // ),
                            SizedBox(width: size.width * 0.04),
                            Expanded(
                              child: TextFormField(
                                // style: TextStyle(
                                //   color: Colors.green
                                // ),
                                style: TextStyle(fontSize: formTextfontsize),
                                initialValue: other
                                    .toString()
                                    .replaceAll(RegExp(r'.0'), ''),
                                keyboardType: TextInputType.phone,
                                decoration: module4input,
                                textAlign: TextAlign.center,
                                onChanged: (val) {
                                  setState(() {
                                    a4 = true;
                                    other = double.parse(val);
                                    getsaving();
                                  });
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
              Align(
                alignment: Alignment(0.0, -0.2),
                child: AutoSizeText(
                  'Ingreso neto de su trabajo',
                  style: TextStyle(
                    fontWeight: fontweight,
                    fontSize: fontsize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Text(
                //   'te están pagando en un trabajo',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontWeight: fontweight,
                //     fontSize: fontsize,
                //   ),
                // ),
              ),
              Align(
                alignment: Alignment(0.0, -0.12),
                child: Container(
                  width: size.width * 0.3,
                  child: TextFormField(
                    // style: TextStyle(
                    //   color: Colors.green
                    // ),
                    style: TextStyle(fontSize: formTextfontsize),
                    initialValue:
                        monthlyincome.toString().replaceAll(RegExp(r'.0'), ''),
                    keyboardType: TextInputType.phone,
                    decoration: inputDecoration.copyWith(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: size.height * .002),
                        isDense: true),
                    textAlign: TextAlign.center,
                    onChanged: (val) {
                      setState(() {
                        a5 = true;
                        monthlyincome = double.parse(val);
                        getsaving();
                        getsaving();
                      });
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.5, 0.1),
                child: Image.asset(
                  'asset/Module4/moneyless.png',
                  height: size.height * 0.07,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment(0.6, 0.00),
                child: Container(
                  width: size.width * 0.32,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeText(
                        'Interes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: fontweight,
                          fontSize: fontsize,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Text(
                      //   'Interes',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontWeight: fontweight,
                      //     fontSize: fontsize,
                      //   ),
                      // ),
                      SizedBox(
                        height: size.height * 0.005,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        height: size.height * .03,
                        child: TextFormField(
                          maxLength: 5,
                          textAlign: TextAlign.center,
                          initialValue: interestrate
                              .toString()
                              .replaceAll(RegExp(r'.0'), ''),
                          style: TextStyle(fontSize: formTextfontsize),

                          keyboardType: TextInputType.phone,
                          decoration: inputDecoration.copyWith(counterText: ''),
                          // controller: income,
                          onChanged: (val) {
                            setState(() {
                              a6 = true;
                              interestrate = double.parse(val);
                              getsaving();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // month
              Align(
                alignment: Alignment(0.6, 0.13),
                child: Container(
                  width: size.width * 0.32,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeText(
                        'Mes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: fontweight,
                          fontSize: fontsize,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Text(
                      //   'Mes',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontWeight: fontweight,
                      //     fontSize: fontsize,
                      //   ),
                      // ),
                      SizedBox(
                        height: size.height * 0.003,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        height: size.height * .03,
                        child: TextFormField(
                          maxLength: 3,
                          textAlign: TextAlign.center,
                          initialValue: month.toString(),
                          style: TextStyle(fontSize: formTextfontsize),

                          keyboardType: TextInputType.phone,
                          decoration: inputDecoration.copyWith(counterText: ''),
                          // controller: income,
                          onChanged: (val) {
                            setState(() {
                              month = int.parse(val);
                              getsaving();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.0, 0.25),
                child: Container(
                  width: size.width * 0.8,
                  child: AutoSizeText(
                    '¿Cuánto dinero tiene que pagar mensual para no endeudarse?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: fontweight,
                      fontSize: fontsize,
                    ),
                    minFontSize: 10,
                    stepGranularity: 10,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Text(
                //   'CUANTO DINERO TIENES QUE PAGAR MENSUAL AL BANCO PARA NO EN DEUDARTE',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontWeight: fontweight,
                //     fontSize: fontsize,
                //   ),
                // ),
              ),
              Align(
                alignment: Alignment(0.0, 0.35),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(10.0)),
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    child: Center(
                        child: Text(monthlyemi.toStringAsFixed(3).toString()))),
              ),

              Align(
                alignment: Alignment(0.0, 0.5),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2)),
                  width: size.width * 0.6,
                  height: size.height * 0.033,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      inactiveTrackColor: Colors.transparent,
                      // Custom Gray Color
                      activeTrackColor: Colors.transparent,
                      thumbColor: Colors.green,
                    ),
                    child: Slider(
                      value: happiness,
                      min: 0,
                      max: 100,
                      onChanged: (val) {},
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.65, 0.5),
                child: Image.asset(
                  'asset/Module4/happy.png',
                  height: size.height * 0.038,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment(0.65, 0.5),
                child: Image.asset(
                  'asset/Module4/angry.png',
                  height: size.height * 0.038,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
