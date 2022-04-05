import 'package:firebase_database/firebase_database.dart';

class MultiRecordsInsertModel {
  bool ExistenceOfYearMonth;
  bool ExistencebalanceInYearMonth;
  String NoofRecordsInMonth;
  DataSnapshot balanceSnap;

  MultiRecordsInsertModel(
      this.ExistenceOfYearMonth,
      this.ExistencebalanceInYearMonth,
      this.NoofRecordsInMonth,
      this.balanceSnap);
}
