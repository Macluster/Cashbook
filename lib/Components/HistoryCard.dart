import 'package:cashbook/Models/ItemModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  ItemModel? model;
  HistoryCard(this.model);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 130,
        decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: SizedBox(
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Transaction From " + model!.owner,
                  style: const TextStyle(
                      shadows: [
                        Shadow(
                            color: Color.fromARGB(255, 145, 117, 35),
                            offset: Offset(1, 5),
                            blurRadius: 30)
                      ],
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      "Particular : " + model!.particular,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Row(
                  children: [
                    Text(
                      "Amount: " + model!.amount + " Rs " + model!.type,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}
