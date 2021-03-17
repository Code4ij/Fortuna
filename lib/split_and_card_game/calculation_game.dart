import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/templates/game_template.dart';
import 'package:fortuna/templates/gamepage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class Member {
  String name;
  double Amount;
  double outstanding;

  Member({this.name, this.Amount = 0.0});

  String statement = '';

  String toString() {
    return "{" +
        name +
        " :" +
        outstanding.toString() +
        "   //   " +
        statement +
        "}";
  }
}

class CalculationGame extends StatefulWidget {
  final Function function;

  const CalculationGame({Key key, this.function}) : super(key: key);

  @override
  _CalculationGameState createState() => _CalculationGameState();
}

class _CalculationGameState extends State<CalculationGame> {
  GlobalKey _globalKey = new GlobalKey();
  List<Member> finalOutstaning = [];
  String goal_name;
  double goal_amount;
  String member_name;
  double member_amount;
  double total_amount = 0.0;
  List<Member> members = [];
  TextEditingController _nameContoller = TextEditingController();
  TextEditingController _goalContoller = TextEditingController();
  TextEditingController _AmountContoller = TextEditingController();
  TextEditingController _goalAmountContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = const InputDecoration.collapsed()
      ..applyDefaults(Theme.of(context).inputDecorationTheme);
    final size = MediaQuery.of(context).size;
    return Align(
      alignment:
          Alignment.lerp(Alignment.topCenter, Alignment.bottomCenter, .15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            "Herramienta",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            shadowColor: Colors.grey[800],
            elevation: 5,
            color: Colors.white,
            child: Container(
              height: size.height * 0.62,
              width: size.width * 0.9,
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        widget.function();
                      },
                      icon: Icon(Icons.cancel_rounded),
                      color: Colors.red,
                      iconSize: 30,
                    ),
                  ),

