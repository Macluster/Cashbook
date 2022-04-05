import 'package:cashbook/ChangeNotifires/NavigationState.dart';
import 'package:cashbook/ChangeNotifires/TransPopupNotifier.dart';
import 'package:cashbook/Services/Database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class CustomBottomBar extends StatefulWidget {
  NavigationState state = NavigationState();

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;
  int addtransactionFlag = 0;

  NavigationState state = NavigationState();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                          context.read<NavigationState>().setSelectedPage(0);
                        });
                      },
                      child: Icon(
                        Icons.home,
                        size: 30,
                        color: selectedIndex == 0
                            ? Colors.deepPurple[300]
                            : Colors.grey,
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                          context.read<NavigationState>().setSelectedPage(1);
                        });
                      },
                      child: Icon(
                        Icons.list,
                        size: 30,
                        color: selectedIndex == 2
                            ? Colors.deepPurple[300]
                            : Colors.grey,
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 0),
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.all(Radius.circular(35))),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                addtransactionFlag = 1;
              });
              var value = context.read<TransPopupNotifier>().getPopUpFlag();
              if (value == 1) {
                context.read<TransPopupNotifier>().setPopUpFlag(0);
                addtransactionFlag = 0;
              } else {
                context.read<TransPopupNotifier>().setPopUpFlag(1);
              }
            },
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                "+",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              margin: EdgeInsets.only(top: 0),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: addtransactionFlag == 1
                      ? Colors.purple[100]
                      : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
            ),
          ),
        ],
      ),
    );
  }
}
