import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fortuna/atm_game/account.dart';
import 'package:fortuna/atm_game/withdraw_animation.dart';

enum Screen { Home, ChangePassword, Withdraw, CheckBalance, Animation, Amount, Message }

class AtmOperation extends StatefulWidget {
  @override
  _AtmOperationState createState() => _AtmOperationState();
}

class _AtmOperationState extends State<AtmOperation> {
  AnimationController animationController;
  Screen option = Screen.Home;
  String message = "";
  final TextEditingController _textController = new TextEditingController();
  // left symbol

  String amount = "";
  Map<int, String> keyboard = {
    0: "1",
    1: "2",
    2: "3",
    4: "4",
    5: "5",
    6: "6",
    8: "7",
    9: "8",
    10: "9",
    13: "0",
    3: "Cancelar",
    7: "Entrar", //enter
    11: "Corregir" // clear
  };

  @override
  void initState() {
    // TODO: implement initState
    _textController.clear();
    amount = "";
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        option == Screen.Home
            ? Align(
                alignment:
                    Alignment.lerp(Alignment.topCenter, Alignment.center, 0.55),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    width: size.width * 0.7,
                    height: size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Option("Cambiar contraseña", Screen.ChangePassword , size), // CHnage Password
                        Option("Retirar dinero", Screen.Withdraw, size), //Withdraw
                        Option("Consultar saldo", Screen.CheckBalance, size) // Check Balance
                      ],
                    ),
                  ),
                ),
              )
            : option == Screen.ChangePassword
                ? Align(
                    alignment: Alignment.lerp(
                        Alignment.topCenter, Alignment.center, 0.7),
                    child: Container(
                      width: size.width * 0.6,
                      height: size.height / 5,
                      child: Column(
                        children: [
                          MessageBox("Ingrese PIN antiguo", size), //  Enter Old Pin
                          Container(
                            width: size.width * 0.125,
                            height: size.height * 0.03125,
                            child: TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                  fillColor: Colors.black,
                                  labelText: "${Account.password}"),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.0156,
                          ),
                          MessageBox("Ingrese nuevo PIN", size), //Enter New Pin
                          TextBoxWidget(size)
                        ],
                      ),
                    ),
                  )
                : option == Screen.Withdraw || option == Screen.CheckBalance
                    ? OptionWidget("Ingrese un PIN ${Account.password}", size,false) //Enter a PIN
                    : option == Screen.Amount
                        ? OptionWidget("Ingrese una cantidad", size,true) // Enter an Amount
                        : option == Screen.Message
                            ? Align(
                                alignment: Alignment.lerp(Alignment.topCenter,
                                    Alignment.center, 0.65),
                                child: SizedBox(
                                  width: size.width * 0.5,
                                  height: size.height * 0.0625,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width * 0.025, right: size.width * 0.025),
                                    child: AutoSizeText(
                                      '$message',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                    ),
                                  ),
                                ))
                            : WithdrawAnimation(
                                update: update,
                              ),
        option == Screen.ChangePassword || option == Screen.Withdraw ||  option == Screen.CheckBalance || option == Screen.Amount
            ? Align(
                alignment: Alignment.lerp(
                    Alignment.center, Alignment.bottomCenter, 0.60),
                child: Container(
                  height: size.height * 0.35,
                  width: size.width / 1.85,
                  child: Column(

                    children: List.generate(
                        4,
                        (i) => Row(

                              children: List.generate(
                                  4,
                                  (j) => Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: InkWell(
                                          onTap: () {
                                            if (keyboard[4 * i + j] ==
                                                "Cancelar") {
                                              setState(() {
                                                option = Screen.Home;
                                              });
                                            } else if (keyboard[4 * i + j] ==
                                                "Entrar") { //Enter
                                              if (option == Screen.ChangePassword) {
                                                Account account = Account();
                                                account.setPassword(
                                                    _textController.text);
                                                message =
                                                    "Cambio de contraseña exitoso"; //Password change successfully
                                              } else if (option == Screen.Withdraw ||
                                                  option == Screen.CheckBalance) {
                                                if (_textController.text ==
                                                        Account.password &&
                                                    option == Screen.Withdraw) {
                                                  option = Screen.Amount;
                                                } else if (_textController
                                                        .text ==
                                                    Account.password)
                                                  message =
                                                      "Su balance es ${Account.balance}"; //Your balance is
                                                else
                                                  message = "Pin es incorrecto"; //Pin is Wrong
                                              } else {
                                                var finalAmount = double.parse(amount);
                                                print(finalAmount.runtimeType);
                                                if (finalAmount <= Account.balance) {
                                                  message =
                                                      "Retirar con éxito"; //Withdraw Successfully
                                                  Account.balance =
                                                      Account.balance - finalAmount;
                                                  option = Screen.Animation;
                                                } else {
                                                  option = Screen.Message;
                                                  message =
                                                      "Monto de retiro no válido"; //Invalid Withdraw Amount
                                                }
                                              }

                                              _textController.clear();
                                              amount = "";
                                              if (option != Screen.Animation && option != Screen.Amount) {
                                                option = Screen.Message;
                                                update();
                                              }
                                            } else if (keyboard[4 * i + j] ==
                                                "Corregir") {
                                              _textController.clear();
                                              amount = "";
                                            } else if (option != Screen.Amount && _textController
                                                    .text.length !=
                                                4) {
                                              _textController.text +=
                                                  keyboard[4 * i + j];

                                            }else if(option == Screen.Amount){
                                              amount += keyboard[4 * i + j];
                                              print(amount);

                                              print(FlutterMoneyFormatter(amount:double.parse(amount) ).output.nonSymbol);
                                              _textController.text = FlutterMoneyFormatter(amount:double.parse(amount) ).output.nonSymbol;
                                              print(_textController.text);
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 4 * i + j == 3 ||
                                                    4 * i + j == 7 ||
                                                    4 * i + j == 11 ||
                                                    4 * i + j == 15
                                                ? size.width * 0.185
                                                : size.width * 0.1,
                                            height: size.width * 0.1,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                color: 4 * i + j == 3
                                                    ? Colors.red
                                                    : 4 * i + j == 7
                                                        ? Colors.green
                                                        : 4 * i + j == 11
                                                            ? Colors.yellow
                                                            : Colors.white),
                                            child: Center(
                                              child: AutoSizeText(
                                                  '${keyboard.containsKey(4 * i + j) ? keyboard[4 * i + j] : ""}'),
                                            ),
                                          ),
                                        ),
                                      )),
                            )),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget Option(name, Screen op, Size size) {

    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              option = op;
            });
          },
          child: Container(
            width: size.width * 0.07,
            height: size.height * 0.0281,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.shade200),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: size.width * 0.5,
            height: size.height * 0.0281,
            child: Padding(
              padding: EdgeInsets.only(left: size.width * 0.025),
              child: AutoSizeText(
                '$name',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget MessageBox(String message, Size size) {
    return SizedBox(
      width: size.width * 0.6,
      height: size.height * 0.0375,
      child: Padding(
        padding: EdgeInsets.only(left: size.width * 0.025, bottom: size.height * 0.00625),
        child: AutoSizeText(
          '$message',
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontSize: 18
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget TextBoxWidget(Size size) {
    return Container(
      width: size.width * 0.125,
      height: size.height * 0.035,
      child: TextFormField(
        controller: _textController,
        readOnly: true,
        showCursor: true,
      ),
    );
  }

  Widget AmountTextBox(Size size){
    return Container(
      width: size.width * 0.4,
      // height: size.height * 0.1,
      child: TextFormField(
        maxLines: null,
        controller: _textController,
        keyboardType: TextInputType.multiline,
        readOnly: true,
        showCursor: true,
      ),
    );
  }
  // ignore: non_constant_identifier_names
  Widget OptionWidget(String message, Size size,bool isAmount) {
    return Align(
      alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.75),
      child: Container(
        width: size.width / 2,
        height: size.height / 5,
        child: Column(
          children: [
            MessageBox(message, size),isAmount == true ? AmountTextBox(size) : TextBoxWidget(size)],
        ),
      ),
    );
  }

  void update() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        message = "";
        option = Screen.Home;
      });
    });
  }
}
