

import 'package:flutter/cupertino.dart';

class NavigationState with ChangeNotifier
{

  int Selectedpage=0;

  int  getSelectedPage()
  {
   return Selectedpage;  
  }

  void setSelectedPage(int i)
  {
    Selectedpage=i;
    notifyListeners();

  }

}