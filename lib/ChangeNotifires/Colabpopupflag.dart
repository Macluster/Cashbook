import 'package:flutter/cupertino.dart';

class colabpopupState extends ChangeNotifier {
  bool colabflag = false;

  bool get colabFlag => colabflag;

  void setColabflag(bool flag) {
    colabflag = flag;
    notifyListeners();
  }
}
