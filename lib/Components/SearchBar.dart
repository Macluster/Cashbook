import 'package:flutter/material.dart';





class SearchBar extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Container(
              height: 50,
              width: 300,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey,
                        spreadRadius: 1,
                        offset: Offset(0.5, 0.5))
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  )),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                  )
                ],
              ),
            );
  }

}