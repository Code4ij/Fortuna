import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/inputDecoration.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/templates/game_template.dart';
import 'package:fortuna/templates/gamepage.dart';

class Module1 extends StatefulWidget {
  final String image;
  final String icon;
  final Color color;

  const Module1(
      {Key key,
        @required this.icon,
        @required this.color,
        @required this.image})
      : super(key: key);

  @override
  _Module1State createState() => _Module1State();
}

class _Module1State extends State<Module1> {
  double saving = 0;

  double income = 0;
  double expanse = 0;

  double dreamproduct = 0;
  int month = 12;
  double dreamemi = 0;
  bool a1 = false;
  bool a2 = false;
  bool b1 = false;
  bool b2 = true;
  List<String> _imagelist =[
    'asset/Module1/bike.png',
    'asset/Module1/donkey.png',
    'asset/Module1/cloth.png',
    'asset/Module1/cow.png',
    'asset/Module1/land.png',
    'asset/Module1/tools.png',
    'asset/Module1/truck.png',
    'asset/Module1/vehicle.png',
    'asset/Module1/worker.png',
    'asset/Module1/house.png',
  ];
  int selectImageIndex = 0;

  score(){
    if (a1 == true && a2 == true && b1 == true) {
      print('true');
      final prefs = Prefs();
      Map data = prefs.data[0];
      if(data['total'] == 0){
        print('total equal to 0' );
        data['total'] = 10;
        data['trophy'] = 0;
        prefs.updateScore(0, data);


      }
      if(mounted) {
        print('finish');
        GamePage.of(context).finishGame();

        GameTemplate.of(context).trophyIndex = 0;
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    print('build');

    final fontweight = FontWeight.bold;
    double fontsize = size.height * 0.0175;
    double formTextfontsize = size.height * 0.02;
    double monthformSize = size.height * 0.025;


    print('Total Score: ${Prefs().totalScore}');
// TODO:set width of image
    return ListView(
      shrinkWrap: false,
      children: [
        Container(
          height: size.height * 0.85,
          child: Stack(
          children: [
            // income Textbox
            Align(
              alignment: Alignment(-0.75, -0.82),
              child: Container(
                width: size.width * 0.40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(

                      'Primero debe digitar un valor de ganancia, o ingreso mensual monetario.',
                      //'DIGITA UN VALOR DE GANANCIA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: fontweight,
                        fontSize: fontsize,
                      ),

                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,

                    ),
                    // Text(
                    //   'DIGITA UN VALOR DE GANANCIA',
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
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      height: size.height * .03,
                      child: TextFormField(
                        initialValue: income.toString().replaceAll(RegExp(r'.0'), ''),
                        textAlign: TextAlign.center,
                        maxLength: 10,

                        keyboardType: TextInputType.phone,
                        decoration: inputDecoration.copyWith(counterText: ''),
                        // controller: income,
                        style: TextStyle(fontSize: formTextfontsize),
                        onChanged: (val) {
                          setState(() {
                            income = double.parse(val);
                            saving = income - expanse;
                            a1 = true;
                            score();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            // coin image
            Align(
              alignment: Alignment(0.73, -0.9),
              child: Container(
                width: size.width * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'asset/Module1/coin.png',
                      height: size.height * .08,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    AutoSizeText(

                      '¿ DONDE PONDRÍAS TU DINERO ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: fontweight,
                        fontSize: fontsize,
                      ),

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                    ),
                    // Text(
                    //   '¿ DONDE PONDRÍAS TU DINERO ? ',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     fontWeight: fontweight,
                    //     fontSize: fontsize,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            //vegetables
            Align(
              alignment: Alignment(-0.7, -0.5),
              child: Container(
                width: size.width * 0.35,
                child: Image.asset(
                  'asset/Module1/vegetables.png',
                  height: size.height * .08,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // expanse textbox
            Align(
              alignment: Alignment(0.65, -0.48),
              child: Container(
                width: size.width * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                        "Luego tendrá que colocar cuánto dinero gasta en promedio.",
                      // 'NECESIDAD',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: fontweight,
                        fontSize: fontsize,
                      ),

                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,

                    ),
                    // Text(
                    //   'NECESIDAD',
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
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      height: size.height * .03,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        initialValue: expanse.toString().replaceAll(RegExp(r'.0'), ''),
                        maxLength: 10,

                        keyboardType: TextInputType.phone,
                        decoration: inputDecoration.copyWith(counterText: ''),
                        //
                        // controller: income,
                        style: TextStyle(fontSize: formTextfontsize),
                        onChanged: (val) {
                          setState(() {
                            expanse = double.parse(val);
                            saving = income - expanse;
                            a2 = true;
                            score();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            // horizontal line
            Align(
              alignment: Alignment(-0.5, -0.3),
              child: Container(
                width: size.width * 0.7,
                child: Divider(thickness: 5, color: Colors.black),
              ),
            ),
            // pig image
            Align(
              alignment: Alignment(-0.5, -0.15),
              child: Container(
                width: size.width * 0.2,
                child: Image.asset(
                  'asset/Module1/pig.png',
                  height: size.height * .06,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // pig image divider
            Align(
              alignment: Alignment(-0.8, -0.02),
              child: Container(
                width: size.width * 0.4,
                child: Divider(thickness: 5, color: Colors.black),
              ),
            ),
            Align(
              alignment: Alignment(0.6, -0.13),
              child: Container(
                width: size.width * 0.32,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(

                      'AHORRO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: fontweight,
                        fontSize: fontsize,
                      ),

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                    ),
                    // Text(
                    //   'AHORRO',
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
                        width: size.width * 0.32,
                        height: size.height * 0.028,
                        decoration: BoxDecoration(
                            color: Color(0xffee9208),
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: Text(
                            saving.toStringAsFixed(3).toString(),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            // second title
            Align(
              alignment: Alignment(-0.1, 0.06),
              child: AutoSizeText(

                'Con estos datos, la aplicación arrojará cuánto ahorra por mes. De esta manera, podrá ingresar el valor que tiene eso que tanto quieres, el tiempo que u',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: fontweight,
                  //fontSize: fontsize,
                  fontSize: size.height *0.0155
                ),

                maxLines: 3,
                overflow: TextOverflow.ellipsis,

              ),

              // Text(
              //   '¿en cuanto tiempo deseas alcanzar tu sueño? ',
              //   style: TextStyle(
              //     fontWeight: fontweight,
              //     fontSize: 16.0,
              //   ),
              // ),
            ),
            //dream
            Align(
              alignment: Alignment(-0.6, 0.20),
              child:
              AutoSizeText(

                'SUEÑO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: fontweight,
                  fontSize: fontsize,
                ),

                maxLines: 2,
                overflow: TextOverflow.ellipsis,

              ),
              // Text(
              //   'SUEÑO',
              //   style: TextStyle(
              //     fontWeight: fontweight,
              //     fontSize: fontsize,
              //   ),
              // ),
            ),
            // price and textform
            Align(
              alignment: Alignment(-0.1, 0.20),
              child: Container(
                width: size.width * 0.32,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(

                      'valor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: fontweight,
                        fontSize: fontsize,
                      ),

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                    ),
                    // Text(
                    //   'valor',
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
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      height: size.height * .03,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        initialValue: dreamproduct.toString().replaceAll(RegExp(r'.0'), ''),
                        maxLength: 10,
                        style: TextStyle(fontSize: formTextfontsize),
                        keyboardType: TextInputType.phone,
                        decoration: inputDecoration.copyWith(counterText: ''),
                        // controller: income,
                        onChanged: (val) {
                          setState(() {
                            dreamproduct = double.parse(val);
                            dreamemi = dreamproduct / month;
                            b1 = true;
                            score();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.6, 0.20),
              child: Container(
                  width: size.width * 0.12,
                  height: size.height * 0.06,
                  // TODO decoration image

                  // decoration: BoxDecoration(
                  //     // color: Colors.white,
                  //   image: DecorationImage(
                  //     image: AssetImage(
                  //       'asset/Module1/month.png'
                  //     )
                  //   ),
                  //   // borderRadius:BorderRadius.circular(5.0),
                  //   // border: Border.all(color: Colors.black)
                  // ),
                  child: Stack(
                    children: [
                      Image.asset('asset/Module1/month.png'),
                      Align(
                        alignment: Alignment(-0.6, 0.7),
                        child: Container(
                          width: size.width * 0.080,
                          height: size.height * 0.030,
                          color: Colors.white,
                          child: Center(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              initialValue: month.toString().replaceAll(RegExp(r'.0'), ''),
                              maxLength: 2,

                              style: TextStyle(fontSize: monthformSize),
                              keyboardType: TextInputType.phone,
                              decoration: monthinputbox,
                              // controller: income,
                              onChanged: (val) {
                                setState(() {
                                  if (int.parse(val) != 0) {
                                    month = int.parse(val);
                                    dreamemi = dreamproduct / month;
                                    score();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            //bike
            Align(
              alignment: Alignment(-0.7, 0.36),
              child: GestureDetector(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (context){
                        return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child:Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: size.width *0.8,
                                    height: size.height *0.3,
                                    child: GridView.builder(

                                      itemCount: _imagelist.length,
                                      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3), itemBuilder: (context,imageindex){
                                      return GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            selectImageIndex = imageindex;
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Image.asset(
                                          _imagelist[imageindex],
                                          width: size.width * 0.20,
                                          height: size.height * .02,

                                          // fit: BoxFit.fitWidth,
                                        ),
                                      );
                                    },
                                    ),
                                  ),
                                )
                              ],
                            )
                        );
                      }
                  );
                },
                child: Image.asset(
                  _imagelist[selectImageIndex],
                  width: size.width * 0.20,
                  height: size.height * .04,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.2, 0.45),
              child:
              AutoSizeText(
                'En promedio necesitas ahorrar',
                style: TextStyle(
                  fontWeight: fontweight,
                  fontSize: fontsize,
                ),

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

              ),
              // Text(
              //   'En promedio necesitas ahorrar',
              //   style: TextStyle(
              //     fontWeight: fontweight,
              //     fontSize: fontsize,
              //   ),
              // ),
            ),
            Align(
                alignment: Alignment(0.2, 0.51),
                child: Container(
                    width: size.width * 0.32,
                    height: size.height * 0.028,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        color: Color(0xffee9208),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      // TODO :: change text
                      child: Text(dreamemi.toStringAsFixed(3).toString()),
                    ))),
            Align(
              alignment: Alignment(0.3, 0.63),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child:
                AutoSizeText(
                  'Ahorrando ese valor mensual podrás alcanzar tu sueño sin dejar atrás tus verdaderas necesidades',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: fontweight,
                    fontSize: fontsize,
                  ),

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                ),
                // Text(
                //   'Ahorrando ese valor mensual podrás alcanzar tu sueño sin dejar atrás tus verdaderas necesidades',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontWeight: fontweight,
                //     fontSize: fontsize,
                //   ),
                // ),
              ),
            ),
          ],
      ),
        ),]
    );
  }
}
