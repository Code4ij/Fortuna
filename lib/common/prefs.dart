import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fortuna/models/data_model.dart';
import 'package:fortuna/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Prefs _instance;
  SharedPreferences _preferences;
  static String _path;
  StreamController<double> _streamController;
  Stream<double> volumeStream;

  Prefs._init(this._preferences) {
    int counter = _preferences.getInt("counter");
    _streamController = StreamController<double>.broadcast();
    volumeStream = _streamController.stream;
    if (counter == null) {
      print('Data not found');
      initializeFirstTime();
    } else {
      print('Data found');
      if (currentUser != -1) {
        _userModel = UserModel.fromJson(getUserByIndex(currentUser));
        _dataModel = DataModel.fromJson(getDataByIndex(currentUser));
      }
    }
  }

  static void initialise(SharedPreferences sharedPreferences, String path) {
    _instance = Prefs._init(sharedPreferences);
    _path = path;
  }

  factory Prefs() => _instance;

  UserModel _userModel;
  DataModel _dataModel;

  int get currentUser => _preferences.getInt("currentUser");

  set currentUser(int c) {
    _preferences.setInt("currentUser", c);
  }

  int get counter => _preferences.getInt("counter");

  set counter(int c) {
    _preferences.setInt("counter", c);
  }

  String get curUserName => "user_$currentUser";

  String get curDataName => "data_$currentUser";

  String get nextUserName => "user_$counter";

  String get nextDataName => "data_$counter";

  Map<String, dynamic> get allLocalUsers =>
      jsonDecode(_preferences.getString("allUsers"));

  Map<String, dynamic> get allLocalIds =>
      jsonDecode(_preferences.getString("allIds"));

  List<Map> get defaultUserDataMap => defaultMap;

  int get defaultActiveIndex => 0;

  String get defaultThemeColor => 'blue';

  void initializeFirstTime() {
    _preferences.setInt("counter", 0);
    _preferences.setInt("currentUser", -1);
    _preferences.setInt("musicIndex", 0);
    _preferences.setDouble("musicVolume", 0.4);
    Map<String, int> users = {};
    Map<String, int> ids = {};
    _preferences.setString("allUsers", jsonEncode(users));
    _preferences.setString("allIds", jsonEncode(ids));
  }

  Map<String, dynamic> getUserByIndex(int index) {
    return jsonDecode(_preferences.getString("user_$index"));
  }

  Map<String, dynamic> getDataByIndex(int index) {
    return jsonDecode(_preferences.getString("data_$index"));
  }

  void setUserByIndex(int index, UserModel userModel) {
    _preferences.setString("user_$index", jsonEncode(userModel));
  }

  void setDataByIndex(int index, DataModel dataModel) {
    _preferences.setString("data_$index", jsonEncode(dataModel));
  }

  String getPathByIndex(int index) {
    return "$_path/profile_$index.jpg";
  }

  String getDefaultPath() {
    return "$_path/profile_default.jpg";
  }

  // TODO: Maybe ID changes
  int addUserData(UserModel userModel, DataModel dataModel) {
    Map<String, dynamic> allUsers = allLocalUsers;
    Map<String, dynamic> allIds = allLocalIds;
    print(allUsers);
    print(allIds);
    if (allUsers.containsKey(userModel.emailId) || allIds.containsKey(userModel.idCard)) {
      return -1;
    }

    _preferences.setString(nextUserName, jsonEncode(userModel));
    _preferences.setString(nextDataName, jsonEncode(dataModel));
    allUsers[userModel.emailId] = counter;
    allIds[userModel.idCard] = counter;
    _preferences.setString("allUsers", jsonEncode(allUsers));
    _preferences.setString("allIds", jsonEncode(allIds));
    int curIndex = counter;
    counter = curIndex + 1;
    return curIndex;
  }

  // TODO: Maybe ID changes
  bool updateUserData(UserModel userModel, DataModel dataModel) {
    Map<String, dynamic> allUsers =
        jsonDecode(_preferences.getString("allUsers"));
    int indexNum = allUsers[userModel.emailId];
    DataModel tempData = DataModel.fromJson(getDataByIndex(indexNum));

    if (tempData.updateTime <= dataModel.updateTime) {
      _preferences.setString("data_$indexNum", jsonEncode(dataModel));
      _preferences.setString("user_$indexNum", jsonEncode(userModel));
      return true;
    } else {
      return false;
    }
  }


  // TODO: Maybe ID changes
  int registerUser(UserModel userModel, DataModel dataModel) {
    Map<String, dynamic> allUsers = allLocalUsers;
    Map<String, dynamic> allIds = allLocalIds;
    print(allUsers);
    print(allIds);
    if (allUsers.containsKey(userModel.emailId) || allIds.containsKey(userModel.idCard)) {
      return -1;
    }

    _preferences.setString(nextUserName, jsonEncode(userModel));
    _preferences.setString(nextDataName, jsonEncode(dataModel));
    allUsers[userModel.emailId] = counter;
    allIds[userModel.idCard] = counter;
    _preferences.setString("allUsers", jsonEncode(allUsers));
    _preferences.setString("allIds", jsonEncode(allIds));
    int curIndex = counter;
    counter = curIndex + 1;
    return curIndex;
  }

  // TODO: Maybe ID changes
  int loginUser(String emailId, String password) {
    Map<String, dynamic> allUsers =
        jsonDecode(_preferences.getString("allUsers"));
    print(allUsers);
    if (!allUsers.containsKey(emailId)) return -1;
    try {
      int indexNum = allUsers[emailId];
      UserModel tempUser = UserModel.fromJson(getUserByIndex(indexNum));
      print("Index $indexNum Password ${tempUser.password}");
      if (password == tempUser.password) {
        _userModel = tempUser;
        _dataModel = DataModel.fromJson(getDataByIndex(indexNum));
        currentUser = indexNum;
        print("Current User From Pref_login: $currentUser");
        return 0;
      }
    } catch (e) {
      print(e);
    }
    return 1;
  }

  int loginUserById(String idCard, String password) {
    Map<String, dynamic> allIds = allLocalIds;
    print(allIds);
    if (!allIds.containsKey(idCard)) return -1;
    try {
      int indexNum = allIds[idCard];
      UserModel tempUser = UserModel.fromJson(getUserByIndex(indexNum));
      print("Index $indexNum Password ${tempUser.password}");
      if (password == tempUser.password) {
        _userModel = tempUser;
        _dataModel = DataModel.fromJson(getDataByIndex(indexNum));
        currentUser = indexNum;
        print("Current User From Pref_login_By_ID: $currentUser");
        return 0;
      }
    } catch (e) {
      print(e);
    }
    return 1;
  }

  void signOutUser() {
    currentUser = -1;
    _userModel = null;
    _dataModel = null;
  }

  void blackListUser(String emailId) {
    print("Black List Starts");
    Map<String, dynamic> allUsers =
        jsonDecode(_preferences.getString("allUsers"));
    if (!allUsers.containsKey(emailId)) return;

    int indexNum = allUsers[emailId];
    UserModel tempUser = UserModel.fromJson(
        jsonDecode(_preferences.getString("user_$indexNum")));
    tempUser.firebaseId = "null";
    _preferences.setString("user_$indexNum", jsonEncode(tempUser));
  }

  int get totalScore {
    int total = 0;
    data?.forEach((element) => total += element['total']);
    return total;
  }

  List get data => _dataModel?.score;

  set data(List data) {
    _dataModel.score = data;
    _dataModel.updateTime = DateTime.now().millisecondsSinceEpoch;
    _preferences.setString(curDataName, jsonEncode(_instance._dataModel));
  }

  bool get isGoogleUser => _userModel.isGoogleUser;

  void updateScore(int index, Map score) {
    data[index] = score;
    data = data;
  }

  // ### User Profile ###
  // active Index
  int get activeIndex => _dataModel.activeIndex;

  set activeIndex(int index) {
    print('Game index: $index prefsIndex: $activeIndex');
    if (activeIndex < index) {
      _dataModel.activeIndex = index;
      _dataModel.updateTime = DateTime.now().millisecondsSinceEpoch;
      _preferences.setString(curDataName, jsonEncode(_instance._dataModel));
    }
  }

  // theme Color
  Color get color {
    String curCur = _dataModel.themeColor;
    if (curCur == "blue")
      return Color(0xff17467A);
    else if (curCur == "orange")
      return Color(0xffF6892B);
    else if (curCur == "blueGrey")
      return Color(0xff8EA5C2);
    else if (curCur == "amber")
      return Color(0xffF8CD35);
    else if (curCur == "lightBlue")
      return Color(0xff0072B2);
    else if (curCur == "yellow") return Color(0xffFFF200);
  }

  set color(Color color) {
    if (color == Color(0xff17467A))
      _dataModel.themeColor = "blue";
    else if (color == Color(0xffF6892B))
      _dataModel.themeColor = "orange";
    else if (color == Color(0xff8EA5C2))
      _dataModel.themeColor = "blueGrey";
    else if (color == Color(0xffF8CD35))
      _dataModel.themeColor = "amber";
    else if (color == Color(0xff0072B2))
      _dataModel.themeColor = "lightBlue";
    else if (color == Color(0xffFFF200)) _dataModel.themeColor = "yellow";

    _dataModel.updateTime = DateTime.now().millisecondsSinceEpoch;
    _preferences.setString(curDataName, jsonEncode(_instance._dataModel));
  }

  // User Name
  String get name => _userModel?.fullName ?? "";

  // User Profession
  String get profession => _userModel?.profession ?? "";

  // User Profile
  String get imageUrl => getPathByIndex(currentUser);

  // Music
  int get musicIndex => _preferences.getInt("musicIndex");

  set musicIndex(int index) {
    _preferences.setInt("musicIndex", index);
  }

  double get musicVolume => _preferences.getDouble("musicVolume");

  set musicVolume(double vol) {
    _preferences.setDouble("musicVolume", vol);
    _streamController.add(vol);
  }
}

List<Map> defaultMap = [
  {
    "total": 0,
    "trophy": 0,
  },
  {"total": 0},
  {
    "total": 0,
    "modules" : [
      {
        "total" : 0,
        "counter" : 0,
      },
      {
        "total" : 0,
      },
    ]
  },
  {
    "total": 0,
    "Counter": 0,
    "trophy": 0,
  },
  {"total": 0},
  {
    "total": 0,
    "trophy": 0,
    "checkTopics":{
      'credit': List(),
      'invest': List(),
      'stock': List(),
    },
    "innerModule": {
      'credit': 0,
      'invest': 0,
      'stock': 0,
    },
  },
  {"total": 0},
  {
    "total": 0,
    "solvedGame": 1,
    "1": 0,
    "2": 0,
    "3": 0,
    "4": 0,
    "5": 0,
    "6": 0,
  },
  {"total": 0},
  {"total": 0},
  {
    "total": 0,
    "game1": {
      "0": 0,
      "1": 0,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0,
      "6": 0,
      "7": 0,
      "8": 0,
      "9": 0,
    },
    "game1Score": 0,
    "game2": {
      "0": 0,
      "1": 0,
      "2": 0,
      "3": 0,
    },
    "game2Score": 0
  }
];
