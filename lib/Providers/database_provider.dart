import 'package:fiboutiquesv1/Database/order_details.dart';
import 'package:fiboutiquesv1/Database/product.dart';
import 'package:fiboutiquesv1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'dart:math';
import 'package:intl/intl.dart';

class DatabaseProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productSellingPriceController = TextEditingController();
  
  TextEditingController productBuyingPriceController = TextEditingController();
   List<TextEditingController> productBuyingPriceController1 = [];
   List<TextEditingController> productSellingPriceController1=[];
   List<TextEditingController> productQuantityController=[];

  List<Map<dynamic, dynamic>> productsDetails = <Map<dynamic, dynamic>>[];
  List<Map<dynamic, dynamic>> ordersDetails = <Map<dynamic, dynamic>>[];
  List<Map<dynamic, dynamic>> filteredProductsDetails = <Map<dynamic, dynamic>>[];
      late int productCount;

  Map<dynamic, dynamic> selectedProductDetails = {};
  bool searched = true;

  //
  int selectedProductIndex = -1;
  
  //initialise 
  
  double totalSales =   0.0;
  double totalQuantity = 0.0;
  double totalProfit = 0.0;


  Future<void> getData() async {
    productsDetails.clear();
    for (int a = 0; a < products.length; a++) {
      var val = await products.getAt(a);
      productsDetails.add(val.details);
    }
    
      print('product details $productsDetails');
   // filteredProductsDetails = productsDetails;
   // print('product filteredProductsDetails $filteredProductsDetails');
    searched = false;
    print("get called");
    notifyListeners();
  }
void addData(BuildContext context) {
  bool isProductExists = false;

  // Check if the product name already exists in the database
  for (var product in productsDetails) {
    if (product["name"] == productNameController.text) {
      isProductExists = true;
      break;
    }
  }

  if (isProductExists) {
    Fluttertoast.showToast(msg: "Ce produit exist déjà!");
  } else {
    // Product name doesn't exist, add the product to the database
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
  }

  productNameController.clear();
  productSellingPriceController.clear();
  productBuyingPriceController.clear();
  getData();
  notifyListeners();
}

//update Products
void updateProductPrices(String productName, double newSellingPrice, double newBuyingPrice) {
  var productIndex = selectedProducts.indexWhere((product) => product["name"] == productName);
  if (productIndex != -1) {
    // Check if buyingPrice is not higher than sellingPrice
    if (newBuyingPrice > newSellingPrice) {
      Fluttertoast.showToast(msg: "Le prix d'achat ne peut pas être supérieur au prix de vente");
      return ; 
    }

    selectedProducts[productIndex]["sellingPrice"] = newSellingPrice.toString();
    selectedProducts[productIndex]["buyingPrice"] = newBuyingPrice.toString();
    notifyListeners();
  }
}



  /*void addData(BuildContext context) {
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
  }*/

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

