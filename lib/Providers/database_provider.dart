import 'package:fiboutiquesv1/Database/product.dart';
import 'package:fiboutiquesv1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productSellingPriceController = TextEditingController();
  late List<TextEditingController> productQuantityController;

  late List<TextEditingController> productSellingPriceController1;

  TextEditingController productBuyingPriceController = TextEditingController();
  late List<TextEditingController> productBuyingPriceController1;

  List<Map<dynamic, dynamic>> productsDetails = <Map<dynamic, dynamic>>[];
  List<Map<dynamic, dynamic>> ordersDetails = <Map<dynamic, dynamic>>[];
  List<Map<dynamic, dynamic>> filteredProductsDetails =
      <Map<dynamic, dynamic>>[];
   

      late int productCount;

  Map<dynamic, dynamic> selectedProductDetails = {};
  bool searched = true;

  Future<void> getData() async {
    productsDetails.clear();
    for (int a = 0; a < products.length; a++) {
      var val = await products.getAt(a);
      productsDetails.add(val.details);
      print(productsDetails);
    }
    filteredProductsDetails = productsDetails;
    searched = false;
    print("get called");
    notifyListeners();
  }

  void addData(BuildContext context) {
    products.put(
      productNameController.text,
      Product(
        details: {
          "name": productNameController.text,
          "buyingPrice": productBuyingPriceController.text,
          "sellingPrice": productSellingPriceController.text,
        },
      ),
    );
    Fluttertoast.showToast(msg: "Product added successfully");
    productNameController.clear();
    productSellingPriceController.clear();
    productBuyingPriceController.clear();
    getData();
    notifyListeners();
  }

  deleteData() {
    products.deleteAt(selectedIndex);
    selectedIndex = -1;
    notifyListeners();
    getData();
  }

  bool isOpen = false;

  openClose() {
    isOpen = !isOpen;
    notifyListeners();
  }

  Future<void> filterProducts(String val) async {
    print("Search query: $val"); // Debug statement

    if (val.isEmpty) {
      // If the search query is empty, show all products
      filteredProductsDetails = List.from(productsDetails);
    } else {
      // Filter products based on the search query
      filteredProductsDetails = await productsDetails.where((product) {
        bool matches =
            product["name"].toLowerCase().contains(val.toLowerCase());
        print(
            "Product: ${product["name"]}, Matches: $matches"); // Debug statement
        return matches;
      }).toList();
    }

    print("Filtered products count: ${filteredProductsDetails.length}"); // Debug statement

    notifyListeners();
  }

  setText(int index) {
    productBuyingPriceController1[index].text =
        selectedProducts[index]["buyingPrice"];
    productSellingPriceController1[index].text =
        selectedProducts[index]["sellingPrice"];
    productQuantityController[index].text =  selectedProducts[index]["quantity"].toString();
  }

  generateControllers(List<Map<dynamic, dynamic>> selectedProducts) {
    productSellingPriceController1 = List.generate(
        selectedProducts.length, (index) => TextEditingController());
    productBuyingPriceController1 = List.generate(
        selectedProducts.length, (index) => TextEditingController());
    productQuantityController = List.generate(
        selectedProducts.length, (index) => TextEditingController(text: "1.0"));
  }

  int selectedIndex = -1;
  TextEditingController selectedText = TextEditingController();
  List<Map<dynamic, dynamic>> selectedProducts = <Map<dynamic, dynamic>>[];

 onSelect(int index) async {
  // Ensure the index is within the bounds of the productsDetails list
  if (index >= 0 && index < productsDetails.length) {
    selectedIndex = index;
    selectedText.text = await productsDetails[selectedIndex]["name"];
    bool isAlreadySelected = false;

    for (var element in selectedProducts) {
      if (productsDetails[selectedIndex]["name"]
          .toString()
          .contains(element["name"])) {
        isAlreadySelected = true;
        print("${element["name"]} already available");
        Fluttertoast.showToast(msg: "${element["name"]} already available");
        break; // Exit the loop if a matching element is found
      }
    }

    if (!isAlreadySelected) {
      print("${productsDetails[selectedIndex]["name"]} not available");
      // Check if quantity field is already initialized
      if (productsDetails[selectedIndex]["quantity"] == null) {
        // Initialize the quantity field with 1.0
        productsDetails[selectedIndex]["quantity"] = 1.0;
      }
      selectedProducts.add(productsDetails[selectedIndex]);
    }
    
    searched = false;
    isOpen = !isOpen;

    print("selected products: ${selectedProducts}");
    productCount = selectedProducts.length;
    print("Number of Products: $productCount");

    notifyListeners();
  } else {
    print("Invalid index selected!"); // Debug statement for invalid index
  }
}

