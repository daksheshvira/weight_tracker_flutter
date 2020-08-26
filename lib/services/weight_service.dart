import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:weight_tracker/models/weight_model.dart';

class WeightService {
  Future<List<Weight>> getWeight() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    final String uid = user.uid;

    List<Weight> weightMeasurements = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("weights")
        .orderBy("date", descending: true)
        .get();

    snapshot.docs.forEach((document) {
      Weight weight = Weight.fromMap(document.data());
      weightMeasurements.add(weight);
    });
    return weightMeasurements;
  }

  Future<void> addWeight(
    int kg,
    DateTime date,
    String comment,
    dynamic localImage,
  ) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User firebaseUser = await auth.currentUser;
    final String uid = firebaseUser.uid;

    DocumentReference docRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("weights")
        .doc();

    String docId = docRef.documentID;

    await docRef.set({
      "id": docId,
      "weightKg": kg,
      "date": date,
      "comment": comment ?? "",
      "pictureUrl": "",
    });

    if (localImage != null) {
      await uploadWeightPicture(localImage, docId);
    } else {}
  }

  Future<void> editWeight(
    String docId,
    int kg,
    DateTime date,
    String comment,
    dynamic localImage,
    String pictureUrl,
  ) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User firebaseUser = await auth.currentUser;
    final String uid = firebaseUser.uid;

    DocumentReference docRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("weights")
        .doc(docId);

    docRef.set({
      "id": docId,
      "weightKg": kg,
      "date": date,
      "comment": comment ?? "",
      "pictureUrl": pictureUrl,
    });

    if (localImage != null && pictureUrl == "") {
      await uploadWeightPicture(localImage, docId);
    } else if (localImage != null && pictureUrl == null) {
      await uploadWeightPicture(localImage, docId);
    }
  }

  Future<void> uploadWeightPicture(File localImage, String docId) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User firebaseUser = await auth.currentUser;
    final String uid = firebaseUser.uid;
    final dateString = DateTime.now().toString();

    if (localImage != null) {
      var fileExtension = path.extension(localImage.path);

      final StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child("users/weights/$uid/$dateString$fileExtension");

      await storageReference
          .putFile(localImage)
          .onComplete
          .catchError((onError) {
        print(onError);
      });

      String url = await storageReference.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("weights")
          .doc(docId)
          .set(
        {"pictureUrl": url},
      );
    }
  }

  Future<void> deleteWeight(Weight weight) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    final String uid = user.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc("$uid")
        .collection("weights")
        .doc(weight.id)
        .delete();
  }
}
