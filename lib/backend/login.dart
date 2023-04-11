import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/helper/colors.dart';
import 'package:music/navtabs/home.dart';
import 'package:music/navtabs/postpage.dart';
import 'package:music/backend/register.dart';

import 'database.dart';
import '../navtabs/libraryNavPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool hide = true;

  hidePass() async {
    setState(() {
      hide = !hide;
    });
  }

  void _handleLogin() async {
    CircularProgressIndicator();

    if (_formKey.currentState!.validate()) {
      final val = await signIn(_emailController.text, _passwordController.text);
      val ? Get.to(() => NavPages()) : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(40),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: w,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            child: Stack(children: [
              Positioned(
                top: 15,
                child: Container(
                    height: 60,
                    padding: EdgeInsets.all(2),
                    width: w - 50,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: whitealpha,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    )),
              ),
              Positioned(
                  top: h * 0.3,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: w - 40,
                          child: TextFormField(
                            enabled: true,
                            controller: _emailController,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.brown[400]!)),
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.white),
                              errorStyle:
                                  TextStyle(fontSize: 16, color: Colors.amber),
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (!value.toString().contains("@gmail.com")) {
                                return "Please enter a correct Email format";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: w - 40,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: hide ? true : false,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  await hidePass();
                                },
                                child: !hide
                                    ? Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.brown[400]!)),
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.white),
                              errorStyle:
                                  TextStyle(fontSize: 16, color: Colors.amber),
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Please enter a Strong pass Or more then 6 character';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 35),
                        Row(
                          children: [
                            Container(
                                height: 50,
                                width: 100,
                                child: Card(
                                  child: TextButton(
                                    onPressed: _handleLogin,
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 82, 68, 68)),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  )),
              Positioned(
                  bottom: h * 0.2,
                  left: w * 0.1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Don't have an Account?",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          TextButton(
                              onPressed: () => Get.to(() => SignupPage()),
                              child: Text(
                                "Register",
                                style:
                                    TextStyle(fontSize: 17, color: Colors.blue),
                              ))
                        ],
                      ),
                    ],
                  )),
              Positioned(
                  top: h * 0.15,
                  left: 0,
                  child: Container(
                    height: 50,
                    width: w * 0.7,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            endIndent: 60,
                            thickness: 1.7,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
              Positioned(
                  bottom: 20,
                  right: 0,
                  child: Container(
                    height: 50,
                    width: w * 0.7,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            indent: 60,
                            thickness: 1.7,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
