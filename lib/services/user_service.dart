import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/models/data_model.dart';
import 'package:fortuna/models/user_model.dart';
import 'package:fortuna/services/syncup_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _idCollection =
      FirebaseFirestore.instance.collection('idcards');
  final DocumentReference _adReference =
      FirebaseFirestore.instance.collection('ads').doc("ad_count");
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  // Check If Exists
  bool isIdExists(String id) {
    Map<String, dynamic> allIds = Prefs().allLocalIds;
    return allIds.containsKey(id);
  }

  bool isEmailExists(String email) {
    Map<String, dynamic> allUsers = Prefs().allLocalUsers;
    return allUsers.containsKey(email);
  }

  // Create User
  Future<bool> createOfflineUser(
      UserModel userModel, DataModel datamodel, File profilePhoto) async {
    int result = Prefs().registerUser(userModel, datamodel);
    if (result == -1) {
      return false;
    }
    String profilePath = Prefs().getPathByIndex(result);
    File _file = await profilePhoto.copy(profilePath);
    print(profilePath);
    return true;
  }

  Future<String> createOnlineUser(
      UserModel userModel, DataModel datamodel, File profilePhoto) async {
    // Check For Id First
    Map<dynamic, dynamic> idData;
    try {
      idData = await _idCollection
          .doc(userModel.idCard)
          .get()
          .then((value) => value.data());
      if (idData != null) {
        return "ID";
      }
    } catch (e) {
      print(e);
    }

    String uid;
    // Create User.
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
              email: userModel.emailId, password: userModel.password))
          .user;
      uid = user.uid;
    } catch (e) {
      print(e);
      return "EMAIL";
    }

    // Upload User Profile to storage.
    final _reference = _storage
        .ref()
        .child('Profiles/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = await _reference.putFile(profilePhoto);
    final String uploadUrl = await uploadTask.ref.getDownloadURL();

    // Create Default Profile of user
    final data = {
      // User Info.
      "updateTime": datamodel.updateTime,
      "emailId": userModel.emailId,
      "fullName": userModel.fullName,
      "birthDate": userModel.birthDate,
      "age": userModel.age,
      "profession": userModel.profession,
      "firebaseId": uid,
      "isGoogleUser": false,
      "profilePhoto": uploadUrl,
      "idCard": userModel.idCard,

      // Data
      "themeColor": datamodel.themeColor,
      "activeIndex": datamodel.activeIndex,
      "score": datamodel.score,
    };

    final idCardData = {"email": userModel.emailId, "uid": uid};

    await _idCollection.doc(userModel.idCard).set(idCardData);
    await _userCollection.doc(uid).set(data);

    userModel.profilePhoto = uploadUrl;
    userModel.firebaseId = uid;
    bool result = await createOfflineUser(userModel, datamodel, profilePhoto);
    if (result == false) {
      print("Already Exist Offline");
      return "FALSE";
    }

    return uid;
  }

  Future<bool> createUser(UserModel userModel, File profilePhoto) async {
    if (isIdExists(userModel.idCard)) {
      flutterToast("Cedula ya en uso");
      return false;
    }
    if (isEmailExists(userModel.emailId)) {
      flutterToast("Correo electrónico ya en uso");
      return false;
    }

    DataModel dataModel = DataModel(
      updateTime: DateTime.now().millisecondsSinceEpoch,
      themeColor: Prefs().defaultThemeColor,
      activeIndex: Prefs().defaultActiveIndex,
      score: Prefs().defaultUserDataMap,
    );

    // Check or Create in Firebase
    String userId = "";
    var connectivityResult = await SyncUpService.checkInternetConnection();
    if (connectivityResult) {
      userId = await createOnlineUser(userModel, dataModel, profilePhoto);
      if (userId == "EMAIL") {
        print("Email Already in Use.");
        flutterToast("Correo electrónico ya en uso");
        return false;
      }
      if (userId == "ID") {
        print("ID Already in Use.");
        flutterToast("Cedula ya en uso");
        return false;
      }
      if(userId == "FALSE") {
        print("Exists Offline Already.");
        flutterToast("El usuario ya existe");
        return false;
      }
      if(userId != null)
        return true;
    } else {
      // Create Local copy
      userModel.firebaseId = userId;
      bool result = await createOfflineUser(userModel, dataModel, profilePhoto);
      if (result == false) {
        print("Already Exist Offline");
        flutterToast("El usuario ya existe");
      }
      return result;
    }
  }

  // To Login User
  int loginOffline(String emailId, String password) {
    return Prefs().loginUser(emailId, password);
  }

  Future<String> loginOnline(
      String emailId, String password, bool isOfflineAvailable) async {
    String loginStatus = "";
    if (isOfflineAvailable) {
      int index = Prefs().allLocalUsers[emailId];
      UserModel userModel = UserModel.fromJson(Prefs().getUserByIndex(index));
      DataModel dataModel = DataModel.fromJson(Prefs().getDataByIndex(index));
      Map<dynamic, dynamic> idData;
      try {
        idData = await _idCollection
            .doc(userModel.idCard)
            .get()
            .then((value) => value.data());
      } catch (e) {
        loginStatus = "Error in Login";
        return loginStatus;
      }

      if (idData == null) {
        // Create
        String profilePath = Prefs().getPathByIndex(index);
        String uid;
        try {
          final User user = (await _auth.createUserWithEmailAndPassword(
                  email: userModel.emailId, password: userModel.password))
              .user;
          uid = user.uid;
        } catch (e) {
          print(e);
          userModel.firebaseId = "null";
          Prefs().setUserByIndex(index, userModel);
          loginStatus = "Successful";
          return loginStatus;
        }

        // Upload User Profile to storage.
        final _reference = _storage
            .ref()
            .child('Profiles/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = await _reference.putFile(File(profilePath));
        final String uploadUrl = await uploadTask.ref.getDownloadURL();

        // Create Default Profile of user
        final data = {
          // User Info.
          "updateTime": dataModel.updateTime,
          "emailId": userModel.emailId,
          "fullName": userModel.fullName,
          "birthDate": userModel.birthDate,
          "age": userModel.age,
          "profession": userModel.profession,
          "firebaseId": uid,
          "isGoogleUser": false,
          "profilePhoto": uploadUrl,
          "idCard": userModel.idCard,

          // Data
          "themeColor": dataModel.themeColor,
          "activeIndex": dataModel.activeIndex,
          "score": dataModel.score,
        };

        final idCardData = {"email": userModel.emailId, "uid": uid};

        await _idCollection.doc(userModel.idCard).set(idCardData);
        await _userCollection.doc(uid).set(data);

        userModel.firebaseId = uid;
        userModel.profilePhoto = uploadUrl;
        userModel.shouldUpdate = false;
        Prefs().setUserByIndex(index, userModel);
        loginStatus = "Successful";
        return loginStatus;
      }
      else {
        // Check If valid
        if (emailId != idData['email']) {
          userModel.firebaseId = "null";
          Prefs().setUserByIndex(index, userModel);
          loginStatus = "Successful";
          return loginStatus;
        }
        // Update
        User _user;
        try {
          _user = (await _auth.signInWithEmailAndPassword(
                  email: emailId, password: password))
              .user;
          loginStatus = "Successful";
        } catch (e) {
          print(e);
          if (e.message ==
              "The password is invalid or the user does not have a password.") {
            userModel.firebaseId = "null";
            Prefs().setUserByIndex(index, userModel);
            loginStatus = "Successful";
            return loginStatus;
          } else {
            loginStatus = "Error in Login";
            return loginStatus;
          }
        }

        bool result = Prefs().updateUserData(userModel, dataModel);
        if (!result) {
          Map<String, dynamic> allUsers = Prefs().allLocalUsers;
          int index = allUsers[userModel.emailId];
          DataModel newDataModel =
              DataModel.fromJson(Prefs().getDataByIndex(index));
          Map<dynamic, dynamic> onlineData = await _userCollection
              .doc(_user.uid)
              .get()
              .then((value) => value.data());
          onlineData["updateTime"] = newDataModel.updateTime;
          onlineData["activeIndex"] = newDataModel.activeIndex;
          onlineData["score"] = newDataModel.score;
          onlineData["themeColor"] = newDataModel.themeColor;
          await _userCollection.doc(_user.uid).set(onlineData);
        }
        await updateProfilePhoto(userModel);
        return loginStatus;
      }
    }
    else {
      // No Offline Data Available So Login And Download Data.
      User _user;
      try {
        _user = (await _auth.signInWithEmailAndPassword(
            email: emailId, password: password))
            .user;
        loginStatus = "Successful";
      } catch (e) {
        print(e);
        if (e.message ==
            "There is no user record corresponding to this identifier. The user may have been deleted.") {
          loginStatus = "No User Exists";
          return loginStatus;
        } else if (e.message ==
            "The password is invalid or the user does not have a password.") {
          loginStatus = "Invalid Password";
          return loginStatus;
        } else {
          loginStatus = "Error in Login";
          return loginStatus;
        }
      }

      Map<dynamic, dynamic> onlineData = await _userCollection
          .doc(_user.uid)
          .get()
          .then((value) => value.data());
      UserModel userModel = UserModel(
          isGoogleUser: onlineData["isGoogleUser"],
          profession: onlineData["profession"],
          password: password,
          birthDate: onlineData["birthDate"],
          fullName: onlineData["fullName"],
          idCard: onlineData["idCard"],
          age: onlineData["age"],
          emailId: onlineData["emailId"],
          firebaseId: onlineData["firebaseId"],
          profilePhoto: onlineData["profilePhoto"]);
      DataModel dataModel = DataModel(
          updateTime: onlineData["updateTime"],
          score: onlineData["score"],
          themeColor: onlineData["themeColor"],
          activeIndex: onlineData["activeIndex"]);

      // Save Locally
      int index = Prefs().addUserData(userModel, dataModel);
          // TODO: Download Profile Photo
          var response = await get(onlineData["profilePhoto"]);
      String filePath = Prefs().getPathByIndex(index);
      File _downloadPhoto = File(filePath);
      print(_downloadPhoto);
      await _downloadPhoto.writeAsBytes(response.bodyBytes);

      return loginStatus;
    }
  }

  Future<String> loginOnlineById(
      String id, String password, bool isOfflineAvailable) async {
    String loginStatus = "";

    // Get Email Id from Firebase
    Map<dynamic, dynamic> idData;
    try {
      idData = await _idCollection
          .doc(id)
          .get()
          .then((value) => value.data());
    } catch (e) {
      loginStatus = "Error in Login";
      return loginStatus;
    }

    if (isOfflineAvailable) {
      int index = Prefs().allLocalIds[id];
      UserModel userModel = UserModel.fromJson(Prefs().getUserByIndex(index));
      DataModel dataModel = DataModel.fromJson(Prefs().getDataByIndex(index));

      if (idData == null) {
        // Create
        String profilePath = Prefs().getPathByIndex(index);
        String uid;
        try {
          final User user = (await _auth.createUserWithEmailAndPassword(
              email: userModel.emailId, password: userModel.password))
              .user;
          uid = user.uid;
        } catch (e) {
          print(e);
          userModel.firebaseId = "null";
          Prefs().setUserByIndex(index, userModel);
          loginStatus = "Successful";
          return loginStatus;
        }

        // Upload User Profile to storage.
        final _reference = _storage
            .ref()
            .child('Profiles/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = await _reference.putFile(File(profilePath));
        final String uploadUrl = await uploadTask.ref.getDownloadURL();

        // Create Default Profile of user
        final data = {
          // User Info.
          "updateTime": dataModel.updateTime,
          "emailId": userModel.emailId,
          "fullName": userModel.fullName,
          "birthDate": userModel.birthDate,
          "age": userModel.age,
          "profession": userModel.profession,
          "firebaseId": uid,
          "isGoogleUser": false,
          "profilePhoto": uploadUrl,
          "idCard": userModel.idCard,

          // Data
          "themeColor": dataModel.themeColor,
          "activeIndex": dataModel.activeIndex,
          "score": dataModel.score,
        };

        final idCardData = {"email": userModel.emailId, "uid": uid};

        await _idCollection.doc(userModel.idCard).set(idCardData);
        await _userCollection.doc(uid).set(data);

        userModel.firebaseId = uid;
        userModel.profilePhoto = uploadUrl;
        userModel.shouldUpdate = false;
        Prefs().setUserByIndex(index, userModel);
        loginStatus = "Successful";
        return loginStatus;
      }
      else {
        // Check If valid
        String emailId = idData["email"];
        if (emailId != userModel.emailId) {
          userModel.firebaseId = "null";
          Prefs().setUserByIndex(index, userModel);
          loginStatus = "Successful";
          return loginStatus;
        }
        // Update
        User _user;
        try {
          _user = (await _auth.signInWithEmailAndPassword(
              email: emailId, password: password))
              .user;
          loginStatus = "Successful";
        } catch (e) {
          print(e);
          if (e.message ==
              "The password is invalid or the user does not have a password.") {
            userModel.firebaseId = "null";
            Prefs().setUserByIndex(index, userModel);
            loginStatus = "Successful";
            return loginStatus;
          } else {
            loginStatus = "Error in Login";
            return loginStatus;
          }
        }

        bool result = Prefs().updateUserData(userModel, dataModel);
        if (!result) {
          Map<String, dynamic> allUsers = Prefs().allLocalUsers;
          int index = allUsers[userModel.emailId];
          DataModel newDataModel =
          DataModel.fromJson(Prefs().getDataByIndex(index));
          Map<dynamic, dynamic> onlineData = await _userCollection
              .doc(_user.uid)
              .get()
              .then((value) => value.data());
          onlineData["updateTime"] = newDataModel.updateTime;
          onlineData["activeIndex"] = newDataModel.activeIndex;
          onlineData["score"] = newDataModel.score;
          onlineData["themeColor"] = newDataModel.themeColor;
          await _userCollection.doc(_user.uid).set(onlineData);
        }
        await updateProfilePhoto(userModel);
        return loginStatus;
      }
    }
    else {
      // No Offline Data Available So Login And Download Data.
      if(idData == null) {
        // Not Exists
        loginStatus = "No User Exists";
        return loginStatus;
      }

      String emailId = idData["email"];
      User _user;
      try {
        _user = (await _auth.signInWithEmailAndPassword(
            email: emailId, password: password))
            .user;
        loginStatus = "Successful";
      } catch (e) {
        print(e);
        if (e.message ==
            "There is no user record corresponding to this identifier. The user may have been deleted.") {
          loginStatus = "No User Exists";
          return loginStatus;
        }
        else if (e.message ==
            "The password is invalid or the user does not have a password.") {
          loginStatus = "Invalid Password";
          return loginStatus;
        }
        else {
          loginStatus = "Error in Login";
          return loginStatus;
        }
      }

      Map<dynamic, dynamic> onlineData = await _userCollection
          .doc(_user.uid)
          .get()
          .then((value) => value.data());
      UserModel userModel = UserModel(
          isGoogleUser: onlineData["isGoogleUser"],
          profession: onlineData["profession"],
          password: password,
          birthDate: onlineData["birthDate"],
          fullName: onlineData["fullName"],
          idCard: onlineData["idCard"],
          age: onlineData["age"],
          emailId: onlineData["emailId"],
          firebaseId: onlineData["firebaseId"],
          profilePhoto: onlineData["profilePhoto"]);
      DataModel dataModel = DataModel(
          updateTime: onlineData["updateTime"],
          score: onlineData["score"],
          themeColor: onlineData["themeColor"],
          activeIndex: onlineData["activeIndex"]);

      // Save Locally
      int index = Prefs().addUserData(userModel, dataModel);
      // TODO: Download Profile Photo
      var response = await get(onlineData["profilePhoto"]);
      String filePath = Prefs().getPathByIndex(index);
      File _downloadPhoto = File(filePath);
      print(_downloadPhoto);
      await _downloadPhoto.writeAsBytes(response.bodyBytes);

      return loginStatus;
    }
  }

  Future<bool> loginUser(String emailId, String id, String password) async {
    int offStatus;
    if(emailId != "") {
      offStatus = loginOffline(emailId, password);
      if (offStatus == 1) {
        flutterToast("Contraseña invalida.");
        return false;
      }
    } else if(id != "") {
      offStatus = Prefs().loginUserById(id, password);
      if (offStatus == 1) {
        flutterToast("Contraseña invalida.");
        return false;
      }
    }


    bool isOffline = offStatus == 0;
    var connectivityResult = await SyncUpService.checkInternetConnection();
    if (!connectivityResult) {
      flutterToast("Sin internet");
      Prefs().signOutUser();
      return false;
    }

    String onLineResponse;
    if(emailId != "") {
      onLineResponse = await loginOnline(emailId, password, isOffline);
    } else if(id != "") {
      onLineResponse = await loginOnlineById(id, password, isOffline);
    }
    print(onLineResponse);
    if (onLineResponse == "Successful") {
      flutterToast("Acceso exitoso.");
      loginOffline(emailId, password);
      return true;
    }
    else if (onLineResponse == "Error in Login") {
      flutterToast("Error al iniciar sesión.");
      return false;
    }
    else if (onLineResponse == "Invalid Password") {
      if (isOffline == true) {
        Prefs().blackListUser(emailId);
        loginOffline(emailId, password);
        flutterToast("Acceso exitoso.");
        return true;
      } else {
        flutterToast("Contraseña invalida.");
        return false;
      }
    }
    else if (onLineResponse == "No User Exists") {
      flutterToast("No existe ningún usuario.");
      return false;
    }
    else {
      flutterToast("Error al iniciar sesión.");
      return false;
    }
  }

  Future<bool> loginUserById(String id, String password) async {
    int result = Prefs().loginUserById(id, password);
    if (result == -1) {
      flutterToast("El usuario no existe.");
      return false;
    } else if (result == 1) {
      flutterToast("Contraseña invalida.");
      return false;
    }
    flutterToast("Iniciar sesión correctamente.");
    return true;
  }

  // Login Via Google
  Future<dynamic> GoogleSignIn() async {
    var connectivityResult = await SyncUpService.checkInternetConnection();
    if (!connectivityResult) {
      Fluttertoast.showToast(msg: "Sin internet");
      return "No Internet.";
    }

    UserCredential userCredential;
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      userCredential = await _auth.signInWithCredential(credential);
    } catch (e) {
      return null;
    }

    User _user = userCredential.user;

    // Check If user Already there or not.
    Map<dynamic, dynamic> onlineData;
    try {
      onlineData = await _userCollection
          .doc(_user.uid)
          .get()
          .then((value) => value.data());
      if (onlineData == null) {
        return _user;
      }
    } catch (e) {
      return _user;
    }

    // If User Already Registered.
    await syncGoogleData(onlineData, _user);
    Fluttertoast.showToast(msg: "Iniciar sesión correctamente.");
    return "Successful Login.";
  }

  Future<void> syncGoogleData(Map onlineData, User user) async {
    UserModel userModel = UserModel(
        profilePhoto: onlineData["profilePhoto"],
        isGoogleUser: true,
        profession: onlineData["profession"],
        password: "",
        idCard: onlineData["idCard"],
        birthDate: onlineData["birthDate"],
        fullName: onlineData["fullName"],
        age: onlineData["age"],
        emailId: onlineData["emailId"],
        firebaseId: user.uid);
    DataModel dataModel = DataModel(
        updateTime: onlineData["updateTime"],
        score: onlineData["score"],
        themeColor: onlineData["themeColor"],
        activeIndex: onlineData["activeIndex"]);
    Map<String, dynamic> allUsers = Prefs().allLocalUsers;
    if (!allUsers.containsKey(userModel.emailId)) {
      Prefs().addUserData(userModel, dataModel);
      Map<String, dynamic> allUsers = Prefs().allLocalUsers;
      int index = allUsers[userModel.emailId];

      print("We Added User");
      // Download User Profile to local storage..
      var response = await get(userModel.profilePhoto);
      String filePath = Prefs().getPathByIndex(index);
      File _downloadPhoto = File(filePath);
      print("Download Google: $_downloadPhoto");
      await _downloadPhoto.writeAsBytes(response.bodyBytes);
    } else {
      bool result = Prefs().updateUserData(userModel, dataModel);
      if (!result) {
        Map<String, dynamic> allUsers = Prefs().allLocalUsers;
        int index = allUsers[userModel.emailId];
        DataModel newDataModel =
            DataModel.fromJson(Prefs().getDataByIndex(index));
        onlineData["updateTime"] = newDataModel.updateTime;
        onlineData["activeIndex"] = newDataModel.activeIndex;
        onlineData["score"] = newDataModel.score;
        onlineData["themeColor"] = newDataModel.themeColor;
        await _userCollection.doc(user.uid).set(onlineData);
      }

      // Update Profile Photo too..
      await updateProfilePhoto(userModel);
    }
    Prefs().loginUser(userModel.emailId, "");
  }

  Future<String> registerGoogle(UserModel userModel, User user) async {
    Map<dynamic, dynamic> idData;
    try {
      idData = await _idCollection
          .doc(userModel.idCard)
          .get()
          .then((value) => value.data());
      if (idData != null) {
        flutterToast("Cedula ya en uso.");
        return "ID";
      }
    } catch (e) {
      print(e);
    }

    DataModel dataModel = DataModel(
      updateTime: DateTime.now().millisecondsSinceEpoch,
      themeColor: Prefs().defaultThemeColor,
      activeIndex: Prefs().defaultActiveIndex,
      score: Prefs().defaultUserDataMap,
    );

    // Create Default Profile of user
    final data = {
      // User Info.
      "updateTime": dataModel.updateTime,
      "emailId": userModel.emailId,
      "fullName": userModel.fullName,
      "birthDate": userModel.birthDate,
      "age": userModel.age,
      "idCard": userModel.idCard,
      "profession": userModel.profession,
      "firebaseId": user.uid,
      "isGoogleUser": true,
      "profilePhoto": user.photoURL,

      // Data
      "themeColor": dataModel.themeColor,
      "activeIndex": dataModel.activeIndex,
      "score": dataModel.score,
    };

    final idCardData = {"email": userModel.emailId, "uid": user.uid};

    try {
      await _userCollection.doc(user.uid).set(data);
      await _idCollection.doc(userModel.idCard).set(idCardData);

      // Add and Login user.
      userModel.firebaseId = user.uid;
      userModel.profilePhoto = user.photoURL;
      Prefs().addUserData(userModel, dataModel);

      Map<String, dynamic> allUsers = Prefs().allLocalUsers;
      int index = allUsers[userModel.emailId];

      // Download User Profile to local storage..
      var response = await get(user.photoURL);
      String filePath = Prefs().getPathByIndex(index);
      File _downloadPhoto = File(filePath);
      print(_downloadPhoto);
      await _downloadPhoto.writeAsBytes(response.bodyBytes);

      Prefs().loginUser(userModel.emailId, "");
    } catch (e) {
      return "Error in Login";
    }
    return "Successful";
  }

  // LogOut User
  Future<void> signOut() async {
    try {
      if (Prefs().isGoogleUser) await _googleSignIn.signOut();
    } catch (e) {
      Fluttertoast.showToast(msg: "Sin internet.");
    }
    Prefs().signOutUser();
  }

  Future<void> signOutGoogleRegister() async {
    try {
      await _googleSignIn.signOut();
      Prefs().signOutUser();
    } catch (e) {
      print(e);
    }
  }

  // To Update Users Profile Photo
  Future<void> updateProfilePhoto(UserModel userModel) async {
    Map<String, dynamic> allUsers = Prefs().allLocalUsers;
    if(!allUsers.containsKey(userModel.emailId)) {
      return;
    }
    int indexNum = allUsers[userModel.emailId];
    UserModel tempUser = UserModel.fromJson(Prefs().getUserByIndex(indexNum));
    if(userModel.profilePhoto != tempUser.profilePhoto) {
      if(userModel.shouldUpdate) {
        // Upload User Profile to storage.
        final _reference = _storage
            .ref()
            .child('Profiles/${DateTime.now().millisecondsSinceEpoch}.jpg');
        File profilePhoto = File(Prefs().getPathByIndex(indexNum));
        final uploadTask = await _reference.putFile(profilePhoto);
        final String uploadUrl = await uploadTask.ref.getDownloadURL();
        await _userCollection.doc(userModel.firebaseId).update({"profilePhoto": uploadUrl});

        tempUser.profilePhoto = uploadUrl;
        Prefs().setUserByIndex(indexNum, tempUser);
      } else {
        // Save Locally
        var response = await get(userModel.profilePhoto);
        String filePath = Prefs().getPathByIndex(indexNum);
        File _downloadPhoto = File(filePath);
        print(_downloadPhoto);
        await _downloadPhoto.writeAsBytes(response.bodyBytes);

        tempUser.profilePhoto = userModel.profilePhoto;
        Prefs().setUserByIndex(indexNum, tempUser);
      }
    }
  }

  Future<List<String>> getAdCounts() async {
    List<String> links = [];
    try {
      final data = await _adReference.get().then((value) => value.data());
      links.add(data["main_ad"]);
      for(String link in data["links"]) {
        links.add(link);
        print("Link : $link");
      }
    } catch (e) {
      return [];
    }
    return links;
  }

  void flutterToast(String msg) {
    Fluttertoast.showToast(
        msg: msg, backgroundColor: Colors.black, textColor: Colors.white);
  }
}
