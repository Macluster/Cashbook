import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cashbook/Models/BalanceModel.dart';
import 'package:cashbook/Models/CreditDebitModel.dart';
import 'package:cashbook/Models/ItemModel.dart';
import 'package:cashbook/Models/LinkedUsers.dart';
import 'package:cashbook/Models/MultiRecordsInsertModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  FirebaseAuth auth = FirebaseAuth.instance;

  static String email = "";
  DatabaseReference ref = FirebaseDatabase.instance.ref().child("Users");

  String UserName = "";

  Database() {
    Start();
  }

  void Start() async {
    ref = FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(email.replaceAll(".", "!"));

    SharedPreferences pref = await SharedPreferences.getInstance();

    UserName = pref.getString("Name").toString();
  }

  Future<bool> CheckExistenceOfMonthYear(String date) async {
    int flag = 0;
    String YearMonth = date.split('-')[0] + "-" + date.split('-')[1];
    DataSnapshot snap = await ref.get();
    var tempMap = snap.value as Map;

    // check whether there is the given month record in database
    // so that next id can be checked from database
    tempMap.forEach((key, value) {
      if (key == YearMonth) {
        flag = 1;
      }
    });

    if (flag == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> CheckExistenceOfBalanceInYearMonth(String YearMonth) async {
// check whether there is balance fei
//
// ifld is there or not
    if (await CheckExistenceOfMonthYear(YearMonth)) {
      int CheckBalanceflag = 0;
      DataSnapshot snap = await ref.child(YearMonth).get();
      print("YearMonth==" + YearMonth);
      Map tempMap = snap.value as Map;
      tempMap.forEach((key, value) {
        if (key.toString() == "Balance") {
          CheckBalanceflag = 1;
        }
      });

      if (CheckBalanceflag == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<String> GetNoOfRecordsInMonth(String YearMonth) async {
    if (await CheckExistenceOfMonthYear(YearMonth) == true) {
      DataSnapshot snap = await ref.child(YearMonth).get();

      bool IdNoExistenceflag = false;
      var m = snap.value as Map;
      m.forEach((key, value) {
        if (key == "Idno") {
          IdNoExistenceflag = true;
        }
      });

      if (IdNoExistenceflag == true) {
        snap = await ref.child(YearMonth).child("Idno").get();

        String noOfRecordsInMonth = snap.value as String;
        return noOfRecordsInMonth;
      } else {
        ref.child(YearMonth).child("Idno").set("0");
        return "0";
      }
    }
    return "0";
  }

  //In MultiInsert  as all data needed is taken before, Existence of Year attribute for each record with same
  //YearMonth  will not change. So in order sync all records   we use this function
  List<MultiRecordsInsertModel> ReSyncNoOfrecordsInMonthForMultiInsert(
      List<ItemModel> list,
      List<MultiRecordsInsertModel> modelList,
      String Date) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].date == Date) {
        modelList[i].ExistenceOfYearMonth = true;
      }
    }
    return modelList;
  }

  Future<List<ItemModel>> GetHistoryData() async {
    String date = DateTime.now().toString().split(' ')[0];
    String month = int.parse(date.toString().split(' ')[0].split("-")[1][0]) < 1
        ? date.toString().split(' ')[0].split("-")[1][1]
        : date.toString().split(' ')[0].split("-")[1];
    String day = int.parse(date.toString().split(' ')[0].split("-")[2][0]) < 1
        ? date.toString().split(' ')[0].split("-")[2][1]
        : date.toString().split(' ')[0].split("-")[2];
    String Today =
        date.toString().split(' ')[0].split("-")[0] + "-" + month + "-" + day;

    print("kk" + Today.toString() + "Month");
    String YearMonth =
        date.toString().split(' ')[0].split("-")[0] + "-" + month;

    DataSnapshot snapshot = await ref.child(YearMonth).child(Today).get();

    List<ItemModel> list = [];
    String Amount = "", Date = "", Owner = "", particular = "", Type = "";
    if (snapshot.value != null) {
      Map Datamap = snapshot.value as Map;
      Datamap.forEach((key, value) {
        value.forEach((key, value) {
          if (key == "Amount") {
            Amount = value;
          }
          if (key == "Date") {
            Date = value;
          }
          if (key == "Owner") {
            Owner = value;
          }
          if (key == "Particular") {
            particular = value;
          }
          if (key == "Type") {
            Type = value;
          }
        });
        ItemModel model = ItemModel(Type, particular, Amount, Date, "0", Owner);
        list.add(model);
      });
    }
    return list;
  }

  void MultiInsert(List<ItemModel> list,
      List<MultiRecordsInsertModel> modelList, DataSnapshot snap) {
    String date = "";
    String YearMonth = "";
    String Credit = "0";
    String Debit = "0";

    for (int i = int.parse(modelList[0].NoofRecordsInMonth);
        i < list.length;
        i++) {
      YearMonth = list[i].date.split('-')[0] + "-" + list[i].date.split('-')[1];

      if (modelList[i].ExistenceOfYearMonth == true) {
        ref.child(YearMonth).child(list[i].date).push().set({
          "id": (i + 1).toString(),
          "Date": list[i].date,
          "Particular": list[i].particular,
          "Type": list[i].type,
          "Amount": list[i].amount,
          "Owner": UserName
        });
      } else {
        ref.child(YearMonth).child(list[i].date).push().set({
          "id": "1",
          "Date": list[i].date,
          "Particular": list[i].particular,
          "Type": list[i].type,
          "Amount": list[i].amount,
          "Owner": UserName
        });
        modelList = ReSyncNoOfrecordsInMonthForMultiInsert(
            list, modelList, list[i].date);
      }

      sleep(Duration(seconds: 1));

      if (modelList[i].ExistencebalanceInYearMonth ==
          true) //condition if there is already a balance feild
      {
        Map tempMap = snap.value
            as Map; //here tempmap variable, we are reusing it from the above code

        //Retreiving Data from the balace part in firebase
        tempMap.forEach((key, value) {
          if (key.toString() == "Credit") {
            Credit = value.toString();
          } else {
            Debit = value.toString();
          }
        });
      }

      //updating data in balance part in fireabse
      if (list[i].type == "credit") {
        ref.child(YearMonth).child("Balance").set({
          "Credit": (int.parse(Credit) + int.parse(list[i].amount)).toString(),
          "Debit": Debit
        });
      } else {
        ref.child(YearMonth).child("Balance").set({
          "Credit": Credit,
          "Debit": (int.parse(Debit) + int.parse(list[i].amount)).toString()
        });
      }

      ref
          .child(YearMonth)
          .child("Idno")
          .set((int.parse(modelList[i].NoofRecordsInMonth) + 1).toString());
    }
  }

  void insertToDatabse(
      String date, String particular, String type, String amount) async {
    String YearMonth = date.split('-')[0] + "-" + date.split('-')[1];

    String Credit = "0";
    String Debit = "0";
    String noOfRecordsInMonth = "0";
    print("History name2" + UserName);
    DataSnapshot snap = await ref.get();
    var tempMap = snap.value as Map;
    print("History name21" + UserName);
    // check whether there is the given month record in database
    // so that next id can be checked from database

    if (await CheckExistenceOfMonthYear(date) == true) {
      ref.child(YearMonth).child(date).push().set({
        "id":
            (int.parse(await GetNoOfRecordsInMonth(YearMonth)) + 1).toString(),
        "Date": date,
        "Particular": particular,
        "Type": type,
        "Amount": amount,
        "Owner": UserName
      });
      print("History name4" + UserName);
    } else {
      ref.child(YearMonth).child(date).push().set({
        "id": "1",
        "Date": date,
        "Particular": particular,
        "Type": type,
        "Amount": amount,
        "Owner": UserName
      });
    }

    sleep(Duration(seconds: 1));

    if (await CheckExistenceOfBalanceInYearMonth(YearMonth) ==
        true) //condition if there is already a balance feild
    {
      snap = await ref.child(YearMonth).child("Balance").get();

      tempMap = snap.value
          as Map; //here tempmap variable, we are reusing it from the above code

      //Retreiving Data from the balace part in firebase
      tempMap.forEach((key, value) {
        if (key.toString() == "Credit") {
          Credit = value.toString();
        } else {
          Debit = value.toString();
        }
      });
    }

    //updating data in balance part in fireabse
    if (type == "credit") {
      ref.child(YearMonth).child("Balance").set({
        "Credit": (int.parse(Credit) + int.parse(amount)).toString(),
        "Debit": Debit
      });
    } else {
      ref.child(YearMonth).child("Balance").set({
        "Credit": Credit,
        "Debit": (int.parse(Debit) + int.parse(amount)).toString()
      });
    }

    //idno(noOfrecordsInMonth)  is not retrieved from the database  because as we already got the value inside
    //MonthYear check if conditon in above code

    ref.child(YearMonth).child("Idno").set(
        (int.parse(await GetNoOfRecordsInMonth(YearMonth)) + 1).toString());

    print("History name3" + UserName);
  }

  Future<List<BalanceModel>> GetBalanceData() async {
    DataSnapshot snapshot = await ref.get();

    Map Datamap = snapshot.value as Map;

    List<BalanceModel> balList = [];
    String tempbal;
    String tempdate = "";

    print("Asfasfaf");
    Datamap.forEach((key, value) {
      print("safafasf");
      if (key.toString() != "Balance" &&
          key.toString() != "LinkedAccounts" &&
          key.toString() != "History") {
        tempdate = key.toString();
        print("\ncredit===" + value["Balance"]["Credit"].toString());

        tempbal = (int.parse(value["Balance"]["Credit"].toString()) -
                int.parse(value["Balance"]["Debit"].toString()))
            .toString();

        balList.add(BalanceModel(tempbal, tempdate));
      }
    });

    return await SortbalanceList(balList);
  }

  Future<List<ItemModel>> GetDataWithGivenDate(String date) async {
    String YearMonth = date.split("-")[0] + "-" + date.split("-")[1];
    DataSnapshot snapshot = await ref.child(YearMonth).get();

    Map data = snapshot.value as Map;
    ItemModel model = ItemModel("", "", "", "", "", "");
    List<ItemModel> ItemModelList = [];
    List<String> tempholder = ["", "", "", "", "", ""];

    String uniquekey = "";

    data.forEach((key1, value1) {
      if (key1.toString() != "Balance" &&
          key1.toString() != "Idno" &&
          key1.toString() != "LinkedAccounts" &&
          key1.toString() != "History") {
        value1.forEach((key2, value2) {
          uniquekey = key2.toString();
          print("Key===" + key2.toString());
          value2.forEach((key3, value3) {
            print("ASFDas");
            if (key3 == "Type") {
              print("ASFDAS000001");
              tempholder[0] = value3.toString();
              print("ASFDAS000001");
            } else if (key3 == "Particular") {
              print("ASFDAS000002");
              tempholder[1] = value3.toString();
              print("ASFDAS000002");
            } else if (key3 == "Amount") {
              print("ASFDAS000003");
              tempholder[2] = value3.toString();
              print("ASFDAS000003");
            } else if (key3 == "Date") {
              print("ASFDAS000004");
              tempholder[3] = value3.toString();
              print("ASFDAS000004");
            } else if (key3 == "id") {
              print("ASFDAS000005");
              tempholder[4] = value3.toString();
              print("ASFDAS000005");
            } else if (key3 == "Owner") {
              print(value3.toString());
              print("ASFDAS000006");
              tempholder[5] = value3.toString();
              print("ASFDAS000006");
            }

            //  tempholder.add(value.toString());
            print("valueeee===hjj==" + tempholder[1]);
          });
          model = ItemModel(tempholder[0], tempholder[1], tempholder[2],
              tempholder[3], tempholder[4], tempholder[5]);

          ItemModelList.add(model);
        });
      }
    });

    return await SortItemModelList(ItemModelList);
  }

  Future<CreditDebitModel> GetCreditDebitofCurrentMonth() async {
    String yearMonth = DateTime.now().toString().split(' ')[0];
    print(int.parse(yearMonth.split('-')[1]));
    yearMonth = yearMonth.split('-')[0] +
        "-" +
        int.parse(yearMonth.split('-')[1]).toString();
    print(yearMonth);

    String Credit = "";
    String Debit = "";
    DataSnapshot snap = await ref.child(yearMonth).child('Balance').get();
    if (snap.value != null) {
      Map map = snap.value as Map;
      map.forEach((key, value) {
        if (key == "Credit") {
          Credit = value;
        } else {
          Debit = value;
        }
      });
    } else {
      Credit = "0 ";
      Debit = "0 ";
    }

    CreditDebitModel data = CreditDebitModel(Credit, Debit);
    print("Credit============" + data.Credit);

    return data;
  }

  void DeleteRecord(String date, String id) async {
    String YearMonth = date.split('-')[0] + '-' + date.split('-')[1];
    int flag = 0;
    String keyy = "asf", idd, Type = "", Amount = "";
    DataSnapshot snap = await ref.child(YearMonth).child(date).get();
    var tempmap = snap.value as Map;

    tempmap.forEach((key, value) {
      print("jkkjkjkjkkkkkkkkkkkkkk-" + key);
      if (value["id"] == id) {
        Type = value['Type'].toString();
        Amount = value['Amount'].toString();
        keyy = key;
        idd = id;
      }
    });

    ref.child(YearMonth).child(date).child(keyy).remove();
    if (Type == "credit") {
      snap = await ref.child(YearMonth).get();
      tempmap = snap.value as Map;
      String currentCrdit = tempmap["Balance"]["Credit"].toString();

      ref
          .child(YearMonth)
          .child("Balance")
          .child("Credit")
          .set((int.parse(currentCrdit) - int.parse(Amount)).toString());
    } else {
      snap = await ref.child(YearMonth).get();
      tempmap = snap.value as Map;
      String currentDebit = tempmap["Balance"]["Debit"].toString();

      ref
          .child(YearMonth)
          .child("Balance")
          .child("Debit")
          .set((int.parse(currentDebit) - int.parse(Amount)).toString());
    }

    ReorderFirebaseAfterDelete(date, id);
  }

  void ReorderFirebaseAfterDelete(String date, String id) async {
    String YearMonth = date.split('-')[0] + '-' + date.split('-')[1];
    DataSnapshot snap = await ref.child(YearMonth).child(date).get();

    if (snap.value != null) {
      Map map = snap.value as Map;
      List<int> templist = [];

      map.forEach((key1, value) {
        value.forEach((key, value) {
          if (key == "id" && int.parse(value.toString()) > int.parse(id)) {
            ref
                .child(YearMonth)
                .child(date)
                .child(key1)
                .child("id")
                .set((int.parse(value.toString()) - 1).toString());
          }
        });
      });
    }
    sleep(Duration(seconds: 1));
    ref.child(YearMonth).child("Idno").set(
        (int.parse(await GetNoOfRecordsInMonth(YearMonth)) - 1).toString());
  }

  Future<List<LinkedUsers>> GetLinkedUsers() async {
    print("hhhh" + ref.key.toString());
    DataSnapshot snap = await ref.child("LinkedAccounts").get();
    Map map = snap.value as Map;
    List<LinkedUsers> list = [];

    LinkedUsers user = LinkedUsers("", "", "");
    String name, image = "", email = "";
    map.forEach((key, value) {
      value.forEach((key2, value) {
        if (key2 == "Image") {
          print(key2 + "dasfasdfasf0");
          image = value.toString();
        }
        if (key2 == "email") {
          email = value.toString();
        }
      });
      user = LinkedUsers(key.toString(), image, email);
      list.add(user);
    });

    return list;
  }
}

