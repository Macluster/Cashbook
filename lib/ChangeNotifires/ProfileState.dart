import 'package:flutter/cupertino.dart';

class ProfileState extends ChangeNotifier {
  bool WhetherInitialSetupDone = false;
  bool get InitialSetupDone => WhetherInitialSetupDone;

  void SetName(bool value) {
    WhetherInitialSetupDone = value;
    notifyListeners();
  }
}
