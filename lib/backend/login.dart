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
  final _phone = TextEditingController();
  final _otp = TextEditingController();
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
                  top: h * 0.02,
                  left: w * 0.3,
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 34, color: Colors.white),
                  )),
              Positioned(
                  top: h * 0.08,
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
                top: h * 0.15,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        width: w - 40,
                        child: TextFormField(
                          enabled: true,
                          controller: _phone,
                          keyboardType: TextInputType.number,
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
                            labelText: 'numer',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your number';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: w - 40,
                        child: TextFormField(
                          controller: _otp,
                          keyboardType: TextInputType.number,
                          obscureText: true,
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
                            labelText: 'OTP',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your OTP';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: h * 0.32,
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
                ),
              ),
              Positioned(
                top: h * 0.38,
                left: w * 0.3,
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: GestureDetector(
                    onTap: () async {
                      await verifyPhoneNumber(_phone.text);
                    },
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 82, 68, 68)),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: h * 0.46,
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
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: w - 40,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
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
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                          height: 40,
                          width: 120,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: GestureDetector(
                              onTap: _handleLogin,
                              child: Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 82, 68, 68)),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: h * 0.15,
                  left: w * 0.1,
                  child: Row(
                    children: [
                      Text(
                        "Don't have an Account?",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      TextButton(
                          onPressed: () => Get.to(() => SignupPage()),
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 17, color: Colors.blue),
                          ))
                    ],
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
