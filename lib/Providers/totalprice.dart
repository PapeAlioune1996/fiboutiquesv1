import 'package:flutter/material.dart';

class TotalPriceProvider with ChangeNotifier {
  double _totalPrice = 0.0;

  double get totalPrice => _totalPrice;

  void updateTotalPrice(double newTotalPrice) {
    _totalPrice = newTotalPrice;
    notifyListeners();
  }
}
