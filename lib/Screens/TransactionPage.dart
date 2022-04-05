import 'package:cashbook/Components/ListviewDeleteBack.dart';
import 'package:cashbook/Components/TransactionRowCard.dart';
import 'package:cashbook/Models/ItemModel.dart';
import 'package:cashbook/Services/Database.dart';
import 'package:cashbook/Services/NativeDatabse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  String Date;
  bool LocalDatabaseflag;
  TransactionPage(this.Date, this.LocalDatabaseflag);

  @override
  State<TransactionPage> createState() =>
      _TransactionPageState(Date, LocalDatabaseflag);
}

class _TransactionPageState extends State<TransactionPage> {
  String date;
  bool LocalDatabseflag;
  Database db = Database();
  NativeDatabase database = NativeDatabase();

  _TransactionPageState(this.date, this.LocalDatabseflag);

  @override
  Widget build(BuildContext context) {
    double scrensize = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: scrensize - 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 1,
                  ),
                  Container(
                      alignment: Alignment.center,
                      color: Colors.grey,
                      width: 25,
                      height: 30,
                      child: Text("SL")),
                  const SizedBox(
                    width: 1,
                  ),
                  Container(
                      alignment: Alignment.center,
                      color: Colors.grey,
                      width: 100,
                      height: 30,
                      child: Text("Date")),
                  const SizedBox(
                    width: 1,
                  ),
                  Container(
                      alignment: Alignment.center,
                      color: Colors.grey,
                      width: 100,
                      height: 30,
                      child: Text("Particular")),
                  const SizedBox(
                    width: 1,
                  ),
                  Container(
                      alignment: Alignment.center,
                      color: Colors.grey,
                      width: 50,
                      height: 30,
                      child: Text("TType")),
                  const SizedBox(
                    width: 1,
                  ),
                  Container(
                      alignment: Alignment.center,
                      color: Colors.grey,
                      width: 70,
                      height: 30,
                      child: Text("Amount")),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              height: 400,
              width: double.infinity,
              child: FutureBuilder(
                future: LocalDatabseflag == false
                    ? db.GetDataWithGivenDate(date)
                    : database.Getdata(),
                builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            child: TransactionRowCard(snapshot.data![index]),
                            background:
                                ListViewDeleteback(snapshot.data![index].owner),
                            onDismissed: (DismissDirection direction) {
                              if (LocalDatabseflag == false) {
                                print("delete occur 1");
                                db.DeleteRecord(snapshot.data![index].date,
                                    snapshot.data![index].id);
                              } else {
                                database.deletedata(snapshot.data![index].id);
                              }
                            },
                          );
                        });
                  } else {
                    return Text("Loading.....!");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
