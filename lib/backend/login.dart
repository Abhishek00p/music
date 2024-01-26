import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/helper/colors.dart';
import 'package:music/navtabs/home.dart';
import 'package:music/backend/register.dart';
import 'package:toast/toast.dart';

import 'database.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _handleLogin() async {
    const CircularProgressIndicator();

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await signIn(_emailController.text, _passwordController.text)
          .then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Get.to(() => const NavPages());
        } else {
          _emailController.clear();
          _passwordController.clear();
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    ToastContext().init(context);

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(40),
      body: isLoading
          ? Center(
              child: SizedBox(
                height: h * 0.05,
                width: w * 0.1,
                child: const CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: w,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(20),
                  child: Stack(children: [
                    Positioned(
                      top: 15,
                      child: Container(
                          height: 60,
                          padding: const EdgeInsets.all(2),
                          width: w - 50,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: whitealpha,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
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
                            SizedBox(
                              width: w - 40,
                              child: TextFormField(
                                enabled: true,
                                controller: _emailController,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.brown[400]!)),
                                  fillColor: Colors.white,
                                  labelStyle: const TextStyle(color: Colors.white),
                                  errorStyle: const TextStyle(
                                      fontSize: 16, color: Colors.amber),
                                  labelText: 'Email',
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: w - 40,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.brown[400]!)),
                                  fillColor: Colors.white,
                                  labelStyle: const TextStyle(color: Colors.white),
                                  errorStyle: const TextStyle(
                                      fontSize: 16, color: Colors.amber),
                                  labelText: 'Password',
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                                height: 50,
                                width: 100,
                                child: Card(
                                  child: TextButton(
                                    onPressed: _handleLogin,
                                    child: const Text(
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
                      ),
                    ),
                    Positioned(
                        bottom: h * 0.2,
                        left: w * 0.1,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Don't have an Account?",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                                TextButton(
                                    onPressed: () => Get.to(() => const SignupPage()),
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.blue),
                                    ))
                              ],
                            ),
                          ],
                        )),
                    Positioned(
                        top: h * 0.15,
                        left: 0,
                        child: SizedBox(
                          height: 50,
                          width: w * 0.7,
                          child: const Row(
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
                        child: SizedBox(
                          height: 50,
                          width: w * 0.7,
                          child: const Row(
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
