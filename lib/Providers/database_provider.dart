// ignore_for_file: avoid_print

import 'dart:async';

import 'package:fiboutiquesv1/Database/order_details.dart';
import 'package:fiboutiquesv1/Database/product.dart';
import 'package:fiboutiquesv1/Database/user.dart';
import 'package:fiboutiquesv1/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:core';

import 'package:provider/provider.dart';

class DatabaseProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productSellingPriceController = TextEditingController();
  TextEditingController productQrName = TextEditingController();
 

 bool _isQrCodeTextFieldVisible = false;

bool get isQrCodeTextFieldVisible => _isQrCodeTextFieldVisible;

set isQrCodeTextFieldVisible(bool value) {
  _isQrCodeTextFieldVisible = value;
  notifyListeners();
}

void toggleQrCodeTextFieldVisibility() {
  _isQrCodeTextFieldVisible = !_isQrCodeTextFieldVisible;
  notifyListeners();
}






  
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

  //
  late FirebaseDatabase firebaseDatabase;
    
  late DatabaseReference databaseReference;
  
  
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
    void setIsSelectedButton() {
      if(!_isDayDataCalculated){
        _isDayDataCalculated=false;
        _isMounthDataCalculated = true;
        _isWeekDataCalculated = false;

        //remettre à ero total day
        _totalSales = 0.0;
        _totalProfit = 0.0;
        _totalQuantity = 0.0;

        //total week
        _totalWeekProfit = 0.0;
        _totalWeekQuantity = 0.0;
        _totalWeekSales = 0.0;

      }else if(!_isWeekDataCalculated) {
        _isDayDataCalculated=true;
        _isMounthDataCalculated = false;
        _isWeekDataCalculated = false;

         //total week
        _totalWeekProfit = 0.0;
        _totalWeekQuantity = 0.0;
        _totalWeekSales = 0.0;

        //tottal mounth
        _totalMounthProfit = 0.0;
        _totalMounthSales = 0.0;
        _totalMouthQuantity = 0.0;
       
      } else if(!_isMounthDataCalculated){
        _isDayDataCalculated=false;
        _isMounthDataCalculated = false;
        _isWeekDataCalculated = true;

        
        //tottal mounth
        _totalMounthProfit = 0.0;
        _totalMounthSales = 0.0;
        _totalMouthQuantity = 0.0;

         //remettre à ero total day
        _totalSales = 0.0;
        _totalProfit = 0.0;
        _totalQuantity = 0.0;
      }

    }
  //
  final StreamController<List<Map<dynamic, dynamic>>> _ordersStreamController = StreamController<List<Map<dynamic, dynamic>>>.broadcast();

  Stream<List<Map<dynamic, dynamic>>> get ordersStream => _ordersStreamController.stream;
   
   @override
void dispose() {
  _ordersStreamController.close();
  super.dispose();
}

//



 
//

