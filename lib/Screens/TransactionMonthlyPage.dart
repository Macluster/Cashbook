import 'package:cashbook/Components/TransactionCard.dart';
import 'package:cashbook/Models/BalanceModel.dart';
import 'package:cashbook/Models/ItemModel.dart';
import 'package:cashbook/Screens/TransactionPage.dart';
import 'package:cashbook/Services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionMonthlyPage extends StatefulWidget {
  @override
  State<TransactionMonthlyPage> createState() => _TransactionMonthlyPageState();
}

class _TransactionMonthlyPageState extends State<TransactionMonthlyPage> {
  @override
  void initState() {}

  Database db = Database();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      SizedBox(
        width: double.infinity,
        child: Column(children: [
          const Text("Transactions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 400,
            width: screenWidth - 30,
            child: FutureBuilder(
                future: db.GetBalanceData(),
                builder: (context, AsyncSnapshot<List<BalanceModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return TransactionCard(snapshot.data![index]);
                        });
                  } else {
                    return const Text("Loading");
                  }
                }),
          ),
          Container(
              width: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 5,
                        color: Color.fromARGB(255, 255, 230, 155),
                        blurRadius: 10)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionPage("", true)));
                  },
                  child: const Text(
                    "See Local Databse",
                    style: TextStyle(fontSize: 11),
                  )))
        ]),
      )
    ]);
  }
}
