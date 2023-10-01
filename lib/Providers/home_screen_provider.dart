import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  bool isOpen = false;

  List products = [
    "Shoes",
    "Red Shirts",
    "Bags",
    "Caps",
    "Phones",
    "Laptops",
  ];
  List filteredProduct = [];
  addAllToFiltered(){
    filteredProduct = products ;
    notifyListeners();
  }
  filterProducts() {
    filteredProduct = products
        .where((element) => element.toString().toLowerCase().contains(searchController.text))
        .toList();
    notifyListeners();
  }

  addProduct(String a) {
    products.add(a);
    notifyListeners();
  }

  deleteProduct(int index) {
    products.removeAt(index);
    notifyListeners();
  }

  openClose() {
    isOpen = !isOpen;
    notifyListeners();
  }
  int selectedIndex = -1;
  String selectedText = "";
  onSelect(int index) {
    selectedIndex = index ;
    selectedText = filteredProduct[selectedIndex] ;
    // isOpen = !isOpen;
    notifyListeners();
  }
}
