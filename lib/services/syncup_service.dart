import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fortuna/common/prefs.dart';
import 'package:fortuna/models/data_model.dart';
import 'package:fortuna/models/user_model.dart';
import 'package:http/http.dart';

class SyncUpService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _idCollection =
      FirebaseFirestore.instance.collection('idcards');
  static final SyncUpService _instance = SyncUpService._internal();

  factory SyncUpService() {
    return _instance;
  }

  SyncUpService._internal();


  // To Update Users Profile Photo
  Future<void> updateProfilePhoto(UserModel userModel, UserModel onlineUserModel, int index) async {
    if(userModel.profilePhoto != onlineUserModel.profilePhoto) {
      if(userModel.shouldUpdate) {
        // Upload User Profile to storage.
        final _reference = _storage
            .ref()
            .child('Profiles/${DateTime.now().millisecondsSinceEpoch}.jpg');
        File profilePhoto = File(Prefs().getPathByIndex(index));
        final uploadTask = await _reference.putFile(profilePhoto);
        final String uploadUrl = await uploadTask.ref.getDownloadURL();
        await _userCollection.doc(onlineUserModel.firebaseId).update({"profilePhoto": uploadUrl});

        userModel.profilePhoto = uploadUrl;
        userModel.firebaseId = onlineUserModel.firebaseId;
        Prefs().setUserByIndex(index, userModel);
      } else {
        // Save Locally
        var response = await get(onlineUserModel.profilePhoto);
        String filePath = Prefs().getPathByIndex(index);
        File _downloadPhoto = File(filePath);
        print(_downloadPhoto);
        _downloadPhoto.writeAsBytes(response.bodyBytes);

        userModel.profilePhoto = onlineUserModel.profilePhoto;
        Prefs().setUserByIndex(index, userModel);
      }
    }
  }

  Future<void> syncUpUser(
      UserModel userModel, DataModel dataModel, int index) async {
    if (userModel.firebaseId == "null") {
      print("Index $index, Case 0");
      return;
    }
    else if (userModel.firebaseId == "" || userModel.firebaseId == null) {
      print("Index $index, Case 1");
      // Check For Email/ID Map
      Map<dynamic, dynamic> idData;
      try {
        idData = await _idCollection
            .doc(userModel.idCard)
            .get()
            .then((value) => value.data());
      } catch (e) {
        print(e);
      }

      User _user;
      String loginStatus;
      if (idData == null) {
        try {
          try {
            final User user = (await _auth.createUserWithEmailAndPassword(
                    email: userModel.emailId, password: userModel.password))
                .user;
            userModel.firebaseId = user.uid;
            Prefs().setUserByIndex(index, userModel);
          } catch (e) {
            userModel.firebaseId = "null";
            Prefs().setUserByIndex(index, userModel);
            return;
          }

          // Upload Profile Picture
          File profilePhoto = File(Prefs().getPathByIndex(index));
          final _reference = _storage
              .ref()
              .child('Profiles/${DateTime.now().millisecondsSinceEpoch}.jpg');
          final uploadTask = await _reference.putFile(profilePhoto);
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
            "firebaseId": userModel.firebaseId,
            "idCard": userModel.idCard,
            "isGoogleUser": false,
            "profilePhoto": uploadUrl,
            // Data
            "themeColor": dataModel.themeColor,
            "activeIndex": dataModel.activeIndex,
            "score": dataModel.score,
          };
          final idCardData = {
            "email": userModel.emailId,
            "uid": userModel.firebaseId
          };

          await _idCollection.doc(userModel.idCard).set(idCardData);
          await _userCollection.doc(userModel.firebaseId).set(data);
          return;
        } catch (e) {
          return;
        }
      }
      else {
        // Check ID and Email should be mapped.
        if (userModel.emailId != idData['email']) {
          userModel.firebaseId = "null";
          Prefs().setUserByIndex(index, userModel);
          return;
        }

        // Try Login and Blacklist if Wrong Password or User Not Found.
        try {
          _user = (await _auth.signInWithEmailAndPassword(
                  email: userModel.emailId, password: userModel.password))
              .user;
          userModel.firebaseId = _user.uid;
        } catch (e) {
          print(e);
          userModel.firebaseId = "null";
          Prefs().setUserByIndex(index, userModel);
          return;
        }

        // Update Data If Login Successfully.
        try {
          Map<dynamic, dynamic> onlineData = await _userCollection
              .doc(userModel.firebaseId)
              .get()
              .then((value) => value.data());
          if (onlineData["isGoogleUser"] != userModel.isGoogleUser) {
            userModel.firebaseId = "null";
            Prefs().setUserByIndex(index, userModel);
            return;
          }
          UserModel onlineUserModel = UserModel(
              isGoogleUser: onlineData["isGoogleUser"],
              profession: onlineData["profession"],
              password: userModel.password,
              birthDate: onlineData["birthDate"],
              fullName: onlineData["fullName"],
              idCard: onlineData["idCard"],
              age: onlineData["age"],
              emailId: onlineData["emailId"],
              firebaseId: onlineData["firebaseId"],
              profilePhoto: onlineData["profilePhoto"]);
          DataModel onlineDataModel = DataModel(
              updateTime: onlineData["updateTime"],
              score: onlineData["score"],
              themeColor: onlineData["themeColor"],
              activeIndex: onlineData["activeIndex"]);
          if (dataModel.updateTime <= onlineDataModel.updateTime) {
            Prefs().setDataByIndex(index, onlineDataModel);
          } else {
            onlineData["updateTime"] = dataModel.updateTime;
            onlineData["activeIndex"] = dataModel.activeIndex;
            onlineData["score"] = dataModel.score;
            onlineData["themeColor"] = dataModel.themeColor;
            await _userCollection.doc(userModel.firebaseId).set(onlineData);
          }

          await updateProfilePhoto(userModel, onlineUserModel, index);
        } catch (e) {
          print(e);
        }
        return;
      }
    } else {
      print("Index $index, Case 3");
      try {
        Map<dynamic, dynamic> onlineData = await _userCollection
            .doc(userModel.firebaseId)
            .get()
            .then((value) => value.data());
        if (onlineData["isGoogleUser"] != userModel.isGoogleUser) {
          userModel.firebaseId = "null";
          Prefs().setUserByIndex(index, userModel);
          return;
        }
        UserModel onlineUserModel = UserModel(
            isGoogleUser: onlineData["isGoogleUser"],
            profession: onlineData["profession"],
            password: userModel.password,
            birthDate: onlineData["birthDate"],
            fullName: onlineData["fullName"],
            idCard: onlineData["idCard"],
            age: onlineData["age"],
            emailId: onlineData["emailId"],
            firebaseId: onlineData["firebaseId"],
            profilePhoto: onlineData["profilePhoto"]);
        DataModel onlineDataModel = DataModel(
            updateTime: onlineData["updateTime"],
            score: onlineData["score"],
            themeColor: onlineData["themeColor"],
            activeIndex: onlineData["activeIndex"]);
        if (dataModel.updateTime <= onlineDataModel.updateTime) {
          Prefs().setDataByIndex(index, onlineDataModel);
        } else {
          onlineData["updateTime"] = dataModel.updateTime;
          onlineData["activeIndex"] = dataModel.activeIndex;
          onlineData["score"] = dataModel.score;
          onlineData["themeColor"] = dataModel.themeColor;
          await _userCollection.doc(userModel.firebaseId).set(onlineData);
        }
        await updateProfilePhoto(userModel, onlineUserModel, index);
      } catch (e) {
        return;
      }
      return;
    }
  }

  Stream<bool> syncUpAllUsers() async* {
    var connectivityResult = await checkInternetConnection();
    if (!connectivityResult) {
      yield true;
      return;
    }

    print("First User Starts");
    int id = Prefs().currentUser;
    if (id == -1) {
      yield true;
    } else {
      print("Online Syncing cur user.");
      UserModel curUserModel = UserModel.fromJson(Prefs().getUserByIndex(id));
      DataModel curDataModel = DataModel.fromJson(Prefs().getDataByIndex(id));
      await syncUpUser(curUserModel, curDataModel, id);
      yield true;
    }
    print("First User Ends");

    int totalUsers = Prefs().counter;
    print("Total Users: $totalUsers");
    List<int> total = List.generate(totalUsers, (index) => index);
    List<UserModel> userProfile = [];
    List<DataModel> userData = [];
    for (int i = 0; i < totalUsers; i++) {
      UserModel userModel = UserModel.fromJson(Prefs().getUserByIndex(i));
      DataModel dataModel = DataModel.fromJson(Prefs().getDataByIndex(i));
      userProfile.add(userModel);
      userData.add(dataModel);
    }

    var futureProcesses =
        total.map((i) => syncUpUser(userProfile[i], userData[i], i));
    final result = await Future.wait(futureProcesses);
    print("Sync Up Done.");
    return;
  }

  static Future<bool> checkInternetConnection() async {
    try {
      print('Before checking');
      final result = await InternetAddress.lookup("google.com");
      print('After checking');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
    } catch (r) {
      print('Error checking');

      return false;
    }
    return false;
  }
}
