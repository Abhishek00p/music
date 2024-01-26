import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/backend/database.dart';
import 'package:music/backend/login.dart';
import 'package:music/helper/colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool hide = true;

  bool isLoading = false;

  hidePass() async {
    setState(() {
      hide = !hide;
    });
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await signUp(_emailController.text, _passwordController.text,
              _nameController.text)
          .then((val) {
        if (val != null) {
          setState(() {
            isLoading = false;
          });

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const LoginPage()));
        } else {
          emptyallField();
          setState(() {
            isLoading = false;
          });
        }
      });
      // Toast.show("Hello ${user.toString()}");
    }
  }

  emptyallField() async {
    _nameController.clear();
    _passwordController.clear();
    _emailController.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(40),
      body: isLoading
          ? Center(
              child: SizedBox(
                height: h * 0.05,
                width: w * 0.1,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
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
                              "Register",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          )),
                    ),
                    Positioned(
                      top: h * 0.28,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: w - 40,
                              child: TextFormField(
                                controller: _nameController,
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
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  errorStyle: const TextStyle(
                                      fontSize: 16, color: Colors.amber),
                                  labelText: 'UserName',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
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
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
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
                                  if (!value
                                      .toString()
                                      .contains("@gmail.com")) {
                                    return "Please enter a correct Email format";
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
                                obscureText: hide ? true : false,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () async {
                                      await hidePass();
                                    },
                                    child: !hide
                                        ? const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.lock,
                                            color: Colors.white,
                                          ),
                                  ),
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
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  errorStyle: const TextStyle(
                                      fontSize: 16, color: Colors.amber),
                                  labelText: 'Password',
                                  border: const OutlineInputBorder(),
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
                            const SizedBox(height: 16),
                            SizedBox(
                                height: 50,
                                width: 100,
                                child: Card(
                                  child: TextButton(
                                    onPressed: _handleSignup,
                                    child: const Text(
                                      'SignUp',
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
                        bottom: h * 0.15,
                        left: w * 0.1,
                        child: Row(
                          children: [
                            const Text(
                              "Already have an Account?",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () =>
                                    Get.to(() => const LoginPage()),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.blue),
                                ))
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
