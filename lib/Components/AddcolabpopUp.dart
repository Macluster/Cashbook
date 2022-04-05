import 'dart:ui';

import 'package:cashbook/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ChangeNotifires/Colabpopupflag.dart';

class AddColabPopup extends StatefulWidget {
  @override
  State<AddColabPopup> createState() => _AddColabPopupState();
}

class _AddColabPopupState extends State<AddColabPopup> {
  TextEditingController UserCodecontrol = TextEditingController();

  String UserName = "";

  _AddColabPopupState() {
    GetUserNameFromSharedPreference();
  }

  AddColab() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String email = GetDecryptedEmail(UserCodecontrol.text).replaceAll('.', '!');
    var ref = FirebaseDatabase.instance.ref().child("Users");
    DataSnapshot snap = await ref.get();
    Map map = snap.value as Map;
    map.forEach((key, value) {
      if (key == email) {
        GetUserNameFromSharedPreference();
        ref
            .child(email)
            .child("LinkedAccounts")
            .child(UserName)
            .child("Image")
            .set(auth.currentUser!.photoURL.toString());
        ref
            .child(email)
            .child("LinkedAccounts")
            .child(UserName)
            .child("email")
            .set(auth.currentUser!.email..toString());
      }
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("Colab", email);
    Database.email = email;
  }

  GetUserNameFromSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserName = pref.getString("Name").toString();
    setState(() {});
  }

  String GetDecryptedEmail(String code) {
    String email = "";

    for (int i = 0; i < code.length; i++) {
      email = email + String.fromCharCode(code.codeUnitAt(i) - 2).toString();
    }
    print(email);
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 233, 230, 230),
                      blurRadius: 20,
                      spreadRadius: 10)
                ]),
            child: Column(children: [
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  context.read<colabpopupState>().setColabflag(false);
                },
                child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [Icon(Icons.close)])),
              ),
              const Text(
                "Add Usercode",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: 200,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 230, 228, 228),
                          blurRadius: 10,
                          spreadRadius: 5)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: UserCodecontrol,
                    decoration: const InputDecoration(
                        hintText: "UserCode", border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                  width: 130,
                  decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextButton(
                      onPressed: () async {
                        AddColab();
                      },
                      child: Text("Add")))
            ]),
          ),
        ),
      ),
    );
  }
}
