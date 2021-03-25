import 'dart:io';

import 'package:age/age.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fortuna/common/data.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/models/user_model.dart';
import 'package:fortuna/screen/form_glow_button.dart';
import 'package:fortuna/screen/login_screen.dart';
import 'package:fortuna/screen/pdf_viewer.dart';
import 'package:fortuna/services/user_service.dart';
import 'package:fortuna/templates/clip_rect.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  String error = '';
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String imagePath = "asset/image/user.jpg";
  File profilePhoto;
  String fullName = '';
  DateTime birthDate;
  String age = '';
  String profession = '';
  String email = '';
  String password = '';
  String confirmPassword;
  String identificationCard = '';
  bool _obSecure = true;
  bool privacyChecked = false;

  bool isLoading = false;

  void _showImageOption(Size size) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      builder: (builder) {
        return Container(
          height: size.height * 0.15,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 0.03,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await _selectImage(true);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: size.height * 0.07,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
//                      color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        size: size.height * 0.04,
                      ),
                    ),
                  ),
                  AutoSizeText("Cámara")
                ],
              ),
              SizedBox(
                width: size.width * 0.1,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await _selectImage(false);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: size.height * 0.07,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.photo_camera_back,
                        size: size.height * 0.04,
                      ),
                    ),
                  ),
                  AutoSizeText("Fotos"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectImage(bool isCamera) async {
    final status = await Permission.storage.request();
    print(status);
    if (status != PermissionStatus.granted) {
      UserService().flutterToast("Permiso denegado.");
      return;
    }

    final pickedFile = await picker.getImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      final File _image = File(pickedFile.path);

      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
      );

      if (croppedFile != null) {
        profilePhoto = croppedFile;
      } else {
        print('Not Cropped');
      }
    } else {
      print('No image selected.');
      return;
    }
    setState(() {});
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
      locale: Locale("es", ''),
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
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
                              height: size.width * 0.84 / 6,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),

                            // Full Name
                            Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.height * 0.02),
                                textAlign: TextAlign.center,
                                decoration: textInputDecoration.copyWith(
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.height * 0.02),
                                  hintText: "Nombre completo",
                                ),
                                validator: (val) => val.isEmpty
                                    ? 'Ingrese el nombre completo'
                                    : null,
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
                                    color: Colors.black,
                                    fontSize: size.height * 0.02),
                                decoration: textInputDecoration.copyWith(
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.height * 0.02),
                                  hintText: age == "" || age == null
                                      ? "Edad"
                                      : "Edad: $age",
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
                                        decoration:
                                            textInputDecoration.copyWith(
                                          hintText: birthDate != null
                                              ? "${birthDate.toLocal()}"
                                                  .split(' ')[0]
                                              : "Fecha de nacimiento",
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: size.height * 0.02),
                                        ),
                                        enabled: false,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.calendar_today_outlined,
                                        size: size.height * 0.02,
                                      ),
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
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.height * 0.02),
                                decoration: textInputDecoration.copyWith(
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.height * 0.02),
                                  hintText: "Ocupación",
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

                            // Identification
                            Container(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.height * 0.02),
                                decoration: textInputDecoration.copyWith(
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.height * 0.02),
                                  hintText: "Cedula",
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  setState(() => identificationCard = val);
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
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.height * 0.02),
                                decoration: textInputDecoration.copyWith(
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.height * 0.02),
                                  hintText: "Correo electrónico",
                                ),
                                validator: (val) =>
                                    val.isEmpty || !emailRegex.hasMatch(val)
                                        ? 'Ingrese un email valido'
                                        : null,
                                onChanged: (val) {
                                  setState(() => email = val);
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

                            // Password
                            Stack(
                              children: [
                                Container(
                                  width: size.width * 0.84 * 0.7,
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.height * 0.02),
                                    textAlign: TextAlign.center,
                                    decoration: textInputDecoration.copyWith(
                                      hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: size.height * 0.02),
                                      hintText: "Contraseña",
                                    ),
                                    validator: (val) => val.length < 8 ||
                                            val.length > 16
                                        ? 'debe tener entre 8 y 16 caracteres'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    obscureText: _obSecure,
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
                                )
                              ],
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

                            // Confirm Password
                            Container(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.height * 0.02),
                                decoration: textInputDecoration.copyWith(
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.height * 0.02),
                                  hintText: "Confirmar contraseña",
                                ),
                                validator: (val) => val != password
                                    ? 'confirmar que la contraseña no coincide'
                                    : null,
                                onChanged: (val) {
                                  setState(() => confirmPassword = val);
                                },
                                obscureText: true,
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
                                        fontSize: size.height * 0.017)),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      child: CustomPdfViewer(size: size,),
                                      barrierDismissible: false,
                                    );
                                  },
                                  child: AutoSizeText("política de privacidad",
                                      style: TextStyle(
                                          color: Colors.blue[900],
                                          decoration: TextDecoration.underline,
                                          fontSize: size.height * 0.017)),
                                ),
                              ],
                            ),

                            // Register Button
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: GestureDetector(
                                child: FormGlowButton(
                                  buttonText: "Registrarse",
                                ),
                                onTap: () async {
                                  //TODO: Register User
                                  print("Register");
                                  if (mounted) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                  }
                                  bool result = await register();
                                  if (result == true) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  }
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                              ),
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
                  child: GestureDetector(
                    onTap: () {
                      _showImageOption(size);
                    },
                    child: Container(
                      width: size.width * 0.28,
                      height: size.width * 0.28,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: profilePhoto == null
                                ? AssetImage(
                                    imagePath,
                                  )
                                : FileImage(profilePhoto),
                            fit: BoxFit.fill,
                          ),
                          border: Border.all(color: Colors.grey, width: 5)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.86,
              child: Container(
                width: size.width,
                height: size.height * 0.05,
                child: GestureDetector(
                  child: Container(
                      height: size.height * 0.05,
                      child: Center(
                          child: AutoSizeText(
                        "¿Ya tiene cuenta? Ingrese",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))),
                  onTap: () {
                    //TODO: Register Screen
                    print("Login");
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
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

  Future<bool> register() async {
    if(!privacyChecked) {
      UserService().flutterToast("Acepta la política de privacidad");
      return false;
    }

    fullName = fullName.trim();
    profession = profession.trim();
    email = email.trim();
    password = password.trim();
    print("$fullName $birthDate $age $profession $email $password");
    if (fullName == null || fullName.length <= 0) {
      UserService().flutterToast("Ingrese su nombre completo");
      return false;
    }
    if (birthDate == null) {
      UserService().flutterToast("Seleccionar fecha de nacimiento");
      return false;
    }
    if (profession == null || profession.length <= 0) {
      UserService().flutterToast("Entra en Ocupación.");
      return false;
    }
    if (identificationCard == null || identificationCard.length <= 0) {
      UserService().flutterToast("Ingrese una cédula válida");
      return false;
    }
    if (email == null || email.length <= 0 || !emailRegex.hasMatch(email)) {
      UserService().flutterToast("Ingrese un correo electrónico válida.");
      return false;
    }
    if (password.length > 16 || password.length < 8) {
      UserService()
          .flutterToast("La contraseña debe tener entre 8 y 16 caracteres.");
      return false;
    }
    if (confirmPassword != password) {
      UserService()
          .flutterToast("Confirmar contraseña y contraseña deben ser iguales.");
      return false;
    }

    // Valid Data then create User.
    UserModel userModel = UserModel(
        emailId: email,
        age: int.parse(age),
        fullName: fullName,
        birthDate: "${birthDate.toLocal()}".split(' ')[0],
        idCard: identificationCard,
        password: password,
        profession: profession,
        isGoogleUser: false);
    if (profilePhoto == null) {
      profilePhoto = File(Prefs().getDefaultPath());
    }
    bool result = await UserService().createUser(userModel, profilePhoto);
    if (result) {
      print("Successful.");
      UserService().flutterToast(
          "Registrarse correctamente.\nAhora puede iniciar sesión.");
    } else {
      print("Exists Already");
    }
    return result;
  }
}

var textInputDecoration = InputDecoration(
  border: InputBorder.none,
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
