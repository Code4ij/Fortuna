import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/templates/gamepage.dart';
import 'package:fortuna/templates/next_button.dart';
class QAGame extends StatefulWidget {
  final Color color;
  final Function updateState;

  const QAGame({Key key, this.color, this.updateState}) : super(key: key);

  @override
  _QAGameState createState() => _QAGameState();
}

class _QAGameState extends State<QAGame> with WidgetsBindingObserver{
  Map<int, String> questions = {
    1: "¿Siente que depende de alguien para resolver sus problemas económicos?",
    2: "¿Siente que NO posee suficientes conocimientos financieros para administrar su dinero?",
    3: "¿Tiene el hábito de presupuestar cada centavo de su dinero?",
    4: "¿Espera o busca constantemente ayuda humanitaria o de una entidad gubernamental, religiosa o bancaria que le ayude financieramente?",
    5: "¿NO le gusta revisar su estado de cuenta bancaria constantemente?",
    6: "¿Siente que es superior a los demás y que debería ocupar un cargo más elevado?",
    7: "¿Casi no se preocupa por revisar sus finanzas porque considera que es bueno/a administrando?",
    8: "A pesar de todas sus deudas, ¿siente que no le ha ido tan mal?",
    9: "¿Siente que su vida financiera (ahorros, cuentas y estados financieros) se encuentra en desorden?",
    10: "¿A veces gasta más de lo que gana?",
    11: "¿Tiene objetivos financieros en mente?"
  };

