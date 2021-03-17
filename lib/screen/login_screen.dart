import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fortuna/screen/form_glow_button.dart';
import 'package:fortuna/screen/google_screen.dart';
import 'package:fortuna/screen/module_screen.dart';
import 'package:fortuna/screen/register_screen.dart';
import 'package:fortuna/services/syncup_service.dart';
import 'package:fortuna/services/user_service.dart';
import 'package:fortuna/templates/clip_rect.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp idRegex = RegExp(r"^[0-9]+$");

  String email = '';
  String id = '';
  String password = '';
  bool isLoading = false;

  bool isInternet = false;
  bool _obSecure = true;


  @override
  void initState() {
    // TODO: implement initState
    checkInternet();
    super.initState();
  }

  Future<void> checkInternet() async {
    isInternet = await SyncUpService.checkInternetConnection();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipPath(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage("asset/image/home_background.png"),
                    )),
                  ),
                  Container(
                    color: Colors.white.withOpacity(0.2),
                  )
                ],
              ),
              clipper: CustomRect(),
            ),
            Positioned(
              top: size.height * 0.15,
              child: Container(
                width: size.width,
                height: size.height * 0.06,
                child: Column(children: <Widget>[
                  Center(
                      child: Container(
                    height: size.height * 0.03,
                    child: AutoSizeText(
                      "Por favor, ingrese sus datos",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  )),
                  Center(
                      child: Container(
                    height: size.height * 0.03,
                    child: AutoSizeText(
                      'personales',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  )),
                ]),
              ),
            ),

            // Form
            Positioned  (
              top: size.height * 0.25,
              child: Container(
                  child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email or ID
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0),
                          borderRadius: BorderRadius.all(
                              Radius.circular(size.height * 0.05 * 0.4)),
                          color: Colors.black.withOpacity(0.5)),
                      width: size.width * 0.9,
                      height: size.height * 0.05,
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.02),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: textInputDecoration.copyWith(
                          hintText: isInternet ? 'Correo electrónico / Cedula' : 'Cedula',
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.02),
                          prefixIcon: Icon(
                            isInternet ? Icons.email : Icons.perm_identity_outlined,
                            color: Colors.white,
                            size: size.height * 0.03,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => isInternet ? email = val : id = val);
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),

                    // Password
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 0),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(size.height * 0.05 * 0.4)),
                              color: Colors.black.withOpacity(0.5)),
                          width: size.width * 0.9,
                          height: size.height * 0.05,
                          child: TextFormField(
                            style: TextStyle(
                                color: Colors.white, fontSize: size.height * 0.02),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Contraseña',
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.02),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: size.height * 0.03,
                              ),
                            ),
                            obscureText: _obSecure,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              _obSecure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: size.height * 0.02,
                            ),
                            onPressed: () {
                              setState(() {
                                _obSecure = !_obSecure;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),

                    // Login Button
                    GestureDetector(
                      child: FormGlowButton(buttonText: "Iniciar sesión",),
                      onTap: () async {
                        //TODO: logIn User
                        print("Login");
                        if (mounted) {
                          setState(() {
                            isLoading = true;
                          });
                        }
                        bool result = await login();
                        if (result) {
                          // TODO: Navigate to next screen.
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ModuleScreen()));
                        }
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              )),
            ),
            Positioned(
              top: size.height * 0.5,
              child: Container(
                width: size.width * 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 3,
                      color: Colors.white,
                      width: size.width * 0.35,
                    ),
                    Container(
                      width: size.width * 0.04,
                      height: size.width * 0.04,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3, color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 3,
                      color: Colors.white,
                      width: size.width * 0.35,
                    )
                  ],
                ),
              ),
            ),

            // Google
            if(isInternet)
              Positioned(
                top: size.height * 0.6,
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black.withOpacity(0.5), width: 2),
                          borderRadius: BorderRadius.all(
                              Radius.circular(size.height * 0.05 * 0.4)),
                          color: Colors.white.withOpacity(0.8)),
                      padding: EdgeInsets.only(left: size.width * 0.025),
                      width: size.width * 0.9,
                      height: size.height * 0.05,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "asset/image/google.ico",
                            height: size.height * 0.03,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: size.width * 0.025,
                          ),
                          AutoSizeText(
                            "Continúe con Google",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.020),
                          )
                        ],
                      )),
                  onTap: () async {
                    //TODO: Google SignIn
                    if (mounted) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                    dynamic user = await UserService().GoogleSignIn();
//                    print("Returned User: $user");
                    if(user != null) {
                      if (user == "No Internet.")
                        print(user);
                      else if (user == "Successful Login.") {
                        // TODO: Navigate to next screen.
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModuleScreen()));
                        print(user);
                      } else if (user is User) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GoogleScreen(
                                      user: user,
                                    )));
                      } else {
                        UserService().flutterToast("Error al iniciar sesión");
                      }
                    }
                    if (mounted) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
              ),

            // Register
            Positioned(
              top: size.height * 0.67,
              child: GestureDetector(
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.5), width: 2),
                        borderRadius: BorderRadius.all(
                            Radius.circular(size.height * 0.05 * 0.4)),
                        color: Colors.white.withOpacity(0.8)),
                    width: size.width * 0.9,
                    height: size.height * 0.05,
                    child: Center(
                      child: AutoSizeText(
                        "¿Aún no tiene cuenta?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.020),
                      ),
                    )),
                onTap: () async {
                  //TODO: Register Screen
                  print("Registrar");
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => RegisterScreen()));
                },
              ),
            ),

            // Ad
            Positioned(
              left: size.width * 0.05,
              top: size.height * 0.92,
              child: Image.asset(
                "asset/image/logo1.png",
                width: size.width / 3,
                fit: BoxFit.contain,
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

  Future<bool> login() async {
    email = email.trim();
    password = password.trim();
    id = id.trim();
    if (password.length > 16 || password.length < 8) {
      UserService().flutterToast("La contraseña debe tener entre 8 y 16 caracteres.");
      return false;
    }

    if(isInternet) {
      bool result;
      if (emailRegex.hasMatch(email)) {
        result = await UserService().loginUser(email, "", password);
      } else if(idRegex.hasMatch(email)) {
        result = await UserService().loginUser("", email, password);
      } else {
        UserService().flutterToast("Ingrese una correo electrónico o cédula válido");
        return false;
      }

      if (result) {
        print("Successful.");
        return true;
      } else {
        print("Not exists or wrong password.");
        return false;
      }
    }
    else {
      if (id == null || id.length <= 0) {
        UserService().flutterToast("Ingrese una cédula válida");
        return false;
      }
      bool result = await UserService().loginUserById(id, password);
      if (result) {
        print("Successful.");
        return true;
      } else {
        print("Not exists or wrong password.");
        return false;
      }
    }
  }
}

var textInputDecoration = InputDecoration(
  border: InputBorder.none,
  alignLabelWithHint: true,
);
