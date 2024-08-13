import 'package:flutter/material.dart';

class TabBarViewModel extends ChangeNotifier {
  int tabIndex = 1;

  int getTabIndex() {
    return tabIndex;
  }

  void setTabIndex(int newTabIndex) async {
    tabIndex = newTabIndex;
    notifyListeners();
  }
}
