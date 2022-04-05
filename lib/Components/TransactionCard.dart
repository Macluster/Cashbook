import 'package:cashbook/Models/BalanceModel.dart';
import 'package:cashbook/Models/ItemModel.dart';
import 'package:cashbook/Screens/TransactionPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  BalanceModel model;
  TransactionCard(this.model);

  String ConvertDateToDateInWords(String date) {
    String Month = date.split("-")[1];

    switch (int.parse(Month)) {
      case 1:
        return "January " + date.split("-")[0];

      case 2:
        return "February " + date.split("-")[0];
      case 3:
        return "March " + date.split("-")[0];
      case 4:
        return "April " + date.split("-")[0];
      case 5:
        return "May " + date.split("-")[0] + date.split("-")[0];
      case 6:
        return "June " + date.split("-")[0];
      case 7:
        return "July " + date.split("-")[0];
      case 8:
        return "August " + date.split("-")[0];
      case 9:
        return "September " + date.split("-")[0];
      case 10:
        return "October " + date.split("-")[0];
      case 11:
        return "November " + date.split("-")[0];
      case 12:
        return "December " + date.split("-")[0];
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionPage(model.date, false)));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/Images/vecteezybackground-yellow-background2fr0521_generated.jpg',
                  )),
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          height: 70,
          width: screenWidth - 50,
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Text(
                ConvertDateToDateInWords(model.date),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                width: 17,
              ),
              Text(
                "Balance=" + model.balance,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              )
            ],
          ),
        ));
  }
}
