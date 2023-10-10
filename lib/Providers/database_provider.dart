import 'dart:async';

import 'package:fiboutiquesv1/Database/order_details.dart';
import 'package:fiboutiquesv1/Database/product.dart';
import 'package:fiboutiquesv1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'dart:core';

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
   List<Map<dynamic, dynamic>> myOrders = <Map<dynamic, dynamic>>[];
  List<Map<dynamic, dynamic>> filteredProductsDetails = <Map<dynamic, dynamic>>[];
      late int productCount;

  Map<dynamic, dynamic> selectedProductDetails = {};
  bool searched = true;

  //
  bool isUpdateButtonVisible = false;

  //
  int selectedProductIndex = -1;
  
  
  //initialise 
  
  bool _isDayDataCalculated = false;
  bool _isWeekDataCalculated = false;
  bool _isMounthDataCalculated = false;

  double _totalSales = 0;
  double _totalQuantity = 0;
  double _totalProfit = 0;

  double _totalWeekSales = 0;
  double _totalWeekQuantity  = 0;
  double  _totalWeekProfit = 0;

  //month
  double _totalMounthSales = 0.0;
  double _totalMouthQuantity = 0.0;
  double _totalMounthProfit = 0.0;

  // Getter methods for your total values and the flag
  bool get isDayDataCalculated => _isDayDataCalculated;
  double get totalSales => _totalSales;
  double get totalQuantity => _totalQuantity;
  double get totalProfit => _totalProfit;

   bool get isWeekDataCalculated => _isWeekDataCalculated;
   double get totalWeekSales => _totalWeekSales;
   double get totalWeekQuantity =>  _totalWeekQuantity;
   double get totalWeekProfit => _totalWeekProfit;
   //

   bool get isMounthDataCalculated => _isMounthDataCalculated;
   double get totalMounthSales => _totalMounthSales;
   double get totalMounthQuantity =>  _totalMouthQuantity;
   double get totalMounthProfit => _totalMounthProfit;
   //
   bool productExists = false;
  //
  final StreamController<void> _ordersStreamController = StreamController<void>.broadcast();

  Stream<void> get ordersStream => _ordersStreamController.stream;
   
   @override
