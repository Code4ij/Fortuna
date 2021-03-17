import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/templates/game_template.dart';
import 'package:fortuna/templates/gamepage.dart';


class Module6 extends StatefulWidget {
  final String image;
  final String icon;
  final Color color;

  const Module6(
      {Key key,
        @required this.icon,
        @required this.color,
        @required this.image})
      : super(key: key);

  @override
  _Module6State createState() => _Module6State();
}

class _Module6State extends State<Module6> with WidgetsBindingObserver {
  int index = 0;
  int score = 0;


  List<bool> scorebool =[]; // to check button is press or not
  List<List<bool>> allBool =[];
  int aroundscore =0;
  List<String> creditData =[
    'Tener el desembolso de su crédito en su CuentaAhorro de Mundo Mujer de manera gratuita.',
    'Controlar y mantener su dinero seguro en CuentaAhorro de Mundo Mujer.',
    'Contar con el débito automático de las cuotas del crédito a su cuenta de ahorros sin costo.',
    'Facilitamos sus pagos de forma segura: Llevamos la Agencia del Banco a su municipio, vereda o barrio a través de nuestros Convenios de Recaudo. Consulte nuestros canales de atención',
    'El estudio de crédito es gratis y lo hacemos en su hogar o negocio, brindamos una atención personalizada.',
    'Estar tranquilo al ser respaldado con el pago de su obligación bancaria a través de la póliza Colmena Seguros en caso de un siniestro; es decir, un evento desfavorable (Accidente o enfermedad). Consulte los beneficios de los seguros',
  ];
  List<String> investData =[
    'Apertura fácil.',
    'Posibilidad de escoger el plazo de la inversión.',
    'Rentabilidad sobre su dinero con tasas de interés competitivas.',
    'Derecho a negociar su CDT Progrese antes del vencimiento en el mercado secundario a través del endoso.',
    'Mundo Mujer el Banco de la Comunidad asume el 4x1000 de su CDT.',
    'Su dinero estará seguro, somos una entidad vigilada por la Superintendencia Financiera y protegida con el Seguro de Depósito FOGAFÍN.',

  ];
  List<String> insuranceData =[
    'Sabemos que la familia es nuestra gran motivación, es el motor que nos inspira todos los días para cumplir nuestros sueños, es por esta razón que lo invitamos a que asegure el futuro de las personas que ama.',
    'Cuando usted toma el Seguro Familia Protegida está haciendo una inversión que puede programar hoy, para evitar tener un mayor gasto mañana en caso de presentarse algún evento desfavorable.',

  ];


  // List<String> Audiodata = [
  //   'Credit is the ability to borrow money or access goods or services with the understanding that youll pay later.Lenders, merchants and service providers  grant credit based on their confidence you can be trusted to pay back what you borrowed, along with any finance charges that may apply.To the extent that creditors consider you worthy of their trust, you are said to be creditworthy, or to have good credit.',
  //   'An investment is an asset or item acquired with the goal of generating income or appreciation. Appreciation refers to an increase in the value of an asset over time. When an individual purchases a good as an investment, the intent is not to consume the good but rather to use it in the future to create wealth. An investment always concerns the outlay of some asset today—time, money, or effort—in hopes of a greater payoff in the future than what was originally put in.',
  //   'The stock market refers to the collection of markets and exchanges where regular activities of buying, selling, and issuance of shares of publicly-held companies take place. Such financial activities are conducted through institutionalized formal exchanges or over-the-counter (OTC) marketplaces which operate under a defined set of regulations. There can be multiple stock trading venues in a country or a region which allow transactions in stocks and other forms of securities',
  // ];

  @override

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    allocate();

