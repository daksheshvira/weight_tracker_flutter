import 'package:cloud_firestore/cloud_firestore.dart';

class LocalUser {
  String uid;
  String firstName;
  String lastName;
  String email;
  String displayUrl;
  Timestamp createdAt;
  int heightFt;
  int heightInches;

  LocalUser();

  LocalUser.fromMap(Map<String, dynamic> data) {
    uid = data["uid"];
    firstName = data["firstName"];
    lastName = data["lastName"];
    email = data["email"];
    displayUrl = data["displayUrl"];
    createdAt = data["createdAt"];
    heightFt = data["heightFt"];
    heightInches = data["heightInches"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "displayUrl": displayUrl,
      "createdAt": createdAt,
      "heightInches": heightInches,
      "heightFt": heightFt,
    };
  }
}
