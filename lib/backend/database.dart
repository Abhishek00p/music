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

Future signUp(String email, String password, String name) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = userCredential.user!;
    await user.updateDisplayName(name);

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // final usernameColl =
    //     firestore.collection("users").doc(user.uid).collection("name").doc();
    // await usernameColl.set({"name": user.displayName.toString()});

    Toast.show("user Register succesfully",
        duration: 2,
        backgroundColor: Colors.white,
        textStyle: TextStyle(color: Colors.black));
    return user;
    // Do something with the user object
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      Toast.show('The password provided is too weak.', duration: 3);
      return null;
    } else if (e.code == 'email-already-in-use') {
      Toast.show('The account already exists for that email.', duration: 3);
      return null;
    }
  } catch (e) {
    Toast.show(e.toString(), duration: 3);
    return null;
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
    } else {
      Toast.show(e.toString(), duration: 3);
    }
    return false;
  } catch (e) {
    Toast.show(e.toString(), duration: 3);
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
    Toast.show(error.toString(), duration: 3);
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
    Toast.show("$e", duration: 3);
  }
  // Do something with the user object
}

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> verifyPhoneNumber(String phoneNumber) async {
  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) {
      // Automatic verification or instant validation
      // This method can be called directly because the user is already authenticated
      signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      // Handle verification failed errors
    },
    codeSent: (String verificationId, int? resendToken) {
      // Save verification ID and resend token
      // Navigate to OTP verification screen
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Handle timeout error
    },
  );
}

Future<void> signInWithCredential(PhoneAuthCredential credential) async {
  try {
    UserCredential userCredential = await auth.signInWithCredential(credential);
    // User is signed in
  } on FirebaseAuthException catch (e) {
    // Handle sign-in errors
  }
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
}

readData() async {
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