//filtered product
  Future<void> filterProducts(String val) async {
    print("Search query: $val"); // Debug statement

    if (val.isEmpty) {
      // If the search query is empty, show all products
      filteredProductsDetails = [];
      print('details $filteredProductsDetails');
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
    print("Filtered products : $filteredProductsDetails");
    print("Filtered products count: ${filteredProductsDetails.length}"); // Debug statement

    notifyListeners();
  }
 
void setText(int index) {
  if (index >= 0 &&
      index < productBuyingPriceController1.length &&
      index < productSellingPriceController1.length &&
      index < productQuantityController.length) {
    // Access the elements at the specified index safely
    String buyingPriceText = productBuyingPriceController1[index].text;
    String sellingPriceText = productSellingPriceController1[index].text;
    String quantityText = productQuantityController[index].text;

    if (buyingPriceText.isNotEmpty && sellingPriceText.isNotEmpty && quantityText.isNotEmpty) {
      double buyingPrice = double.tryParse(buyingPriceText) ?? 0.0;
      double sellingPrice = double.tryParse(sellingPriceText) ?? 0.0;

      print('Parsed Buying Price: $buyingPrice');
      print('Parsed Selling Price: $sellingPrice');
    } else {
      print("Buying price or selling price is empty!");
      
    }
  } else {
    // Handle the case where the index is out of bounds for the lists
    print("Invalid index or empty lists!");
    // You might want to clear the text fields or handle this case in a way that makes sense for your application
  }
}

//////////////////
/*void generateControllers(List<Map<dynamic, dynamic>> selectedProducts) {
  productSellingPriceController1.clear();
  productBuyingPriceController1.clear();

  for (int i = 0; i < selectedProducts.length; i++) {
    TextEditingController buyingPriceController =
        TextEditingController(text: selectedProducts[i]["buyingPrice"]);
       
    TextEditingController sellingPriceController =
        TextEditingController(text: selectedProducts[i]["sellingPrice"]);
      

    productBuyingPriceController1.add(buyingPriceController);
    productSellingPriceController1.add(sellingPriceController);
     print(productBuyingPriceController1);
      print(productSellingPriceController1);
  }

 // if (productQuantityController == null || productQuantityController.isEmpty) {
    productQuantityController = List.generate(
        selectedProducts.length, (index) => TextEditingController(text: "1.0"),
       
        );
        print(productQuantityController);

 // }
}*/
//////////////////
void generateControllers(Map<dynamic, dynamic> selectedProducts) {

      TextEditingController buyingPriceController =
      TextEditingController(text: selectedProducts["buyingPrice"]);
      TextEditingController sellingPriceController =
      TextEditingController(text: selectedProducts["sellingPrice"]);

      productBuyingPriceController1.add(buyingPriceController);
      productSellingPriceController1.add(sellingPriceController);

    print('${productBuyingPriceController1.length}');
   
    productQuantityController.add(TextEditingController(text: "1.0") );
 
}

/////////////////
  int selectedIndex = -1;
  TextEditingController selectedText = TextEditingController();
  List<Map<dynamic, dynamic>> selectedProducts = <Map<dynamic, dynamic>>[];
void onSelect(String productName) async {
  // Find the product by name in productsDetails list
  var productIndex = productsDetails.indexWhere((product) => product["name"] == productName);
if (selectedProducts.isEmpty) {
    // Initialize the list if it's empty
    selectedProducts = <Map<dynamic, dynamic>>[];
  }
  if (productIndex != -1) {
    bool isAlreadySelected = false;

    for (var element in selectedProducts) {
      if (productsDetails[productIndex]["name"].toString().contains(element["name"])) {
        isAlreadySelected = true;
        Fluttertoast.showToast(msg: "${element["name"]} already available");
        break;
      }
    }

    if (!isAlreadySelected) {
      if (productsDetails[productIndex]["quantity"] == null) {
        productsDetails[productIndex]["quantity"] = 1.0;
      }
      selectedProducts.add(productsDetails[productIndex]);
      
    }
   
   
   generateControllers(productsDetails[productIndex]);
    searched = false;
    isOpen = !isOpen;

    productCount = selectedProducts.length;
    notifyListeners();
  } else {
    print("Product not found!"); 
  }
}

Future<void> saveOrder() async {
  DateTime dateTime = DateTime.now();
  for (var element in selectedProducts) {
    String name = element["name"];
    String sellingPrice = productSellingPriceController1[selectedProducts.indexOf(element)].text;
    String buyingPrice = productBuyingPriceController1[selectedProducts.indexOf(element)].text;
    String quantity = productQuantityController[selectedProducts.indexOf(element)].text;
    double totalPrice = double.parse(sellingPrice) * double.parse(quantity);
    double profit = (double.parse(sellingPrice) * double.parse(quantity)) - (double.parse(buyingPrice) * double.parse(quantity));

    await orders.put(
      "order${orders.length}",
      Product(
        details: {
          "productName": name,
          "orderNo": "${orders.length}",
          "date": "Time: ${dateTime.minute} : ${dateTime.hour}  Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}",
          "sellingPrice": sellingPrice,
          "buyingPrice": buyingPrice,
          "quantity": quantity,
          "totalPrice": "$totalPrice",
          "profit":"$profit"
        },
      ),
    );
  }

  Fluttertoast.showToast(msg: "Orders Saved");
  selectedProducts.clear();
  getOrders();
  notifyListeners();
}

  /*saveOrder() async {
    //double totalPrice = 0.0;
    int index = -1;
    for (var element in selectedProducts) {
      index++;
      
      print(element);
      DateTime dateTime = DateTime.now();
      String name = element["name"];
      print(element["name"]);
      String sellingPrice = productSellingPriceController1[index].text;
      String buyingPrice = productBuyingPriceController1[index].text;
      String quantity = productQuantityController[index].text;
      //increment total price
      double totalPrice = ( double.parse(element["sellingPrice"])* double.parse(quantity));
       print("orders :${orders.length}");
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
                "totalPrice": "${double.parse(sellingPrice) * double.parse(quantity)}",
              }))
          .then((value) => Fluttertoast.showToast(msg: "Order Saved"));
      selectedProducts.clear();
      getOrders();
      notifyListeners();
      break;
    }
  }*/
  //
  // Method to remove a selected product based on its index
 /* void removeSelectedProduct(int index) {
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
  } */
  void removeSelectedProduct(String productName) async {
  var productIndex = await selectedProducts.indexWhere((product) => product["name"] == productName);

  if (productIndex != -1) {
    // Clear the corresponding text controllers
    productBuyingPriceController1.removeAt(productIndex);
    productSellingPriceController1.removeAt(productIndex);
    productQuantityController.removeAt(productIndex);

    selectedProducts.removeAt(productIndex);
    productCount = selectedProducts.length;
    notifyListeners();
  } else {
    print("Product not found in selected products!");
  }
}

  /*void removeSelectedProduct(String productName) async {
  var productIndex = await selectedProducts.indexWhere((product) => product["name"] == productName);

  if (productIndex != -1) {
    selectedProducts.removeAt(productIndex);
    print(productIndex);
    productCount = selectedProducts.length;
    generateControllers(productsDetails[productIndex]);
    //productsDetails.clear();
    notifyListeners();
  } else {
    print("Product not found in selected products!"); 
  }
}*/


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
              child: Text("Annuler",
                  style: TextStyle(color: color, fontSize: 15.sp))),
          TextButton(
            onPressed: () {
              if (productNameController.text.isEmpty) {
                Fluttertoast.showToast(msg: "Ajouter le nom du produit svp");
              } else if (productBuyingPriceController.text.isEmpty ) {
                Fluttertoast.showToast(msg: "Ajouter le prix d'achat svp");
                
              }
               else if(double.parse(productBuyingPriceController.text) > double.parse(productSellingPriceController.text)){
                   Fluttertoast.showToast(msg: "Le prix d'achat ne doit pas etre supperieur au prix de vente");
                }
               else if (productSellingPriceController.text.isEmpty) {
                Fluttertoast.showToast(msg: "Ajouter le prix de reviens svp");
              } else {
                addData(context);
                Navigator.pop(
                    context); // Close the dialog after adding the product
              }
            },
            child: Text(
              "Enregistrer",
              style: TextStyle(color: color, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }
    
void getOrdersForCurrentDay() {
  String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  print('Current Date: $currentDate'); // Debug statement

 // double totalSales = 0;
 // double totalQuantity = 0;
 // double totalProfit = 0;

  if (ordersDetails.isNotEmpty) {
    for (var order in ordersDetails) {
      String orderDate = order["date"].toString();
      print('Order Date: $orderDate'); // Debug statement

      // Extract date and time parts from the orderDate string
      List<String> dateAndTimeParts = orderDate.split('Date: ');

      // Extract time parts
      String timePart = dateAndTimeParts[0].replaceAll('Time: ', '').trim();
      List<String> timeParts = timePart.split(':');

      // Handle cases where hours are not zero-padded (24-hour format)
      int hour = int.parse(timeParts[0].trim()) % 24;
      int minute = int.parse(timeParts[1].trim());

      // Extract date parts
      List<String> dateParts = dateAndTimeParts[1].split('/');
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      DateTime orderDateTime = DateTime(year, month, day, hour, minute);
      print('Order Date Time===: $orderDateTime'); // Debug statement

      if (orderDateTime.day == DateTime.now().day &&
          orderDateTime.month == DateTime.now().month &&
          orderDateTime.year == DateTime.now().year) {
        // Extract other order details and perform calculations
        String totalPricies = order["totalPrice"];
        String quantities = order["quantity"];
        String profit = order["profit"];

        double totalPrice = double.parse(totalPricies);
        double quantity = double.parse(quantities);
        double profitValue = double.parse(profit);

        totalSales += totalPrice;
        totalQuantity += quantity;
        totalProfit += profitValue;
      }
      
    }
    ordersDetails.clear();
    
  }
  notifyListeners();
  print('Total Sales for Today: ${totalSales.toStringAsFixed(2)}');
  print('Total Quantity Sold Today: ${totalQuantity.toStringAsFixed(2)}');
  print('Total Profit for Today: ${totalProfit.toStringAsFixed(2)}');
  
}

//week
void getOrdersForCurrentWeek() {
  DateTime now = DateTime.now();
  DateTime startOfWeek = DateTime(now.year, now.month, now.day - now.weekday);
  DateTime endOfWeek = startOfWeek.add(Duration(days: 7));

  //double totalSales = 0;
  //double totalQuantity = 0;
  //double totalProfit = 0;

  if (ordersDetails.isNotEmpty) {
    for (var order in ordersDetails) {
      String orderDate = order["date"].toString();

      List<String> dateAndTimeParts = orderDate.split('Date: ');
      String timePart = dateAndTimeParts[0].replaceAll('Time: ', '').trim();
      List<String> timeParts = timePart.split(':');
      int hour = int.parse(timeParts[0].trim()) % 24;
      int minute = int.parse(timeParts[1].trim());

      List<String> dateParts = dateAndTimeParts[1].split('/');
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      DateTime orderDateTime = DateTime(year, month, day, hour, minute);

      if (orderDateTime.isAfter(startOfWeek) && orderDateTime.isBefore(endOfWeek)) {
        String totalPrices = order["totalPrice"];
        String quantities = order["quantity"];
        String profit = order["profit"];

        double totalPrice = double.parse(totalPrices);
        double quantity = double.parse(quantities);
        double profitValue = double.parse(profit);

        totalSales += totalPrice;
        totalQuantity += quantity;
        totalProfit += profitValue;
      }
    }
    ordersDetails.clear();
  }

  notifyListeners();
  print('Total Sales for Current Week: ${totalSales.toStringAsFixed(2)}');
  print('Total Quantity Sold this Week: ${totalQuantity.toStringAsFixed(2)}');
  print('Total Profit for Current Week: ${totalProfit.toStringAsFixed(2)}');
}


   
}
//month


//sales 

//analitycs
class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final int y;
}