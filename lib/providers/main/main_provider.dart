import 'package:flutter/material.dart';

class MainProvider with ChangeNotifier{
  int currentIndex = 0;

  changeIndex(int index){
    currentIndex = index;
    notifyListeners();
  }
}