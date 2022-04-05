import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cashbook/Services/Database.dart';
import 'package:cashbook/Services/NativeDatabse.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ChangeNotifires/LinkedAccountInfo.dart';
import '../ChangeNotifires/TransPopupNotifier.dart';

class TransactionPopUp extends StatefulWidget {
  @override
  State<TransactionPopUp> createState() => _TransactionPopUpState();
}

Future<bool> checkInternetCon() async {
  final ConnectivityResult result = await Connectivity().checkConnectivity();

  if (result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile) {
    print("InterNet Connection == true");
    return true;
  } else {
    print("InterNet Connection == false");
    return false;
  }
}

class _TransactionPopUpState extends State<TransactionPopUp> {
  String radiovalue = '0';
  String tst = "submit";
  String date = "Select Date";
  TextEditingController DateController = TextEditingController();
  TextEditingController ParticularController = TextEditingController();
  TextEditingController AmountController = TextEditingController();

  Future<String> DatePicker(BuildContext context) async {
    DateTime CurrDate = DateTime.now();
    final DateTime? Selected = await showDatePicker(
        context: context,
        initialDate: CurrDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2025));

    print("Date=====:" + Selected.toString());
    String month =
        int.parse(Selected.toString().split(' ')[0].split("-")[1][0]) < 1
            ? Selected.toString().split(' ')[0].split("-")[1][1]
            : Selected.toString().split(' ')[0].split("-")[1];
    String day =
        int.parse(Selected.toString().split(' ')[0].split("-")[2][0]) < 1
            ? Selected.toString().split(' ')[0].split("-")[2][1]
            : Selected.toString().split(' ')[0].split("-")[2];
    String returDateFromat = Selected.toString().split(' ')[0].split("-")[0] +
        "-" +
        month +
        "-" +
        day;
    return returDateFromat;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 50),
          width: 200,
          height: 450,
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey)],
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                  onTap: () {
                    context.read<TransPopupNotifier>().setPopUpFlag(0);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.close),
                  ),
                )
              ]),
              const Text(
                "Add Transaction",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  date = await DatePicker(context);
                  setState(() {});
                },
                child: Container(
                    alignment: Alignment.center,
                    color: Color.fromARGB(255, 226, 226, 226),
                    height: 30,
                    width: 150,
                    child: Text(
                      date,
                      textAlign: TextAlign.center,
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Text("Transaction Type:"),
                  const SizedBox(
                    width: 5,
                  ),
                  Radio(
                      value: 'credit',
                      groupValue: radiovalue,
                      onChanged: (value) {
                        setState(() {
                          radiovalue = value.toString();
                        });
                      }),
                  const Text("credit"),
                  Radio(
                      value: 'debit',
                      groupValue: radiovalue,
                      onChanged: (value) {
                        setState(() {
                          radiovalue = value.toString();
                        });
                      }),
                  Text("Debit"),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                  height: 30,
                  width: 200,
                  child: TextField(
                    controller: ParticularController,
                    decoration: const InputDecoration(
                        hintText: "Particular",
                        hintStyle: TextStyle(fontSize: 15)),
                  )),
              const SizedBox(
                height: 30,
              ),
              Container(
                  height: 30,
                  width: 150,
                  child: TextField(
                    controller: AmountController,
                    decoration: const InputDecoration(
                        hintText: "Amount", hintStyle: TextStyle(fontSize: 15)),
                  )),
              const SizedBox(
                height: 40,
              ),
              Container(
                  height: 40,
                  width: 100,
                  decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextButton(
                      onPressed: () async {
                        NativeDatabase database = NativeDatabase();

                        if (await checkInternetCon() == true) {
                          Database db = Database();
                          db.insertToDatabse(date, ParticularController.text,
                              radiovalue, AmountController.text);
                        } else {
                          String id = await database.getlastid();
                          if (id == "null") {
                            id = "0";
                          }

                          final snackbar = SnackBar(
                            content: const Text(
                                "No Internet. writing to local Database"),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                database
                                    .deletedata((int.parse(id) + 1).toString());
                              },
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackbar);

                          //database.getlastid();

                          database.insertData(
                              date,
                              ParticularController.text,
                              radiovalue,
                              AmountController.text,
                              (int.parse(id) + 1).toString());
                        }
                      },
                      child: Text("Submit")))
            ],
          ),
        ),
      ),
    );
  }
}