//caliculate 
double calculateTotalPrice(List<Map<String, dynamic>> selectedProducts) {
  double totalPrice = 0.0;

  for (var product in selectedProducts) {
    double sellingPrice = product["sellingPrice"] ?? 0.0; // Replace "sellingPrice" with the key in your selectedProducts map
    double quantity = product["quantity"] ?? 0.0; // Replace "quantity" with the key in your selectedProducts map
    totalPrice += sellingPrice * quantity;
  }

  return totalPrice;
}





  double totalPrice = 0.0;

  saveOrder() async {
    int index = -1;
    for (var element in selectedProducts) {
      index++;
      DateTime dateTime = DateTime.now();
      String name = element["name"];
      String sellingPrice = productSellingPriceController1[index].text;
      String buyingPrice = productBuyingPriceController1[index].text;
      String quantity = productQuantityController[index].text;
      orders
          .put(
              "order${orders.length}",
              Product(details: {
                "productName": name,
                "orderNo": "${orders.length}",
                "date":
                    "Time: ${dateTime.minute} : ${dateTime.hour}  Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}",
                "sellingPrice": sellingPrice,
                "buyingPrice": buyingPrice,
                "quantity": quantity,
                "totalPrice": "${int.parse(buyingPrice) * int.parse(quantity)}",
              }))
          .then((value) => Fluttertoast.showToast(msg: "Order Saved"));
      selectedProducts.clear();
      notifyListeners();
      break;
    }
  }
  //
  // Method to remove a selected product based on its index
  void removeSelectedProduct(int index) {
    if (index >= 0 && index < selectedProducts.length) {
      selectedProducts.removeAt(index);
      print("Product removed from selectedProductDetails");
      productCount = selectedProducts.length;
      print("Number of Products: $productCount");
      print('Removing product at index: $index');
      notifyListeners(); // Notify listeners after removing the product
    } else {
      print("Invalid index to remove!"); // Debug statement for invalid index
    }
  }

  //
  late List<int> hours ;
  late Map<int, int> orderCountPerHour ;
   List<ChartData> chartData = []; // Initialize chartData as an empty list

  getOrders() async {
    ordersDetails.clear();
    notifyListeners();
    for (int a = 0; a < orders.length; a++) {
      var val = await orders.getAt(a);
      ordersDetails.add(val.details);
      print(ordersDetails);
    }
    hours = ordersDetails.map((order) {
      print(order);
      final String date = order["date"];
      print(date);
      final List<String> parts = date.split(' ');
      print(parts);
      final String timePart = parts[3]; // Extract the time part
      print(timePart);
      final List<String> timeParts = timePart.split(':');
      print(timeParts);
      return int.tryParse(timeParts[0]) ?? 0; // Extract the hour
    }).toList();

    // Count the number of orders for each hour
    orderCountPerHour = {};
    for (var hour in hours) {
      orderCountPerHour[hour] = (orderCountPerHour[hour] ?? 0) + 1;
    }

    // Create chart data from the order count per hour
    chartData = orderCountPerHour.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
    notifyListeners();
  }
//ajout produit
  addProductDialog(BuildContext context, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ajouter Produit",
            style: TextStyle(color: color, fontSize: 15.sp)),
        content: SizedBox(
          height: 200.h,
          width: 200.w,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                      borderRadius: BorderRadius.circular(20.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                      borderRadius: BorderRadius.circular(20.r)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                      borderRadius: BorderRadius.circular(20.r)),
                  hintText: "Product Name",
                  hintStyle: TextStyle(
                    color: color,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: productBuyingPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                      borderRadius: BorderRadius.circular(20.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                      borderRadius: BorderRadius.circular(20.r)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                      borderRadius: BorderRadius.circular(20.r)),
                  hintText: "Prix d'achat",
                  hintStyle: TextStyle(
                    color: color,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: productSellingPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                      borderRadius: BorderRadius.circular(20.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                      borderRadius: BorderRadius.circular(20.r)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                      borderRadius: BorderRadius.circular(20.r)),
                  hintText: "Prix de vente",
                  hintStyle: TextStyle(
                    color: color,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel",
                  style: TextStyle(color: color, fontSize: 15.sp))),
          TextButton(
            onPressed: () {
              if (productNameController.text.isEmpty) {
                Fluttertoast.showToast(msg: "Please add product name");
              } else if (productBuyingPriceController.text.isEmpty) {
                Fluttertoast.showToast(msg: "Please add product buying price");
              } else if (productSellingPriceController.text.isEmpty) {
                Fluttertoast.showToast(msg: "Please add product selling price");
              } else {
                addData(context);
                Navigator.pop(
                    context); // Close the dialog after adding the product
              }
            },
            child: Text(
              "Save",
              style: TextStyle(color: color, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }
}
//analitycs
class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final int y;
}