  int currentQuestion = 1;
  int activeButton = 0;
  bool isSubmit = false;
  int total = 0;
  Map<int, String> result = {
    1: "Considérate una persona que evidencia capacidad y habilidad para actuar en forma organizada, responsable y disciplinada en cuanto a tu manejo financiero. Este puntaje refleja que eres consciente de la gran importancia que tiene capacitarse en la administración correcta de tu propio dinero. Estás generando las condiciones que te permitirán gozar de una existencia relajada y cómoda en el futuro próximo. ¡Felicitaciones! Continúa por ese camino de prosperidad ",
    2: "Posees algunos conocimientos necesarios para el manejo de tus finanzas de una forma adecuada y eficiente, aunque aún se hace notorio que no has conseguido objetivar y llevar a cabo las acciones necesarias para manejar tu dinero de una forma responsable y organizada. En cierto sentido no posees problemas teóricos sino prácticos en cuanto a la administración de tu dinero.",
    3: "Evidentemente posee dificultades para administrar su dinero de manera adecuada. El puntaje refleja cierta indisciplina en cuanto a su forma de pensar y distorsión al ver la realidad con el dinero que posee. Se debe tener en cuenta que poseer mucho dinero no te deja excento de caer en quiebra por causa de una mala administración. Gastar más de lo que gana es solo uno de los tantos errores por mejorar. Trabajar en los aspectos de uso y manejo prudente del dinero, le llevarán a conocer el camino al éxito. Recuerde que un patrón de conducta erróneo le puede llevar al caos financiero.",
  };

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(children: [
      Align(
        alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.3),
        child: Container(
          width: size.width / 1.2,
          height: size.height / 1.5,
          child: Center(
            child: isSubmit == false
                ? Column(
                    children: [
                      SizedBox(
                        width: size.width / 3,
                        height: size.height / 14,
                        child: Center(
                          child: AutoSizeText(
                            "$currentQuestion de 11",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 1.2,
                        height: size.height / 4.5,
                        child: Center(
                          child: AutoSizeText(
                            "${questions[currentQuestion]}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          GlowButton1(
                            isSelected: activeButton == 3 ?  true : false,
                            text: "Muchas veces",
                            function: (){
                              setState(() {
                                activeButton = 3;
                              });
                            },
                          ),
                           GlowButton2(
                            isSelected:  activeButton == 2 ? true:false ,
                            text: "Algunas veces",
                             function: (){
                               setState(() {
                                 activeButton = 2;
                               });
                             },
                          ) ,
                          GlowButton3(
                            isSelected: activeButton == 1 ? true : false,
                            text: "Nunca",
                            function: (){
                              setState(() {
                                activeButton = 1;
                              });
                            },
                          )
                          // ButtonTheme(
                          //   minWidth: size.width * 0.34,
                          //   child: RaisedButton(
                          //     color: activeButton == 3
                          //         ? Colors.greenAccent
                          //         : Colors.deepPurple[100],
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(12.0),
                          //       side: BorderSide(color: Colors.black12),
                          //     ),
                          //     onPressed: () {
                          //       setState(() {
                          //         if (isSubmit != true) activeButton = 3;
                          //       });
                          //     },
                          //     child: AutoSizeText("Muchas veces"),
                          //   ),
                          // ),
                          // GlowButton(
                          //   borderRadius: BorderRadius.circular(12.0),
                          //   width: size.width * 0.34,
                          //  spreadRadius: 2,
                          //  glowColor: Colors.black,
                          //   color: activeButton == 3
                          //           ? Colors.greenAccent
                          //           : Colors.deepPurple[100],
                          //   child: AutoSizeText("Muchas veces"),
                          //   onPressed: () {
                          //       setState(() {
                          //         if (isSubmit != true) activeButton = 3;
                          //       });
                          //     },
                          // ),

                          // ButtonTheme(
                          //   minWidth: size.width * 0.34,
                          //   child: RaisedButton(
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(12.0),
                          //       side: BorderSide(color: Colors.black12),
                          //     ),
                          //     color: activeButton == 2
                          //         ? Colors.greenAccent
                          //         : Colors.deepPurple[100],
                          //     onPressed: () {
                          //       setState(() {
                          //         if (isSubmit != true) activeButton = 2;
                          //       });
                          //     },
                          //     child: AutoSizeText("Algunas veces"),
                          //   ),
                          // ),
                          // ButtonTheme(
                          //   minWidth: size.width * 0.34,
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(12.0),
                          //     side: BorderSide(color: Colors.black12),
                          //   ),
                          //   child: RaisedButton(
                          //     color: activeButton == 1
                          //         ? Colors.greenAccent
                          //         : Colors.deepPurple[100],
                          //     onPressed: () {
                          //       setState(() {
                          //         if (isSubmit != true) activeButton = 1;
                          //       });
                          //     },
                          //     child: AutoSizeText("Nunca"),
                          //   ),
                          // ),
                        ],
                      ),
                      currentQuestion < 11 && activeButton != 0
                          ? Padding(
                              padding: EdgeInsets.only(left:size.width * 0.5,top:16),
                               // child: IconButton(
                               //   iconSize: size.width * 0.16,
                               //   icon: Icon(Icons.navigate_next_rounded,color: Colors.white,),
                               //   onPressed: (){
                               //     if(activeButton != 0){
                               //       setState(() {
                               //         currentQuestion += 1;
                               //         total += activeButton;
                               //         activeButton = 0;
                               //       });
                               //     }else
                               //       snackBar();
                               //   },
                               // ),
                             child: NextButton(
                               backVisible: false,
                               color: widget.color,
                               jumpPage: () {
                                 if (activeButton != 0) {
                                   setState(() {
                                     currentQuestion += 1;
                                     total += activeButton;
                                     activeButton = 0;
                                   });
                                 } else
                                   snackBar();
                               },
                             ),
                            )
                          : isSubmit == false && activeButton != 0
                              ? Padding(
                                padding: EdgeInsets.only(
                                    top: size.height * 0.0625),
                                child: InkWell(
                                  onTap: (){
                                    if (activeButton != 0) {
                                      // GamePage.updateState();
                                      setState(() {
                                        isSubmit = true;
                                        total += activeButton;
                                        GamePage.of(context).finishGame();
                                        final prefs = Prefs();
                                        Map data = prefs.data[8];
                                        data["total"] = 30;
                                        prefs.updateScore(8, data);
                                        String result = getResult();
                                      });
                                    } else
                                      snackBar();
                                  },
                                  child: Container(
                                    width: size.width *0.35,
                                    height: size.height*0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18.0),
                                      color: Color.fromARGB(255, 27, 28, 30),
                                        boxShadow: [BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 5,
                                            spreadRadius: 5
                                        )]
                                    ),
                                    child: Center(
                                      child: AutoSizeText(
                                        "Enviar",
                                        style: TextStyle(color: Colors.white, fontSize: size.height * 0.03),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : Container(),
                    ],
                  )
                : Column(
                  children: [
                    AutoSizeText(
                      "Tu puntuación \n $total",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height*0.039
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(top:size.height * 0.01875),
                      child: AutoSizeText(
                          "${getResult()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: size.height*0.024),
                        ),
                    ),
                  ],
                ),
          ),
        ),
      ),
    ]);
  }

  void snackBar() {
    final snackBar = SnackBar(
      content: AutoSizeText('Seleccione una opción'),
      duration: Duration(seconds: 1),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  String getResult(){
    String res = total <= 11 ? result[1] : total > 11 && total <= 22 ? result[2] : result[3];
    return res;
  }
}
//
// class SimpleButton extends StatelessWidget {
//   final bool isSelected;
//   final String text;
//   final Function function;
//
//   const SimpleButton({Key key, this.isSelected, this.text, this.function}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: GestureDetector(
//         onTap: function,
//         child: Container(
//           width: size.width *0.34,
//           height: size.height*0.05,
//           // decoration: BoxDecoration(
//           //   // shape: BoxShape.circle,
//           //     borderRadius: BorderRadius.circular(12.0),
//           //     color: Color.fromARGB(255, 27, 28, 30),
//           //
//           //
//           // ),
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.blue.withAlpha(125),
//                 blurRadius: 45,
//                 spreadRadius: 15,
//                 offset: Offset(0, 0),
//               )
//             ],
//             gradient: LinearGradient(colors: [
//               Color(0xFFFF1000),
//               Color(0xFF2508FF),
//             ], begin: Alignment.centerRight, end: Alignment.centerLeft),
//             borderRadius: BorderRadius.circular(15),
//           ),
//
//
//           child: Center(
//             child: AutoSizeText(
//               "${text}",
//               style: TextStyle(
//                   color: Colors.white
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


class GlowButton1 extends StatefulWidget {
  final String text;
  bool isSelected;
  final Function function;
  GlowButton1({Key key, this.text, this.isSelected, this.function}) : super(key: key);
  @override
  _GlowButton1State createState() => _GlowButton1State();
}

class _GlowButton1State extends State<GlowButton1>  with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(vsync:this,duration: Duration(seconds: 1));

    _animation =  Tween(begin: 2.0,end: 10.0).animate(_animationController)..addListener((){
      setState(() {

      });
    });

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          if(widget.isSelected == false)
          {
            widget.isSelected = true;
            widget.function();
          }
          if(widget.isSelected == true)
            _animationController.repeat(reverse: true);
          else
            _animationController.stop();
        },
        child: Container(
          width: size.width *0.7,
          height: size.height*0.05,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(12.0),
              color: Color.fromARGB(255, 27, 28, 30),
              boxShadow: [BoxShadow(
                  color: widget.isSelected ? Colors.greenAccent : Colors.white,
                  blurRadius: widget.isSelected == true ? _animation.value :5,
                  spreadRadius: widget.isSelected == true ? _animation.value : 5
              )]

          ),


          child: Center(
            child: AutoSizeText(
              "${widget.text}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height*0.03
              ),
            ),
          ),
        ),

      ),

    );
  }
}

