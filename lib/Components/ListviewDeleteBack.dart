import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewDeleteback extends StatelessWidget {
  String Owner;
  ListViewDeleteback(this.Owner) {}
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      alignment: Alignment.centerRight,
      color: Colors.red,
      child: Padding(
        padding: EdgeInsets.only(right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("    Author: " + Owner,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            const Text(
              "Delete",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
