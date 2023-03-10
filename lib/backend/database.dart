import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music/navtabs/home.dart';
import 'package:toast/toast.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
Future<String> uploadFile(File file, String fileName) async {
  Reference reference = storage.ref().child(fileName);
  UploadTask uploadTask = reference.putFile(file);
  TaskSnapshot downloadUrl = await uploadTask;
  String url = (await downloadUrl.ref.getDownloadURL());
  return url;
}

// Authentication
final FirebaseAuth _auth = FirebaseAuth.instance;

Future signUp(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = userCredential.user!;
    Toast.show("user Register succesfully",
        duration: 2,
        backgroundColor: Colors.white,
        textStyle: TextStyle(color: Colors.black));
    return {"val": true, "user": user};
    // Do something with the user object
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      Toast.show('The password provided is too weak.', duration: 3);
      return {"val": false, "user": "user"};
    } else if (e.code == 'email-already-in-use') {
      Toast.show('The account already exists for that email.', duration: 3);
      return {"val": false, "user": "user"};
    }
  } catch (e) {
    Toast.show(e.toString(), duration: 3);
    return {"val": false, "user": "user"};
  }
}

Future signIn(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = userCredential.user!;
    Toast.show("Welcome",
        duration: 2,
        backgroundColor: Colors.white,
        textStyle: TextStyle(color: Colors.black));
    return true;
    // Do something with the user object
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Toast.show('No user found for that email.', duration: 3);
    } else if (e.code == 'wrong-password') {
      Toast.show('Wrong password provided for that user.', duration: 3);
    }
    return false;
  } catch (e) {
    Toast.show(e.toString());
    return false;
  }
}

Future<void> signOut() async {
  await _auth.signOut();
}

// Google Sign in

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> googleSignInSetup() async {
  try {
    await googleSignIn.signIn();
  } catch (error) {
    Toast.show(error.toString());
  }
}

Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User user = userCredential.user!;

    Get.to(() => NavPages());
  } catch (e) {
    Toast.show("$e");
  }
  // Do something with the user object
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
}

readData() async {
  // final storageRef = FirebaseStorage.instance
  //     .refFromURL("https://music-app-84927-default-rtdb.firebaseio.com/arjit");
  final storageRef = FirebaseStorage.instance.ref();
  var dataList;
  await storageRef.child("arjit").listAll().then((value) => dataList = value);
  // print("data : $dataList");
  for (var element in dataList.items) {
    var data;

    await element.getData().then((val) {
      data = val;
    });
    // print(data.readAsBytes);
  }
  storageRef.listAll().then((result) {
    result.items.forEach((itemRef) async {
      // print(itemRef);
    });
  });
}
