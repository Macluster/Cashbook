import 'package:cashbook/Services/Authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController controller1 = TextEditingController();

  TextEditingController controller2 = TextEditingController();
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
                  "Sign Up Page",
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
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextButton(
                      onPressed: () {
                        Authentication obj = Authentication();
                        obj.SignUp(controller1.text, controller2.text);
                      },
                      child: const Text("SignUp")),
                ),
              ],
            ),
          ),
        ));
  }
}
