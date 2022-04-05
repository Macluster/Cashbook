

import 'package:cashbook/Models/ItemModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionRowCard extends StatefulWidget
{
  ItemModel model;
  TransactionRowCard(this.model);

  @override
  State<TransactionRowCard> createState() => _TransactionRowCardState();
}

class _TransactionRowCardState extends State<TransactionRowCard> {

  
  @override
  Widget build(BuildContext context) {

    double scrensize=MediaQuery.of(context).size.width;
    return Container(
     
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 5),

      child: Container(
       
 width: scrensize-5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 1,),
          Container(alignment: Alignment.center, color: Colors.amber, width: 25,height: 30, child: Text(widget.model.id)),
          const SizedBox(width: 1,),
           Container(alignment: Alignment.center, color: Colors.amber, width: 100,height: 30, child:  Text(widget.model.date)),
         
          const SizedBox(width: 1,),
          Container(alignment: Alignment.center, color: Colors.amber, width: 100,height: 30, child: Text(widget.model.particular)),
         
          const SizedBox(width: 1,),
           Container(alignment: Alignment.center, color: Colors.amber, width: 50,height: 30, child:   Text(widget.model.type)),
     
          const SizedBox(width: 1,),
            Container(alignment: Alignment.center, color: Colors.amber, width: 70,height: 30, child:    Text(widget.model.amount)),
         
        ],
        ),
      ),
    );
  }
}