/*Future<void> fetchProductsFromFirebaseAndSaveToHive() async {
  late StreamSubscription<DatabaseEvent> productSubscription;
  List<Map<dynamic, dynamic>> productsDetails = [];
  List<Map<dynamic, dynamic>> convertedProducts = [];

  FirebaseException? error0;

  final database = FirebaseDatabase.instance;
  databaseReference = database.ref('ProductTable');

  print('all product :  $databaseReference');
  database.setLoggingEnabled(false);
  if (!kIsWeb) {
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }

  final productQuery = databaseReference;

  productSubscription = productQuery.onValue.listen(
    (DatabaseEvent event) {
      if (event.snapshot.value != null && event.snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;

        productsDetails.clear();
        data.forEach((key, productData) {
          productsDetails.add({key: productData});
        });

        convertedProducts.clear();
        for (var productData in productsDetails) {
          productData.forEach((key, value) async {
            if (key is String) {
              if (key.length < 1000 && int.tryParse(key) != null) {
                convertedProducts.add({
                  'ProductName': productData[key]['ProductName'],
                  'BuyingPrice': productData[key]['BuyingPrice'],
                  'SellingPrice': productData[key]['SellingPrice'],
                  'productqrname': key,
                });
              } else if (RegExp(r'^[a-zA-Z]+$').hasMatch(key)) {
                convertedProducts.add({
                  'ProductName': key,
                  'BuyingPrice': productData[key]['BuyingPrice'],
                  'SellingPrice': productData[key]['SellingPrice'],
                });
              }
            }
          });
        }

        print('convert: $convertedProducts');
        // Ouvrir la boîte Hive

        for (var productMap in convertedProducts) {
          var existingProduct = products.values.any(
  (element) =>
     // element.productqrname == productMap['productqrname'] &&
      element.ProductName == productMap['ProductName'],
);

          if (!existingProduct)  {
            Product product = Product.fromMap(productMap);
             products.add(product); 
          }else {
            print('dddddddddddd');
          }
        }
        print("bsr: ${convertedProducts.length}");
      } else {
        print('Invalid data format: ${event.snapshot.value}');
      }
    },
    onError: (Object o) {
      final error = o as FirebaseException;
      print('Error: ${error.code} ${error.message}');
    },
  );
}*/
Future<void> fetchProductsFromFirebaseAndSaveToHive() async {
  late StreamSubscription<DatabaseEvent> productSubscription;
  List<Map<dynamic, dynamic>> productsDetails = [];
List<Map<String, dynamic>> convertedProducts = [];
 

  FirebaseException? error0;
 

  final database = FirebaseDatabase.instance;

    databaseReference = database.ref('ProductTable');

 print('all product :  $databaseReference');
    database.setLoggingEnabled(false);
    if (!kIsWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }

     final productQuery = databaseReference;
      
    productSubscription = productQuery.onValue.listen(
      (DatabaseEvent event) {
       if (event.snapshot.value != null && event.snapshot.value is Map<dynamic, dynamic>) {
        //print('Child added: ${event.snapshot.}');
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        
        productsDetails.clear();
        data.forEach((key, productData) {
      // print('Original Data: { $key: $productData }'); 

       productsDetails.add({key: productData});
      // print('firebase product detail: $productsDetails'); 
     });
     print("pd: ${productsDetails.length}"); 
     convertedProducts.clear();
        for (var productData in productsDetails) {
    productData.forEach((key, value) async {

      if (key is String) {
        if (key.length < 1000 && int.tryParse(key) != null) {
          // Si la clé est un QR code, convertissez les valeurs appropriées
          
          convertedProducts.add({
            'ProductName': productData[key]['ProductName'],
            'BuyingPrice': productData[key]['BuyingPrice'],
            'SellingPrice': productData[key]['SellingPrice'],
            'productqrname': key,
          });
        } else if (RegExp(r'^[a-zA-Z]+$').hasMatch(key)) {
          // Si la clé est une chaîne alphabétique, convertissez les valeurs appropriées
          convertedProducts.add({
            'ProductName': key,
            'BuyingPrice': productData[key]['BuyingPrice'],
            'SellingPrice': productData[key]['SellingPrice'],
          });
        }
      }
    });
  }
      print('convert: $convertedProducts'); 
      //var  existsp = convertedProducts.any((product) => product["ProductName"].toString().toLowerCase() == e["ProductName"].toLowerCase());
      
      for(var e in convertedProducts){
      bool productExists = products.values.any((product) => product.productName == e['ProductName']);
     if (!productExists) {
    Product product = Product.fromMap(e);
    products.add(product);
  }
 
      }
      print("bsr: ${convertedProducts.length}"); 
      } else {
        print('Invalid data format: ${event.snapshot.value}');
      }
        
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        print('Error: ${error.code} ${error.message}');
      },
    );
  
}



  Future<void> getData() async {
    productsDetails.clear();
    for (int a = 0; a < products.length; a++) {
      var val = await products.getAt(a);
      productsDetails.add(val.details);
    }
    
      print('product details $productsDetails');
      for(var e in productsDetails){
        print('product : $e');
      }
   // filteredProductsDetails = productsDetails;
   // print('product filteredProductsDetails $filteredProductsDetails');
    searched = false;
    print("get called");
    notifyListeners();
  }
  //check if product exists
   bool checkIfProductExists(String productName) {
    bool exists = productsDetails.any((product) => product["ProductName"].toString().toLowerCase() == productName.toLowerCase());
    return exists;
  }
   bool checkIfProductqrExists(String productqrName) {
    bool exists = productsDetails.any((product) => product["productqrname"].toString().toLowerCase() == productqrName.toLowerCase());
    return exists;
  }