                  // Project Name TextField
                  Row(
                    children: [
                      AutoSizeText("Objetivo:"),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: _goalContoller,
                            decoration: decoration,
                            onChanged: (val) {
                              goal_name = val;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    color: Color(0xff009641),
                  ),

                  // Amount TextField
                  Row(
                    children: [
                      AutoSizeText("Monto objetivo:"),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              controller: _goalAmountContoller,
                              decoration: decoration,
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                if (val != null && val != '') {
                                  goal_amount = double.parse(val);
                                } else {
                                  goal_amount = null;
                                }
                              },
                            ),
                          ))
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    color: Color(0xff009641),
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      getOneButton(
                        size,
                        "Agregar",
                        function: () {
                          addParticipants();
                        }
                      ),
                      getOneButton(size, "Limpiar", function: () {
                        setState(() {
                          members = [];
                          member_amount = null;
                          member_name = null;
                          finalOutstaning = [];
                          _nameContoller.clear();
                          _AmountContoller.clear();
                        });
                      }),
                      getOneButton(size, "Calcular", function: () {
                        List<Member> outStaningMinus = [];
                        List<Member> outstaningPlus = [];
                        if (goal_name == null || goal_name.length <= 0 || goal_amount == null || goal_amount < 0) {
                          Fluttertoast.showToast(msg: "Ingresar objetivo");
                        } else if (members.isEmpty) {
                          Fluttertoast.showToast(msg: "Añadir participantes");
                        } else {
                          total_amount = 0;
                          for (Member m in members) {
                            total_amount += m.Amount;
                            m.statement = '';
                          }

                          if(total_amount != goal_amount) {
                            Fluttertoast.showToast(msg: "No hay suficiente dinero para alcanzar la meta.");
                            return;
                          }

                          double avg = (total_amount / members.length);

                          print("Average: $avg");

                          for (Member m in members) {
                            m.outstanding = m.Amount - avg;
                            print(
                                "Name: ${m.name}, Amount: ${m.Amount}, OutStanding: ${m.outstanding}");
                            if (m.outstanding > 0) {
                              outstaningPlus.add(m);
                            } else if (m.outstanding < 0) {
                              outStaningMinus.add(m);
                            }
                          }
                          outstaningPlus.sort((a, b) {
                            return b.outstanding.compareTo(a.outstanding);
                          });
                          outStaningMinus.sort(
                              (a, b) => a.outstanding.compareTo(b.outstanding));
                          print(outstaningPlus.toString());
                          print(outStaningMinus.toString());

                          // Make Complete Transaction
                          for (int i = 0; i < outStaningMinus.length; i++) {
                            for (int j = 0; j < outstaningPlus.length; j++) {
                              if (outstaningPlus[j].outstanding +
                                      outStaningMinus[i].outstanding ==
                                  0.00) {
                                outStaningMinus[i].statement =
                                    " tiene que pagar \$ ${outstaningPlus[j].outstanding.toStringAsFixed(2)} To '${outstaningPlus[j].name}'";
                                outstaningPlus[j].outstanding = 0;
                                outStaningMinus[i].outstanding = 0;
                                finalOutstaning.add(outStaningMinus[i]);
                              }
                            }
                          }
                          outstaningPlus.removeWhere(
                              (element) => element.outstanding == 0);
                          outStaningMinus.removeWhere(
                              (element) => element.outstanding == 0);

                          print(outstaningPlus.toString());
                          print(outStaningMinus.toString());

                          int i = 0;
                          int j = 0;
                          while (i < outStaningMinus.length &&
                              j < outstaningPlus.length) {
                            if (outStaningMinus[i].outstanding +
                                    outstaningPlus[j].outstanding >
                                0.0) {
                              String addStat =
                                  " \$ ${(outStaningMinus[i].outstanding * -1).toStringAsFixed(2)} To ${outstaningPlus[j].name}";
                              if (outStaningMinus[i].statement == '') {
                                outStaningMinus[i].statement =
                                    " tiene que pagar ${addStat}";
                                finalOutstaning.add(outStaningMinus[i]);
                              } else {
                                outStaningMinus[i].statement += ",${addStat}";
                              }
                              outstaningPlus[j].outstanding +=
                                  outStaningMinus[i].outstanding;
                              outStaningMinus[i].outstanding = 0;
                              i++;
                            } else {
                              String addStat =
                                  " \$ ${outstaningPlus[j].outstanding.toStringAsFixed(2)} To ${outstaningPlus[j].name}";
                              if (outStaningMinus[i].statement == '') {
                                outStaningMinus[i].statement =
                                    " tiene que pagar ${addStat}";
                                finalOutstaning.add(outStaningMinus[i]);
                              } else {
                                outStaningMinus[i].statement += ",${addStat}";
                              }
                              outStaningMinus[i].outstanding +=
                                  outstaningPlus[j].outstanding;
                              outstaningPlus[j].outstanding = 0;
                              j++;
                            }
                          }

                          for (Member m in members) {
                            print("${m.name} ${m.statement}");
                          }
                          showResult(context);
                        }
                      }),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                    'participantes',
                    style: TextStyle(color: Color(0xff009641)),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // Participants
                  Expanded(
                    child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, i) {
                        return Container(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                members[i].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              AutoSizeText(
                                "\$ " + members[i].Amount.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: 30,
                                child: IconButton(
                                  iconSize: 15,
                                  color: Colors.red,
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      members.removeAt(i);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void addParticipants() {
    InputDecoration decoration = const InputDecoration.collapsed()
      ..applyDefaults(Theme.of(context).inputDecorationTheme);
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        child: AlertDialog(
          key: _globalKey,
          scrollable: true,
          title: Text(
            "Añada participante",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          content: Container(
            width: size.width * 0.8,
            height: size.height * 0.15,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AutoSizeText("Nombre:"),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: _nameContoller,
                            decoration: decoration,
                            onChanged: (val) {
                              member_name = val;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    color: Color(0xff009641),
                  ),

                  // Amount TextField
                  Row(
                    children: [
                      AutoSizeText("Monto:"),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              controller: _AmountContoller,
                              decoration: decoration,
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                if (val != null && val != '') {
                                  member_amount = double.parse(val);
                                } else {
                                  member_amount = null;
                                }
                              },
                            ),
                          ))
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    color: Color(0xff009641),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: Color(0xff8EA5C2),
                  child: Text("Agregar"),
                  onPressed: () async {
                    if (member_name == null ||
                        member_name.length <= 0 ||
                        member_amount == null) {
                      Fluttertoast.showToast(
                          msg: "Ingrese nombre y monto");
                    } else {
                      members.add(Member(
                          name: member_name, Amount: member_amount));
                      setState(() {
                        _AmountContoller.clear();
                        _nameContoller.clear();
                      });
                      member_amount = null;
                      member_name = null;
                      Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                RaisedButton(
                  color: Color(0xff8EA5C2),
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ));
  }

  Widget getOneButton(Size size, String text, {Function function}) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        color: Color(0xff009641),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: AutoSizeText(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            )),
      ),
    );
  }

  void showResult(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        child: AlertDialog(
          key: _globalKey,
          scrollable: true,
          title: Text(
            "$goal_name : $goal_amount",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          content: Container(
            width: size.width * 0.8,
            height: size.height * 0.5,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "Cantidad pagada",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(size.width * 0.05, 0, 0, 0),
                    child: getPaidAmount(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                    "Total: ${total_amount}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                    "Por persona: ${(total_amount / members.length).toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                    "Declaración de pago",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(size.width * 0.05, 0, 0, 0),
//                    color: Colors.red,
                    child: getToPayAmount(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: Color(0xff8EA5C2),
                  icon: Icon(
                    Icons.file_download,
                    size: size.width * 0.05,
                  ),
                  onPressed: () {
                    downloadPdf();
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                RaisedButton(
                  color: Color(0xff8EA5C2),
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                    Prefs pref = Prefs();
                    Map data = pref.data[2];

                    data["modules"][1]["total"] = 10;
                    data["total"] = data["modules"][1]["total"] +
                        data["modules"][0]["total"];
                    pref.updateScore(2, data);
                    print('finsh');
                    GamePage.of(context).finishGame();
                    GameTemplate.of(context).trophyIndex = data["total"] > 15
                        ? 0
                        : data['total'] > 10
                            ? 1
                            : 2;
                    print(pref.totalScore.toString());
                  },
                ),
              ],
            ),
          ],
        ));
  }

  Widget getPaidAmount() {
    List<Widget> paidAmount = [];
    for (Member m in members) {
      paidAmount.add(AutoSizeText(
        "${m.name}: \$ ${m.Amount}",
        style: TextStyle(fontSize: 16),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paidAmount,
    );
  }

  Widget getToPayAmount() {
    List<Widget> toPay = [];
    for (Member m in members) {
      if (m.statement != '' && m.statement != null) {
        toPay.add(
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: AutoSizeText(
              "➥ ${m.name}${m.statement}",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: toPay,
    );
  }

  Future<void> downloadPdf() async {
    final status = await Permission.storage.request();
    print(status);
    if (status != PermissionStatus.granted) {
      Fluttertoast.showToast(msg: "Permiso denegado.");
      return;
    }
    Fluttertoast.showToast(msg: "Descargando...");
    final pdf = pw.Document();

    int lines = 4;
    String firstPage = "Objetivo: $goal_name\nCantidad pagada\n";
    for (Member m in members) {
      firstPage += "\t${m.name}: \$ ${m.Amount}\n";
      lines++;
    }
    firstPage += "\nTotal: ${total_amount}\n";
    firstPage +=
        "\nPor persona: ${(total_amount / members.length).toStringAsFixed(2)}\n";

    String secondPage = "Declaración de pago\n";
    for (Member m in members) {
      if (m.statement != '' && m.statement != null) {
        secondPage += "\t -> ${m.name}${m.statement}\n";
        lines++;
      }
    }

    if (lines > 30) {
      pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Text(firstPage),
      ));
      pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Text(secondPage),
      ));
    } else {
      pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Text("$firstPage \n\n\n$secondPage"),
      ));
    }
    Map data = Prefs().data[2];
    File file;
    try {
      await new Directory('/storage/emulated/0/Fortuna').create();
      file = File(
          '/storage/emulated/0/Fortuna/transacción${DateTime.now().toString()}.pdf');
    } catch (e) {
      file = File(
          '/storage/emulated/0/Fortuna/transacción${DateTime.now().toString()}.pdf');
    }
    await file.writeAsBytes(await pdf.save());
    Fluttertoast.showToast(msg: "Descarga con éxito");
  }
}