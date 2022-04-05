import 'dart:io';

import 'package:cashbook/Screens/HomePage.dart';
import 'package:cashbook/Screens/SignUpPage.dart';
import 'package:cashbook/Screens/StartupInfopage.dart';
import 'package:cashbook/Services/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controller1 = TextEditingController();

  TextEditingController controller2 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Text(
                  "Login Page",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                Container(
                    height: 70,
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(hintText: "Email"),
                      controller: controller1,
                    )),
                Container(
                    height: 70,
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(hintText: "Password"),
                      controller: controller2,
                    )),
                Container(
                  height: 32,
                  decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextButton(
                      onPressed: () async {
                        Authentication obj = Authentication();
                        obj.Login(controller1.text, controller2.text);
                      },
                      child: const Text("LogIn")),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Create Account   "),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    Authentication ath = Authentication();
                    await ath.googleSignUp();
                    FirebaseAuth auth = FirebaseAuth.instance;
                    sleep(const Duration(seconds: 1));
                    setState(() {});

                    if (auth.currentUser!.email != null) {
                      setState(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StartupInfopage()));
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 250,
                    color: Color.fromARGB(255, 229, 231, 231),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'assets/icons/google.png',
                          width: 30,
                          height: 30,
                        ),
                        Text("Sign In With Google")
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