void addData(BuildContext context) {
  bool isProductExists = false;
  final providers = context.read<DatabaseProvider>();
  
  
  for (var product in productsDetails) {
    if (product["ProductName"] == productNameController.text) {
      isProductExists = true;
      break;
    }
  }

  if (isProductExists) {
    Fluttertoast.showToast(msg: "Ce produit exist déjà!");
  } else {
  
    if(!providers.isQrCodeTextFieldVisible){
      products.put(
      productNameController.text,
      Product(
        details: {
          "ProductName": productNameController.text,
          "BuyingPrice": productBuyingPriceController.text,
          "SellingPrice": productSellingPriceController.text,
        },
      ),
    );
    Fluttertoast.showToast(msg: "Product without QR added successfully");
    }else {
      products.put(
      productNameController.text,
      Product(
        details: {
          "ProductName":  productQrName.text,
          "BuyingPrice": productBuyingPriceController.text,
          "SellingPrice": productSellingPriceController.text,
          "productqrname": productNameController.text,
        },
      ),
    );
    providers.isQrCodeTextFieldVisible = false;
    Fluttertoast.showToast(msg: "Product with QR added successfully");
    }
    
  }

  productNameController.clear();
  productSellingPriceController.clear();
  productBuyingPriceController.clear();
  productQrName.clear();
  
  getData();
  notifyListeners();
}
//update product
void updateData(BuildContext context) {
  String productName = productNameController.text;
  String newBuyingPrice = productBuyingPriceController.text;
  String newSellingPrice = productSellingPriceController.text;
  String newProducQrtName = productQrName.text;

  
  if (double.parse(newBuyingPrice) > double.parse(newSellingPrice)) {
    Fluttertoast.showToast(msg: "Le prix d'achat ne peut pas être supérieur au prix de vente");
    return;
  }
  int productIndex = productsDetails.indexWhere((product) => product["ProductName"].toString().toLowerCase() == productName.toLowerCase());

  if (productIndex != -1) {
  
    productsDetails[productIndex]["BuyingPrice"] = newBuyingPrice;
    productsDetails[productIndex]["SellingPrice"] = newSellingPrice;
    productsDetails[productIndex]["productqrname"] = newProducQrtName;
    

    productExists = true;

   
    productNameController.clear();
    productBuyingPriceController.clear();
    productSellingPriceController.clear();
    productQrName.clear();

    notifyListeners();
  } else {
    Fluttertoast.showToast(msg: "Produit non trouvé");
  }
}

