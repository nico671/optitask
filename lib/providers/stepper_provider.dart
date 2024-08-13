import 'package:flutter/material.dart';

class StepperProvider extends ChangeNotifier {
  int counter = 0;

  void setCounter(int updatedCounter) {
    counter = updatedCounter;
    notifyListeners();
  }

  void incrementCounter() {
    counter++;
    notifyListeners();
  }

  void decrementCounter() {
    counter--;
    notifyListeners();
  }
}
