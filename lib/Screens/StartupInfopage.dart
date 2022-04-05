import 'package:cashbook/Screens/HomePage.dart';
import 'package:cashbook/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupInfopage extends StatefulWidget {
  @override
  State<StartupInfopage> createState() => _StartupInfopageState();
}

class _StartupInfopageState extends State<StartupInfopage> {
  TextEditingController Namecontr = TextEditingController();

  void SaveName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("Name", Namecontr.text);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Hi what is your sweet name",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  Container(
                      width: 300,
                      child: TextField(
                        controller: Namecontr,
                        decoration: const InputDecoration(hintText: "Name"),
                      )),
                  const SizedBox(height: 100),
                  Container(
                      width: 150,
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: TextButton(
                          onPressed: () {
                            SaveName();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyHomePage(title: "Cashbook")));
                          },
                          child: const Text("Next")))
                ],
              ),
            )),
      ),
    );
  }
}
