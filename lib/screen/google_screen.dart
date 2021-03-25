import 'package:age/age.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortuna/common/data.dart';
import 'package:fortuna/models/user_model.dart';
import 'package:fortuna/screen/form_glow_button.dart';
import 'package:fortuna/screen/login_screen.dart';
import 'package:fortuna/screen/module_screen.dart';
import 'package:fortuna/screen/pdf_viewer.dart';
import 'package:fortuna/services/user_service.dart';
import 'package:fortuna/templates/clip_rect.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleScreen extends StatefulWidget {
  final User user;

  GoogleScreen({Key key, this.user}) : super(key: key);

  @override
  _GoogleScreenState createState() => _GoogleScreenState();
}

class _GoogleScreenState extends State<GoogleScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  String error = '';
  bool loading = false;

  String fullName = '';
  DateTime birthDate;
  String age = '';
  String profession = '';
  String idCard = '';
  bool privacyChecked = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fullName = widget.user.displayName;
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: birthDate != null ? birthDate : DateTime.now(),
      // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: "Seleccionar fecha de nacimiento",
      cancelText: 'Cancelar',
      confirmText: 'Ok',
      locale: const Locale('es', ''),
    );
    if (picked != null && picked != birthDate)
      setState(() {
        birthDate = picked;
        age = Age.dateDifference(
                fromDate: picked, toDate: DateTime.now(), includeToDate: false)
            .years
            .toString();
        print(age);
      });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
