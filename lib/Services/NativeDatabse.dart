import 'dart:async';
import 'dart:io';

import 'package:cashbook/Models/ItemModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NativeDatabase {
  String tableName = "tempDataTable";
  String Databsename = "MyDatabase";

  static Database? database;

  NativeDatabase() {
    init();
  }

  void init() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path + Databsename);
    database = await openDatabase(path, version: 1, onCreate: oncreate);
  }

  void insertData(
      String date, String part, String ttype, String amount, String id) async {
    await database?.execute("insert into $tableName values('" +
        date +
        "','" +
        part +
        "','" +
        ttype +
        "','" +
        amount +
        "','" +
        id +
        "')");
  }

  oncreate(Database db, int version) async {
    await db.execute(
        "create table $tableName(datee Text,particular Text,ttype Text,amount text,id Text) ");
  }

  void deletedata(String id) async {
    await database?.execute("delete  from  $tableName where id=$id");
  }

  Future<String> getlastid() async {
    var map = await database?.rawQuery("Select MAX(id) from $tableName");

    print("Max==");
    String id = "";
    map!.forEach((element) {
      print(element.values.first.toString());

      id = element.values.first.toString();
    });

    return id;
  }

  Future<List<ItemModel>> Getdata() async {
    List<ItemModel> ItemModellist = [];
    var resultList = await database?.rawQuery('Select * from $tableName');

    ItemModel Itemmodel;
    if (resultList == null) {
      return ItemModellist;
    } else {
      List<String> temdata = [];
      resultList.forEach((element) {
        element.forEach((key, value) {
          temdata.add(value.toString());
        });
        Itemmodel = ItemModel(temdata[2], temdata[1], temdata[3], temdata[0],
            temdata[4], temdata[5]);
        ItemModellist.add(Itemmodel);
        temdata.clear();
      });
    }

    return ItemModellist;
  }

  Future<bool> CheckdatabseIsEmpty() async {
    var list = await database?.rawQuery("select COUNT(*) from $tableName");
    int count = 0;
    if (list != null) {
      list.forEach((element) {
        count = int.parse(element.values.first.toString());
      });
    }

    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

  void Cleartable() {
    database?.execute("delete from $tableName");
  }
}