Future<List<ItemModel>> SortItemModelList(List<ItemModel> list) async {
  int n1, n2;
  ItemModel temp;

  for (int i = 0; i < list.length; i++) {
    for (int j = 0; j < list.length - 1; j++) {
      print("iddddddddddd=====t" + list[j].id);
      n1 = int.parse(list[j].id);
      n2 = int.parse(list[j + 1].id);
      if (n1 < n2) {
        temp = list[j];
        list[j] = list[j + 1];
        list[j + 1] = temp;
      }
    }
  }

  return list;
}

Future<List<BalanceModel>> SortbalanceList(List<BalanceModel> list) async {
  int n1, n2;
  BalanceModel temp;

  for (int i = 0; i < list.length; i++) {
    for (int j = 0; j < list.length - 1; j++) {
      print("balanceliast" + list[j].date.split('-')[0]);
      print("balanceliast" + list[j + 1].date.split('-')[1]);
      n1 = int.parse(list[j].date.split('-')[0] + list[j].date.split('-')[1]);
      n2 = int.parse(
          list[j + 1].date.split('-')[0] + list[j + 1].date.split('-')[1]);
      if (n1 < n2) {
        temp = list[j];
        list[j] = list[j + 1];
        list[j + 1] = temp;
      }
    }
  }

  return list;
}