void dispose() {
  _ordersStreamController.close();
  super.dispose();
}

   


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
  //check if product exists
   bool checkIfProductExists(String productName) {
    bool exists = productsDetails.any((product) => product["name"] == productName);
    return exists;
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
//update product
void updateData(BuildContext context) {
  String productName = productNameController.text;
  String newBuyingPrice = productBuyingPriceController.text;
  String newSellingPrice = productSellingPriceController.text;

  
  if (double.parse(newBuyingPrice) > double.parse(newSellingPrice)) {
    Fluttertoast.showToast(msg: "Le prix d'achat ne peut pas être supérieur au prix de vente");
    return;
  }
  int productIndex = productsDetails.indexWhere((product) => product["name"] == productName);

  if (productIndex != -1) {
  
    productsDetails[productIndex]["buyingPrice"] = newBuyingPrice;
    productsDetails[productIndex]["sellingPrice"] = newSellingPrice;

    productExists = true;

   
    productNameController.clear();
    productBuyingPriceController.clear();
    productSellingPriceController.clear();

    
    notifyListeners();
  } else {
    Fluttertoast.showToast(msg: "Produit non trouvé");
  }
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
    print("Search query: $val"); 

    if (val.isEmpty) {
      
      filteredProductsDetails = [];
      print('details $filteredProductsDetails');
    } else {
      
      filteredProductsDetails = productsDetails.where((product) {
        bool matches =
            product["name"].toLowerCase().contains(val.toLowerCase());
        print("Product: ${product["name"]}, Matches: $matches"); // Debug statement
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
    //myOrders.add(value);
    notifyListeners();
    
  }

  Fluttertoast.showToast(msg: "Orders Saved");
  selectedProducts.clear();
  productBuyingPriceController1.clear();
  productSellingPriceController1.clear();
  productQuantityController.clear();
   getOrders();
  //await getOrdersForCurrentDay();
 // await getOrdersForCurrentWeek();
  
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
  var productIndex = selectedProducts.indexWhere((product) => product["name"] == productName);

  if (productIndex != -1) {
    if (productIndex < productBuyingPriceController1.length) {
      productBuyingPriceController1.removeAt(productIndex);
    }
    if (productIndex < productSellingPriceController1.length) {
      productSellingPriceController1.removeAt(productIndex);
    }
    if (productIndex < productQuantityController.length) {
      productQuantityController.removeAt(productIndex);
    }

    selectedProducts.removeAt(productIndex);
    productCount = selectedProducts.length;
    notifyListeners();
  } else {
    print("Product not found in selected products!");
  }
}

  //
  late List<int> hours ;
  late Map<int, int> orderCountPerHour ;
   List<ChartData> chartData = []; // Initialize chartData as an empty list
// fonction qui retour la liste des ventes
// I get all Orders
  List<OrderDetails> a = [];
Future<List<Map<dynamic, dynamic>>> getAllOrders() async{
    List<Map<dynamic, dynamic>> allOrders = <Map<dynamic, dynamic>>[];
   
  
  //getOrders();
  allOrders.clear();
  notifyListeners();
    for (int a = 0; a < orders.length; a++){
      var val = await orders.getAt(a);
      allOrders.add(val.details);
    }
    return allOrders;
  }


  Future<void> getOrders() async {
   
    ordersDetails.clear();
    ///myOrders.clear();
   List<Map<dynamic, dynamic>> dailyList = [];
    notifyListeners();
    for (int a = 0; a < orders.length; a++) {
      var val = await orders.getAt(a);
      ordersDetails.add(val.details);
      dailyList.add(val.details);
      
     
    }
    myOrders = dailyList;
     print('list : $myOrders');
     for(var e in myOrders){
        print('list elements : $e');
     }
    hours = ordersDetails.map((order) {
     // print(order);
      final String date = order["date"];
     // print(date);
      final List<String> parts = date.split(' ');
     // print(parts);
      final String timePart = parts[3]; // Extract the time part
      //print(timePart);
      final List<String> timeParts = timePart.split(':');
      //print(timeParts);
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
    // Notify the stream about changes
    _ordersStreamController.add(null);
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
              const SizedBox(
                height: 10,
              ),
               GestureDetector(
                
                child: TextField(
                controller: productBuyingPriceController,
                keyboardType: TextInputType.number,
                onTap: () {
            String productName = productNameController.text;
            productExists = checkIfProductExists(productName);
               if (productExists) {
               Fluttertoast.showToast(msg: "$productName exists!");
               print("$productName exists!");
              } else {
               Fluttertoast.showToast(msg: "$productName does not exist!");
               }
             },
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
               ),
              
              const SizedBox(
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
              const SizedBox(
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
                  style: TextStyle(color: color, fontSize: 15.sp),
                  ),
                  ),
          TextButton(
  onPressed: () {
    String productName = productNameController.text;
    bool productExists = checkIfProductExists(productName);
    if (productName.isEmpty) {
      Fluttertoast.showToast(msg: "Ajouter le nom du produit svp");
    } else if (productBuyingPriceController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Ajouter le prix d'achat svp");
    } else if (double.parse(productBuyingPriceController.text) >
        double.parse(productSellingPriceController.text)) {
      Fluttertoast.showToast(
          msg: "Le prix d'achat ne doit pas etre supperieur au prix de vente");
    } else if (productSellingPriceController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Ajouter le prix de reviens svp");
    } else {
      if (productExists) {
        
        updateData(context);
        Fluttertoast.showToast(msg: "Produit modifié avec succès");
      } else {
       
        addData(context);
        Fluttertoast.showToast(msg: "Produit ajouté avec succès");
      }
      Navigator.pop(context); 
    }
  },
  child: Text(
    productExists ? "Modifier" : "Enregistrer",
    //isUpdateButtonVisible ? "Modifier" : "Enregistrer",
    style: TextStyle(color: color, fontSize: 15.sp),
  ),
),

        ],
      ),
    );
  }
    
Future<void> getOrdersForCurrentDay() async{
    Completer<void> completer = Completer<void>();
   List<Map<dynamic, dynamic>> alldayOrders = <Map<dynamic, dynamic>>[];

  // Récupérez la liste mise à jour des commandes pour la journée en cours
  alldayOrders = await getAllOrders();
  if (!_isDayDataCalculated) {
    
  String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  if (alldayOrders.isNotEmpty) {
    for (var e in alldayOrders) {
      String orderDate = e["date"].toString();
    

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
      //print('Order Date Time===: $orderDateTime'); // Debug statement

      if (orderDateTime.day == DateTime.now().day &&
          orderDateTime.month == DateTime.now().month &&
          orderDateTime.year == DateTime.now().year) {
        // Extract other order details and perform calculations
        String totalPricies = e["totalPrice"];
        String quantities = e["quantity"];
        String profit = e["profit"];

        double totalPrice = double.parse(totalPricies);
        double quantity = double.parse(quantities);
        double profitValue = double.parse(profit);

        _totalSales += totalPrice;
        _totalQuantity += quantity;
        _totalProfit += profitValue;
      }
      
    }
   //ordersDetails.clear();
    
  } else {
    print('liste vide');
  }
  notifyListeners();
  print('Total Sales for Today: ${totalSales.toStringAsFixed(2)}');
  print('Total Quantity Sold Today: ${totalQuantity.toStringAsFixed(2)}');
  print('Total Profit for Today: ${totalProfit.toStringAsFixed(2)}');
  _isDayDataCalculated = true;
    } else {
      alldayOrders.clear();
      print(alldayOrders);
    }
    // Trigger the Completer to indicate that the operation is complete
  completer.complete();
  // Return the Completer's future
  return completer.future;
}

//week
Future<void> getOrdersForCurrentWeek() async {
 
  Completer<void> completer = Completer<void>();

  if (!_isWeekDataCalculated) {
    getOrders();

  DateTime now = DateTime.now();
  DateTime startOfWeek = DateTime(now.year, now.month, now.day - now.weekday);
  DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));

print('order details weely: $ordersDetails');
  if (myOrders.isNotEmpty) {
    for (var order in myOrders) {
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

        _totalWeekSales += totalPrice;
        _totalWeekQuantity += quantity;
        _totalWeekProfit += profitValue;
      }
    }
    //ordersDetails.clear();
  }

  //notifyListeners();
  print('Total Sales for Current Week: ${totalSales.toStringAsFixed(2)}');
  print('Total Quantity Sold this Week: ${totalQuantity.toStringAsFixed(2)}');
  print('Total Profit for Current Week: ${totalProfit.toStringAsFixed(2)}');
   _isWeekDataCalculated = true;
}
// Trigger the Completer to indicate that the operation is complete
  completer.complete();
  // Return the Completer's future
  return completer.future;

    }

  //Mounth
  Future<void> getOrdersForCurrentMonth() async {
  Completer<void> completer = Completer<void>();

  if (!_isMounthDataCalculated) {
    ordersDetails.clear();
    notifyListeners();
    for (int a = 0; a < orders.length; a++) {
      var val = await orders.getAt(a);
      ordersDetails.add(val.details);
      
    }
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;

    DateTime startOfMonth = DateTime(currentYear, currentMonth, 1);
    DateTime endOfMonth = DateTime(currentYear, currentMonth + 1, 0);

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

        if (orderDateTime.isAfter(startOfMonth) && orderDateTime.isBefore(endOfMonth)) {
          String totalPrices = order["totalPrice"];
          String quantities = order["quantity"];
          String profit = order["profit"];

          double totalPrice = double.parse(totalPrices);
          double quantity = double.parse(quantities);
          double profitValue = double.parse(profit);

          _totalMounthSales += totalPrice;
          _totalMouthQuantity += quantity;
          _totalMounthProfit += profitValue;
        }
      }
    }

    // Notify listeners and print the calculated data
   // notifyListeners();
    print('Total Sales for Current Month: ${_totalMounthSales.toStringAsFixed(2)}');
    print('Total Quantity Sold this Month: ${_totalMouthQuantity.toStringAsFixed(2)}');
    print('Total Profit for Current Month: ${_totalMounthProfit.toStringAsFixed(2)}');

    // Mark month data as calculated
    _isMounthDataCalculated= true;
  }

  // Trigger the Completer to indicate that the operation is complete
  completer.complete();

  // Return the Completer's future to handle async completion
  return completer.future;
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