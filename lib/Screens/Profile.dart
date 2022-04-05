import 'package:cashbook/ChangeNotifires/Colabpopupflag.dart';
import 'package:cashbook/Components/AddcolabpopUp.dart';
import 'package:cashbook/Models/LinkedUsers.dart';
import 'package:cashbook/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<LinkedUsers> Linkedaccounts = [];
  List<CircleAvatar> linkedCiclewidget = [];

  bool ColabPopupflag = false;

  String UserImage = "";
  @override
  void initState() {
    super.initState();
    var user = auth.currentUser!.photoURL;
    if (user != null) {
      UserImage = user;
    }
    GetLinkedAccounts();
  }

  void GetLinkedAccounts() async {
    Database data = Database();
    Linkedaccounts = await data.GetLinkedUsers();
    CircleAvatar avatar = CircleAvatar();
    Linkedaccounts.forEach((element) {
      avatar = CircleAvatar(
        backgroundImage: NetworkImage(element.image),
        radius: 30,
      );
      linkedCiclewidget.add(avatar);
    });

    setState(() {});
  }

  String GetEncyptedEmialCode() {
    String email = auth.currentUser!.email.toString();
    String code = "";

    for (int i = 0; i < email.length; i++) {
      code = code + String.fromCharCode(email.codeUnitAt(i) + 2).toString();
    }
    print(code);
    return code;
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => colabpopupState())
          ],
          child: SizedBox(
            width: double.infinity,
            child: Consumer<colabpopupState>(builder: (context, data, child) {
              return Stack(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(UserImage),
                        radius: 100,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Deepak Denny",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Text(
                        auth.currentUser!.email.toString(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 200,
                            height: 50,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                GetEncyptedEmialCode(),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: GetEncyptedEmialCode()));
                            },
                            child: const Icon(
                              Icons.copy_rounded,
                              color: Colors.grey,
                              size: 35,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Linked Accounts:",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 100,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: linkedCiclewidget.length,
                                      itemBuilder: (context, index) {
                                        return linkedCiclewidget[index];
                                      }),
                                )
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  GetEncyptedEmialCode();

                                  if (data.colabflag == false) {
                                    context
                                        .read<colabpopupState>()
                                        .setColabflag(true);
                                    setState(() {});
                                  } else {
                                    context
                                        .read<colabpopupState>()
                                        .setColabflag(false);
                                    setState(() {});
                                  }
                                },
                                child: const Text(
                                  "+",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  Consumer<colabpopupState>(builder: (Context, data, child) {
                    return data.colabflag == true
                        ? AddColabPopup()
                        : Container();
                  }),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
