import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LinkedAccountInfo extends ChangeNotifier {
  String email = "";

  String get _email => email;

  LinkedAccountInfo() {}

  void SetLinkedAccountEmail(String email) {
    this.email = email;
    notifyListeners();
  }
}