//update Products
void updateProductPrices(String productName, double newSellingPrice, double newBuyingPrice) {
  var productIndex = selectedProducts.indexWhere((product) => product["ProductName"] == productName);
  if (productIndex != -1) {
    // Check if buyingPrice is not higher than sellingPrice
    if (newBuyingPrice > newSellingPrice) {
      Fluttertoast.showToast(msg: "Le prix d'achat ne peut pas être supérieur au prix de vente");
      return ; 
    }

    selectedProducts[productIndex]["SellingPrice"] = newSellingPrice.toString();
    selectedProducts[productIndex]["BuyingPrice"] = newBuyingPrice.toString();
    notifyListeners();
  }
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

//filtered product
  Future<void> filterProducts(String val) async {
    print("Search query: $val"); 

    if (val.isEmpty) {
      
      filteredProductsDetails = [];
      print('details $filteredProductsDetails');
    } else {
      
      filteredProductsDetails = productsDetails.where((product) {
        bool matches =
            product["ProductName"].toLowerCase().contains(val.toLowerCase());
        print("Product: ${product["ProductName"]}, Matches: $matches"); // Debug statement
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


void generateControllers(Map<dynamic, dynamic> selectedProducts) {

      TextEditingController buyingPriceController =
      TextEditingController(text: selectedProducts["BuyingPrice"]);
      TextEditingController sellingPriceController =
      TextEditingController(text: selectedProducts["SellingPrice"]);

      productBuyingPriceController1.add(buyingPriceController);
      productSellingPriceController1.add(sellingPriceController);

    print('${productBuyingPriceController1.length}');
   
    productQuantityController.add(TextEditingController(text: "1.0") );
 
}


void generateControllerscodbar(Map<dynamic, dynamic> selectedProducts) {

      TextEditingController buyingPriceControllersc =
      TextEditingController(text: selectedProducts["BuyingPrice"]);
      TextEditingController sellingPriceControllersc =
      TextEditingController(text: selectedProducts["SellingPrice"]);

      productBuyingPriceController1.add(buyingPriceControllersc);
      productSellingPriceController1.add(sellingPriceControllersc);

    print('${productBuyingPriceController1.length}');
   
    productQuantityController.add(TextEditingController(text: "1.0") );
 
}

/////////////////
  int selectedIndex = -1;
  TextEditingController selectedText = TextEditingController();
  List<Map<dynamic, dynamic>> selectedProducts = <Map<dynamic, dynamic>>[];
void onSelect(String productName) async {

  var productIndex = productsDetails.indexWhere((product) => product["ProductName"] == productName);
if (selectedProducts.isEmpty) {
    
    selectedProducts = <Map<dynamic, dynamic>>[];
  }
  if (productIndex != -1) {
    bool isAlreadySelected = false;

    for (var element in selectedProducts) {
      if (productsDetails[productIndex]["ProductName"].toString().contains(element["ProductName"])) {
        isAlreadySelected = true;
        Fluttertoast.showToast(msg: "${element["ProductName"]} already available");
        break;
      }
    }

    if (!isAlreadySelected) {
      if (productsDetails[productIndex]["quantity"] == null) {
        productsDetails[productIndex]["quantity"] = 1.0;
      }
      selectedProducts.add(productsDetails[productIndex]);
      generateControllers(productsDetails[productIndex]);
      
    }
   
   

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
    String name = element["ProductName"];
    String productqrname = element["productqrname"]?? "";
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
          "SellingPrice": sellingPrice,
          "BuyingPrice": buyingPrice,
          "quantity": quantity,
          "totalPrice": "$totalPrice",
          "profit":"$profit",
          "productqrname" : productqrname
        },
      ),
    );
    

    
    //myOrders.add(value);
    
    
  }

  Fluttertoast.showToast(msg: "Orders Saved");
  selectedProducts.clear();
  productBuyingPriceController1.clear();
  productSellingPriceController1.clear();
  productQuantityController.clear();
  
  
  await getOrders();
  notifyListeners();
   _ordersStreamController.add(getAllOrders());
  
}

  void removeSelectedProduct(String productName) async {
  var productIndex = selectedProducts.indexWhere((product) => product["ProductName"] == productName);

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
    print(productCount);
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
  
  List<Map<dynamic, dynamic>> getAllOrders() {
    List<Map<dynamic, dynamic>> allOrders = <Map<dynamic, dynamic>>[];
   
  
  //getOrders();
  allOrders.clear();
  notifyListeners();
    for (int a = 0; a < orders.length; a++){
      var val =  orders.getAt(a);
      allOrders.add(val.details);
    }
    return allOrders;
  }


  Future<void> getOrders() async {
   
    ordersDetails.clear();
    //myOrders.clear();
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
    _ordersStreamController.add(getAllOrders());
  }
//ajout produit
  addProductDialog(BuildContext context, Color color) {
     final provider = context.read<DatabaseProvider>();
    
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
              SizedBox(
                height: 50,
                child:  Stack(
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
        suffixIcon: ElevatedButton(
           style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),   
        onPressed: () async {
                 String scannedBarcode = await scanBarcodeNormal();
                 int sc = int.parse(scannedBarcode);
                 if(sc == -1){
                  
                  Fluttertoast.showToast(msg: 'Echec du scan svp reessayer à nouveau');
                 }else {
                  
                 productNameController.text = scannedBarcode; 
                provider.toggleQrCodeTextFieldVisibility();
                 }
                  
              },
              child: const Icon(

                Icons.qr_code_2_outlined,
                color: Color(0xff368983),
              ),
      ),
      ),
      
    ),
   // Positioned(right: 0,),
  ],
),
              ),
              const SizedBox(
                height: 10,
              ),
                 SizedBox(
    height: 50,
    child:  Stack(
   children: [
    GestureDetector(
                
      child: TextField(
      controller: productBuyingPriceController,
      keyboardType: TextInputType.number,
      onTap: () {
  String productName = productNameController.text;
  productExists = checkIfProductExists(productName.toLowerCase());
     if (productExists) {
     Fluttertoast.showToast(msg: "$productName exists!");
     print("$productName exists!");
    } else {
     Fluttertoast.showToast(msg: "$productName n'exist pas!");
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
  ],
  ),
  ),
              
              const SizedBox(
                height: 10,
              ),
               SizedBox(
    height: 50,
    child:  Stack(
   children: [
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
  ],
  ),
  ),
              const SizedBox(
                height: 10,
              ),
  Visibility(
  visible: provider.isQrCodeTextFieldVisible,
  child: SizedBox(
    height: 50,
    child: Stack(
      children: [
        TextField(
          controller: provider.productQrName,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: BorderRadius.circular(20.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: BorderRadius.circular(20.r),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: BorderRadius.circular(20.r),
            ),
            hintText: "Non produit",
            hintStyle: TextStyle(
              color: color,
            ),
          ),
        ),
      ],
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

       child : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Annuler",
                  style: TextStyle(color: color, fontSize: 15.sp),
                  ),
                  ),
          TextButton(
  onPressed: () {
    String productName = productNameController.text;
    bool productExists = checkIfProductExists(productName);
    //bool productqrExist = checkIfProductqrExists(productName);
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
      if (productExists ) {
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
),
        ],
      ),
    );
  }
    //scan methode
Future<String> scanBarcodeNormal() async {
  String barcodeScanRes;
  
  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    print(barcodeScanRes);
  } on PlatformException {
    barcodeScanRes = 'Failed to get platform version.';
  }

  return barcodeScanRes;
}



    //
Future<void> getOrdersForCurrentDay() async{
    Completer<void> completer = Completer<void>();
   List<Map<dynamic, dynamic>> alldayOrders = <Map<dynamic, dynamic>>[];
      
  // Récupérez la liste mise à jour des commandes pour la journée en cours
  
  if (!_isDayDataCalculated) {
    //getOrders();
   alldayOrders = getAllOrders();
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
    
  completer.complete();
  
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

  notifyListeners();
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

  // scan 
 
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

//scanner function
 
void onSelectbarcode(String productName) async {

  var productIndex = productsDetails.indexWhere((product) => product["productqrname"] == productName);

if (selectedProducts.isEmpty) {
    selectedProducts = <Map<dynamic, dynamic>>[];
  }
  if (productIndex != -1) {
    bool isAlreadySelected = false;

    for (var element in selectedProducts) {
      if (productsDetails[productIndex]["productqrname"].toString().contains(element["productqrname"])) {
        isAlreadySelected = true;
        Fluttertoast.showToast(msg: "${element["productqrname"]} exist dejà");
        print('exist deja $selectedProducts');
        break;
      }
    }

    if (!isAlreadySelected) {
      if (productsDetails[productIndex]["quantity"] == null) {
        productsDetails[productIndex]["quantity"] = 1.0;
      }
      selectedProducts.add(productsDetails[productIndex]);
      print("prduct : ${productsDetails[productIndex]}");
      
   generateControllerscodbar(productsDetails[productIndex]);
      
    }
   
   
    

    productCount = selectedProducts.length;
   notifyListeners();
  } else {
    print("Product not found!"); 
  }
}


//login
 void logout() {
  User? currentUser = users.get('current_user');
  if (currentUser != null) {
    currentUser.isLoggedIn = false; 
  }
  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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