class GlowButton2 extends StatefulWidget {
  final String text;
  bool isSelected;
  final Function function;
  GlowButton2({Key key, this.text, this.isSelected, this.function}) : super(key: key);
  @override
  _GlowButton2State createState() => _GlowButton2State();
}

class _GlowButton2State extends State<GlowButton2> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(vsync:this,duration: Duration(seconds: 1));

    _animation =  Tween(begin: 2.0,end: 10.0).animate(_animationController)..addListener((){
      setState(() {

      });
    });

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          if(widget.isSelected == false)
          {
            widget.isSelected = true;
            widget.function();
          }
          if(widget.isSelected == true)
            _animationController.repeat(reverse: true);
          else
            _animationController.stop();
        },
        child: Container(
          width: size.width *0.7,
          height: size.height*0.05,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(12.0),
              color: Color.fromARGB(255, 27, 28, 30),
              boxShadow: [BoxShadow(
                  color: widget.isSelected ? Colors.greenAccent : Colors.white,
                  blurRadius: widget.isSelected == true ? _animation.value :5,
                  spreadRadius: widget.isSelected == true ? _animation.value : 5
              )]

          ),


          child: Center(
            child: AutoSizeText(
              "${widget.text}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height*0.03
              ),
            ),
          ),
        ),

      ),

    );
  }
}

class GlowButton3 extends StatefulWidget {
  final String text;
  bool isSelected;
  final Function function;
  GlowButton3({Key key, this.text, this.isSelected, this.function}) : super(key: key);
  @override
  _GlowButton3State createState() => _GlowButton3State();
}

class _GlowButton3State extends State<GlowButton3> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(vsync:this,duration: Duration(seconds: 1));

    _animation =  Tween(begin: 2.0,end: 10.0).animate(_animationController)..addListener((){
      setState(() {

      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          print(widget.isSelected);
          if(widget.isSelected == false)
           {
             widget.isSelected = true;
             widget.function();
           }

          if(widget.isSelected == true)
            _animationController.repeat(reverse: true);
          else
            _animationController.stop();
        },
        child: Container(
          width: size.width *0.7,
          height: size.height*0.05,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(12.0),
              color: Color.fromARGB(255, 27, 28, 30),
              boxShadow: [BoxShadow(
                  color: widget.isSelected ? Colors.greenAccent : Colors.white,
                  blurRadius: widget.isSelected == true ? _animation.value :5,
                  spreadRadius: widget.isSelected == true ? _animation.value : 5
              )]

          ),


          child: Center(
            child: AutoSizeText(

              "${widget.text}",
              style: TextStyle(
                  color: Colors.white,
                fontSize: size.height*0.03
              ),
            ),
          ),
        ),

      ),

    );
  }
}

