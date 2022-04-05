

import 'package:flutter/cupertino.dart';

class TransPopupNotifier extends ChangeNotifier
{

int popupFalg=0;

void setPopUpFlag(int flag)
{
popupFalg=flag;
notifyListeners();
}

int getPopUpFlag()
{
  return popupFalg;
}


} 