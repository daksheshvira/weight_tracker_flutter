import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:weight_tracker/models/user_model.dart';

class AuthService {
  FirebaseAuth firebaseAuth;
  LocalUser user;

  AuthService() {
    this.firebaseAuth = FirebaseAuth.instance;
  }

  Future<LocalUser> createFirebaseUser(
      User firebaseUser, String firstName, String lastName) async {
    // Create user in Firestore
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .set(
      {
        "uid": firebaseUser.uid,
        "email": firebaseUser.email,
        "firstName": firstName,
        "lastName": lastName,
        "displayUrl": "",
        "createdAt": DateTime.now(),
      },
    );
    final userDetails = await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .get();

    user = LocalUser.fromMap(userDetails.data());
    return user;
  }

  Future<LocalUser> getUserFromFirestore(User firebaseUser) async {
    final userDetails = await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .get();

    print(userDetails.data);
    if (userDetails.data == null) {
      return null;
    }
    user = LocalUser.fromMap(userDetails.data());
    return user;
  }

  Future<LocalUser> signUp(
      String email, String password, String firstName, String lastName) async {
    try {
      // Create user in auth
      var result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        User firebaseUser = result.user;

        // Create user in Firestore
        if (firebaseUser != null) {
          return createFirebaseUser(firebaseUser, firstName, lastName);
        }
      }
    } catch (e) {
      String authError = "";
      authError = e.toString();
    }
  }

  Future<LocalUser> signIn(String email, String password) async {
    try {
      var result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (result != null) {
        return getUserFromFirestore(await firebaseAuth.currentUser);
      }
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    var currentUser = await firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<User> getCurrentUser() async {
    return await firebaseAuth.currentUser;
  }

  Future<LocalUser> getCurrentUserObject() async {
    User firebaseUser = await firebaseAuth.currentUser;

    final userDetails = await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .get();

    user = LocalUser.fromMap(userDetails.data());
    return user;
  }

  Future<User> changeEmail(String newEmail, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User firebaseUser = await auth.currentUser;

    UserCredential authResult = await firebaseUser.reauthenticateWithCredential(
      EmailAuthProvider.credential(
          email: firebaseUser.email, password: password),
    );

    var result = firebaseUser.updateEmail(newEmail);

    if (result != null) {
      User firebaseUser = await auth.currentUser;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .update(
        {
          "email": newEmail,
        },
      );
    }
  }

  Future<User> changePassword(String password, String newPassword) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User firebaseUser = await auth.currentUser;

    UserCredential authResult = await firebaseUser.reauthenticateWithCredential(
      EmailAuthProvider.credential(
          email: firebaseUser.email, password: password),
    );

    firebaseUser.updatePassword(newPassword);
  }

  Future<User> changeUserDetails(String firstName, String lastName) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User firebaseUser = await auth.currentUser;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .update(
      {
        "firstName": firstName,
        "lastName": lastName,
      },
    );
  }

  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> uploadDisplayPicture(File localFile) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User firebaseUser = await auth.currentUser;
    final uid = firebaseUser.uid;

    if (localFile != null) {
      print("uploading image");
      var fileExtension = path.extension(localFile.path);
      print(fileExtension);

      final StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child("users/images/$uid$fileExtension");

      await storageReference.putFile(localFile).onComplete.catchError(
        ((onError) {
          print(onError);
          return false;
        }),
      );

      String url = await storageReference.getDownloadURL();
      print("$url");

      await FirebaseFirestore.instance
          .collection("users")
          .doc("$uid")
          .update({"displayUrl": url});
    }
  }
}