    // allBool.add(List<bool>.filled(creditData.length, false));
    // allBool.add(List<bool>.filled(investData.length, false));
    // allBool.add(List<bool>.filled(insuranceData.length, false));
  }
  Future allocate()async{
    final prefs = Prefs();
    Map data =prefs.data[5];
    print(data);
    // data["checkTopics"]['credit'] = [];
    // data["checkTopics"]['invest'] = [];
    // data["checkTopics"]['stock'] = [];



    if(data['checkTopics']["stock"].length <= 0||data['checkTopics']["invest"].length <= 0||data['checkTopics']["credit"].length <= 0){
      data['checkTopics']["credit"] =List<bool>.filled(creditData.length, false);
      data['checkTopics']["invest"]=List<bool>.filled(investData.length, false);
      data['checkTopics']["stock"]= List<bool>.filled(insuranceData.length, false);


    }
    allBool.add(data['checkTopics']["credit"]);
    allBool.add(data['checkTopics']["invest"]);
    allBool.add(data['checkTopics']["stock"]);
    print(allBool[0]);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
  }

  Future playaudio(int index,int setScore) async {
   // allocate();
    final prefs = Prefs();
    Map data =prefs.data[5];
    print("setScore = ${setScore}");


    // data['total'] =0;
    //  data['innerModule']["credit"] = 0;
    //  data['innerModule']["stock"] = 0;
    //  data['innerModule']["invest"] = 0;

    if (index == 2) {
      if(data['innerModule']["stock"] < 10){


        data['innerModule']["stock"] = setScore;
        // score = score +setScore;

      }

    } else if (index == 1) {
      if(data['innerModule']["invest"] < 10){


        data['innerModule']["invest"] = setScore;
        //score = score +setScore;

      }

    } else if (index == 0) {
      if(data['innerModule']["credit"]  <10){


        data['innerModule']["credit"] = setScore;
        //score = score +setScore;

      }

    } else {}
    int trophy = 0;

    score = data['innerModule']["stock"]+data['innerModule']["invest"]+data['innerModule']["credit"];
    if(score<30){
      print('ss');
      print('setScore = ${score}');
     data['total'] =score;
      data['checkTopics']["credit"] =allBool[0];
      data['checkTopics']["invest"]=allBool[1];
      data['checkTopics']["stock"]= allBool[2];
      prefs.updateScore(5, data);

    }

    if( data['innerModule']["credit"] >= 5 &&  data['innerModule']["invest"] >= 5 && data['innerModule']["stock"] >= 5){
      if(mounted){

        GameTemplate.of(context).trophyIndex = trophy;

        GamePage.of(context).finishGame();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fontweight = FontWeight.bold;
    double fontsize = size.height * 0.02;
    print('Total Score: ${Prefs().totalScore}');
    // credittextToSpeech.stop();
    // investtextToSpeech.stop();
    // stocktextToSpeech.stop();
    //  final prefs = Prefs();
    //  Map data = prefs.data[5];
    // data['total'] =0;
    //  data['innerModule']["credit"] = 0;
    //  data['innerModule']["stock"] = 0;
    //  data['innerModule']["invest"] = 0;
    return Stack(
      children: [
        Align(
          alignment: Alignment(0.0, -0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                'CREDITO',
                style: TextStyle(
                  fontWeight: fontweight,
                  fontSize: fontsize,
                ),

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

              ),
              // Text(
              //   'CREDITO',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontWeight: fontweight,
              //     fontSize: fontsize,
              //   ),
              // ),
              SizedBox(
                height: size.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {

                   // playaudio(0);
                    scorebool.add(true);
                    showdialog(0, context,creditData);

                  });
                },
                child: Image.asset(
                  'asset/Module6/credit.png',
                  height: size.height * .1,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment(0.0, -0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                'INVERSIÓN',
                style: TextStyle(
                  fontWeight: fontweight,
                  fontSize: fontsize,
                ),

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

              ),
              // Text(
              //   'INVERSIÓN',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontWeight: fontweight,
              //     fontSize: fontsize,
              //   ),
              // ),
              SizedBox(
                height: size.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {

                   // playaudio(1);
                    scorebool.add(true);
                    showdialog(1, context,investData);

                  });
                },
                child: Image.asset(
                  'asset/Module6/invest.png',
                  height: size.height * .1,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment(0.0, 0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                //'BOLSA DE VALORES ',
                'Seguros',
                style: TextStyle(
                  fontWeight: fontweight,
                  fontSize: fontsize,
                ),

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

              )
              // Text(
              //   'BOLSA DE VALORES',
              //   // textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontWeight: fontweight,
              //     fontSize: fontsize,
              //   ),
              // ),
              ,SizedBox(
                height: size.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {

                  //  playaudio(2);
                    scorebool.add(true);
                    showdialog(2, context,insuranceData);

                  });
                },
                child: Image.asset(
                  'asset/Module6/insurance.png',
                  //'asset/Module6/stock.png',
                  height: size.height * .1,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget showdialog(int index,BuildContext context,List showData,){
    final size = MediaQuery.of(context).size;
     showDialog(
        context: context,
        builder: (context){
          return Dialog(

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal:size.width*0.02,vertical: size.height*0.03125 ),
                //  padding: EdgeInsets.only(left: size.width*0.02,right: size.width*0.02,bottom: size.height*0.03125),
                child: ListView.builder(
                    itemCount: showData.length,
                    shrinkWrap: true,
                    itemBuilder:(context,showIndex){
                      return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Theme.of(context).primaryColor,
                        value: allBool[index][showIndex],
                        onChanged: (val) {
                          setState(() {

                              allBool[index][showIndex] = val;
                              Navigator.pop(context);
                              showdialog(index, context,showData);
                              int numberofTrue =0;
                             allBool[index].forEach((element)
                             {
                               if(element== true){
                                 numberofTrue = numberofTrue+1;
                               }
                             });
                            double eachPerEachData = 10/showData.length;
                            double _score =eachPerEachData *numberofTrue;
                            playaudio(index,_score.round());

                          });
                        },
                        title: Text(
                          showData[showIndex].toString(),
                          style: TextStyle(fontSize: size.height * 0.02),
                        ),
                      );


                        Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Icon(
                                Icons.verified_user_outlined,

                              ),
                              SizedBox(width: size.width *0.02,),
                              Expanded(
                                child: Text(
                                  showData[showIndex],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: size.height *0.01,)
                        ],
                      );
                    } )
              // Text(
              //   Audiodata[index],
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 20,
              //     wordSpacing: 2,
              //   ),
              // ),
            )
          );
        }
    );
  }
}
