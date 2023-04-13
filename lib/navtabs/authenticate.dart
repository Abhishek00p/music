import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music/backend/login.dart';
import 'package:music/navtabs/home.dart';
import 'package:toast/toast.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    ToastContext().init(context);
    if (auth.currentUser != null) {
      return NavPages();
    } else {
      return LoginPage();
    }
  }
}
