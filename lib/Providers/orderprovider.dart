import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OrderProvider with ChangeNotifier {
  late Box<Map<dynamic, dynamic>> _ordersBox;


  OrderProvider() {
    _init();
  }

 
  void _init() async {
    await Hive.openBox<Map<dynamic, dynamic>>("orders").then((box) {
      _ordersBox = box;
      notifyListeners();
    });
  }

  // Récupération de tous les ordres
  Future<List<Map<dynamic, dynamic>>> getAllOrders() async {
    if (_ordersBox == null) {
      return []; 
    }

    List<Map<dynamic, dynamic>> allOrders = [];
    for (int a = 0; a < _ordersBox.length; a++) {
      var val = await _ordersBox.get(a);
      allOrders.add(val!);
    }
    return allOrders;
  }
  
}
