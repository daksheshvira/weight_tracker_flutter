import 'package:cloud_firestore/cloud_firestore.dart';

class Weight {
  String id;
  int weightKg;
  Timestamp date;
  String comment;
  String pictureUrl;

  Weight();

  Weight.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    weightKg = data["weightKg"];
    date = data["date"];
    comment = data["comment"];
    pictureUrl = data["pictureUrl"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "weightKg": weightKg,
      "date": date,
      "pictureUrl": pictureUrl,
      "comment": comment,
    };
  }
}
