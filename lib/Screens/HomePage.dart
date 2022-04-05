import 'dart:developer';

import 'package:cashbook/ChangeNotifires/LinkedAccountInfo.dart';
import 'package:cashbook/ChangeNotifires/NavigationState.dart';
import 'package:cashbook/ChangeNotifires/TransPopupNotifier.dart';
import 'package:cashbook/Components/HistoryCard.dart';
import 'package:cashbook/Components/TransactionPopUp.dart';
import 'package:cashbook/Models/CreditDebitModel.dart';
import 'package:cashbook/Models/MultiRecordsInsertModel.dart';
import 'package:cashbook/Services/Database.dart';
import 'package:cashbook/Services/NativeDatabse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cashbook/Components/SearchBar.dart';
import 'package:provider/provider.dart';
import 'package:cashbook/ChangeNotifires/NavigationState.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/ItemModel.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String radiovalue = 'credit';
  String UserName = "";
  Database db = Database();

  CreditDebitModel CRmodel = CreditDebitModel("", "");
  @override
  void initState() {
    super.initState();
    Start();
  }

  GetUserNameFromSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserName = pref.getString("Name").toString();
    setState(() {});
  }

  Future<bool> checkInternetCon() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      return true;
    } else {
      return false;
    }
  }

  void Start() async {
    GetUserNameFromSharedPreference();
    Database db = Database();
    CRmodel = await db.GetCreditDebitofCurrentMonth();
    setState(() {});
    NativeDatabase data = NativeDatabase();
    if (!await data.CheckdatabseIsEmpty()) {
      InsertLocalDatabseToFirebase();
    }
  }

  void InsertLocalDatabseToFirebase() async {
    NativeDatabase data = NativeDatabase();
    Database db = Database();
    var list = await data.Getdata();
    DataSnapshot snap = await db.ref
        .child(list[0].date.split('-')[0] + "-" + list[0].date.split('-')[1])
        .child("Balance")
        .get();

    List<MultiRecordsInsertModel> MulltiRecordModelList = [];

    for (int i = 0; i < list.length; i++) {
      db = Database();
      snap = await db.ref
          .child(list[i].date.split('-')[0] + "-" + list[i].date.split('-')[1])
          .child("Balance")
          .get();
      MultiRecordsInsertModel Multimodel = MultiRecordsInsertModel(
          await db.CheckExistenceOfMonthYear(
              list[i].date.split('-')[0] + "-" + list[i].date.split('-')[1]),
          await db.CheckExistenceOfBalanceInYearMonth(
              list[i].date.split('-')[0] + "-" + list[i].date.split('-')[1]),
          await db.GetNoOfRecordsInMonth(
              list[i].date.split('-')[0] + "-" + list[i].date.split('-')[1]),
          snap);
      MulltiRecordModelList.add(Multimodel);
    }

    db.MultiInsert(list, MulltiRecordModelList, snap);

    data.Cleartable();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(height: 20),
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              "Hello",
              style: GoogleFonts.roboto(
                  fontSize: 35,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              "" + UserName + "",
              style: GoogleFonts.roboto(
                  fontSize: 30,
                  color: Color.fromARGB(255, 114, 95, 40),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 30,
      ),
      SearchBar(),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
            height: 200,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/Images/vecteezybackground-yellow-background2fr0521_generated.jpg',
                    )),
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "This Month Transaction",
                  style: TextStyle(
                      shadows: [
                        Shadow(
                            color: Color.fromARGB(255, 85, 65, 4),
                            offset: Offset(1, 5),
                            blurRadius: 30)
                      ],
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(CRmodel.Credit + "Rs",
                            style: const TextStyle(
                                shadows: [
                                  Shadow(
                                      color: Color.fromARGB(255, 85, 65, 4),
                                      offset: Offset(1, 5),
                                      blurRadius: 30)
                                ],
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25)),
                        SizedBox(height: 10),
                        const Text("Credit",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        Text(CRmodel.Debit + "Rs",
                            style: const TextStyle(
                                shadows: [
                                  Shadow(
                                      color: Color.fromARGB(255, 85, 65, 4),
                                      offset: Offset(1, 5),
                                      blurRadius: 30)
                                ],
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25)),
                        const SizedBox(height: 10),
                        const Text("Debit",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                      ],
                    ),
                  ],
                )
              ],
            )),
      ),
      Container(
          height: 200,
          child: FutureBuilder(
            future: db.GetHistoryData(),
            builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length == 0) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      "Todays Entries appear here",
                      style: TextStyle(
                          color: Color.fromARGB(255, 124, 56, 56),
                          fontSize: 22),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return HistoryCard(snapshot.data![index]);
                    },
                  );
                }
              } else
                return const Text("Loading");
            },
          ))
    ]));
  }
}
