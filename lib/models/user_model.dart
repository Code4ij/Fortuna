class UserModel {
  final String emailId;
  final String password;
  final String fullName;
  final String birthDate;
  final int age;
  final String profession;
  final String idCard;
  bool shouldUpdate;
  String firebaseId;
  String profilePhoto;
  final bool isGoogleUser;

  UserModel(
      {this.emailId,
      this.password,
      this.fullName,
      this.birthDate,
      this.age,
      this.profession,
      this.firebaseId = "",
      this.isGoogleUser,
      this.idCard,
      this.profilePhoto,
      this.shouldUpdate = false});

  UserModel.fromJson(Map<dynamic, dynamic> json)
      : emailId = json["emailId"],
        password = json["password"],
        fullName = json["fullName"],
        birthDate = json["birthDate"],
        age = json["age"],
        profession = json["profession"],
        idCard = json["idCard"],
        firebaseId = json["firebaseId"],
        isGoogleUser = json["isGoogleUser"],
        profilePhoto = json["profilePhoto"],
        shouldUpdate = json["shouldUpdate"];

  Map<String, dynamic> toJson() =>
    {
      ""
      "emailId": emailId,
      "password": password,
      "fullName": fullName,
      "birthDate": birthDate,
      "age": age,
      "idCard": idCard,
      "profession": profession,
      "firebaseId": firebaseId,
      "isGoogleUser": isGoogleUser,
      "profilePhoto": profilePhoto,
      "shouldUpdate": shouldUpdate
    };
}