//    print("BirthDate $birthDate");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Stack(
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
              left: size.width * 0.08,
              child: Container(
                width: size.width * 0.84,
                height: size.height * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipPath(
                  child: Container(
                    width: size.width * 0.84,
                    height: size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.height * 0.1,
                            ),

                            // Full Name
                            Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black, fontSize: size.height * 0.02),
                                textAlign: TextAlign.center,
                                decoration: textInputDecoration,
                                initialValue: fullName,
                                onChanged: (val) {
                                  setState(() => fullName = val);
                                },
                              ),
                            ),
                            Container(
                              width: size.width * 0.84 * 0.9,
                              child: Divider(
                                height: 1,
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),

                            // Age
                            Container(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                enabled: false,
                                style: TextStyle(
                                    color: Colors.black, fontSize: size.height * 0.02),
                                decoration: textInputDecoration.copyWith(
                                  hintText: age == "" || age == null
                                      ? "Edad"
                                      : "Edad: $age",
                                  hintStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.02),
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 0.84 * 0.3,
                              child: Divider(
                                height: 1,
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),

                            // Birth date
                            Container(
                              width: size.width * 0.84 * 0.7,
                              child: Stack(
                                children: [
                                  Align(
                                    child: Container(
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: size.height * 0.02),
                                        enabled: false,
                                        decoration: textInputDecoration.copyWith(
                                          hintText: birthDate != null
                                              ? "${birthDate.toLocal()}"
                                              .split(' ')[0]
                                              : "Fecha de nacimiento",
                                          hintStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.02),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.calendar_today_outlined, size: size.height * 0.02,),
                                      onPressed: () => _selectDate(context),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: size.width * 0.84 * 0.7,
                              child: Divider(
                                height: 1,
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),

                            // Ocupación
                            Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black, fontSize: size.height * 0.02),
                                textAlign: TextAlign.center,
                                decoration: textInputDecoration.copyWith(
                                  hintText: "Ocupación",
                                  hintStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.02),
                                ),
                                onChanged: (val) {
                                  setState(() => profession = val);
                                },
                              ),
                            ),
                            Container(
                              width: size.width * 0.84 * 0.7,
                              child: Divider(
                                height: 1,
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),


                            // Id Card
                            Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black, fontSize: size.height * 0.02),
                                textAlign: TextAlign.center,
                                decoration: textInputDecoration.copyWith(
                                  hintText: "Cedula",
                                  hintStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.02),
                                ),
                                onChanged: (val) {
                                  setState(() => idCard = val);
                                },
                              ),
                            ),
                            Container(
                              width: size.width * 0.84 * 0.7,
                              child: Divider(
                                height: 1,
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),


                            // Email
                            Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black, fontSize: size.height * 0.02),
                                textAlign: TextAlign.center,
                                decoration: textInputDecoration.copyWith(
                                  hintText: widget.user.email,
                                  hintStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.02),
                                ),
                                enabled: false,
                              ),
                            ),
                            Container(
                              width: size.width * 0.84 * 0.9,
                              child: Divider(
                                height: 1,
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),

                            // Privacy Policy
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: privacyChecked,
                                  onChanged: (val) {
                                    setState(() {
                                      privacyChecked = val;
                                    });
                                  },
                                ),
                                AutoSizeText("aceptar ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.height * 0.019)),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      child: CustomPdfViewer(size: size,),
                                      barrierDismissible: false
                                    );
                                  },
                                  child: AutoSizeText("política de privacidad",
                                      style: TextStyle(
                                          color: Colors.blue[900],
                                          decoration: TextDecoration.underline,
                                          fontSize: size.height * 0.019)),
                                ),
                              ],
                            ),

                            // Register & Back Button
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                width: size.width * 0.84,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: FormGlowButton(buttonText: "Registrarse",),
                                      onTap: () async {
                                        //TODO: Register User
                                        print("Register");
                                        if(!privacyChecked) {
                                          UserService().flutterToast("Acepta la política de privacidad");
                                          return false;
                                        }
                                        fullName = fullName.trim();
                                        profession = profession.trim();
                                        idCard = idCard.trim();
                                        if (fullName == null || fullName.length <= 0) {
                                          UserService().flutterToast("Ingrese su nombre completo");
                                          return false;
                                        }
                                        if (birthDate == null) {
                                          UserService().flutterToast("Seleccionar datos de nacimiento");
                                          return false;
                                        }
                                        if (profession == null || profession.length <= 0) {
                                          UserService().flutterToast("Entra en ocupación.");
                                          return false;
                                        }
                                        if (idCard == null || idCard.length <= 0) {
                                          UserService().flutterToast("Entrar cédula");
                                          return false;
                                        }
                                        if (widget.user.email == null || widget.user.email.length <= 0) {
                                          UserService().flutterToast("Ingrese un correo electrónico valido.");
                                          return false;
                                        }
                                        if (mounted) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                        }
                                        int result = await register();
                                        if (result == 0) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ModuleScreen()));
                                        } else if(result == -1) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) => LoginScreen()));
                                        }
                                        if (mounted) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      },
                                    ),
                                    GestureDetector(
                                      child: FormGlowButton(buttonText: "Regresa",),
                                      onTap: () async {
                                        //TODO: Go Back
                                        print("Go Back");
                                        await UserService().signOutGoogleRegister();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) => LoginScreen()));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  clipper: ProfileClip(),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.15 - size.width * 0.14,
              child: Container(
                width: size.width,
                child: Center(
                  child: Container(
                    width: size.width * 0.28,
                    height: size.width * 0.28,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.user.photoURL,
                          ),
                          fit: BoxFit.fill,
                        ),
                        border: Border.all(color: Colors.grey, width: 5)),
                  ),
                ),
              ),
            ),
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

  Future<int> register() async {
    // Valid Data then create User.
    UserModel userModel = UserModel(
        firebaseId: widget.user.uid,
        emailId: widget.user.email,
        age: int.parse(age),
        fullName: fullName,
        birthDate: "${birthDate.toLocal()}".split(' ')[0],
        password: "",
        idCard: idCard,
        profession: profession,
        isGoogleUser: true,
        profilePhoto: widget.user.photoURL,
    );
    String result = await UserService().registerGoogle(userModel, widget.user);
    if (result == "Successful") {
      UserService().flutterToast("Iniciar sesión correctamente.");
      return 0;
    } else if(result == "ID"){
      return 1;
    } else {
      return -1;
    }
  }
}

var textInputDecoration = InputDecoration(
  border: InputBorder.none,
  hintStyle: TextStyle(color: Colors.black),
  alignLabelWithHint: true,
);

class ProfileClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 2 / 3 + 10, 0);

    path.arcToPoint(Offset(size.width / 3 - 10, 0),
        radius: Radius.circular(size.width / 6));

    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
