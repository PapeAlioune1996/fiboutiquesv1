import 'package:fiboutiquesv1/Database/product.dart';
import 'package:fiboutiquesv1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
void generateControllers(List<Map<dynamic, dynamic>> selectedProducts) {
  productSellingPriceController1.clear();
  productBuyingPriceController1.clear();
  productQuantityController.clear();

  for (int i = 0; i < selectedProducts.length; i++) {
    Map<dynamic, dynamic> productDetails = selectedProducts[i];
    
    // Cast the dynamic map to a map with specific types
    Map<String, dynamic> typedProductDetails = Map<String, dynamic>.from(productDetails);

    String productName = typedProductDetails["name"];
    String buyingPrice = typedProductDetails["buyingPrice"];
    String sellingPrice = typedProductDetails["sellingPrice"];

    TextEditingController buyingPriceController =
        TextEditingController(text: buyingPrice);
       
    TextEditingController sellingPriceController =
        TextEditingController(text: sellingPrice);

    TextEditingController quantityController =
        TextEditingController(text: "1.0");

    // Add the controllers to the respective lists
    productBuyingPriceController1.add(buyingPriceController);
    productSellingPriceController1.add(sellingPriceController);
    productQuantityController.add(quantityController);
  }
}


/////////////////
  int selectedIndex = -1;
  TextEditingController selectedText = TextEditingController();
  List<Map<dynamic, dynamic>> selectedProducts = <Map<dynamic, dynamic>>[];
void onSelect(String productName) async {
  // Find the product by name in productsDetails list
  var productIndex = productsDetails.indexWhere((product) => product["name"] == productName);

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

    searched = false;
    isOpen = !isOpen;

    productCount = selectedProducts.length;
    notifyListeners();
  } else {
    print("Product not found!"); 
  }
}

 /*onSelect(int index) async {
   print("products details ========:$productsDetails ");
   print("products index ========:${productsDetails[index]} ");
  if (index >= 0 && index < productsDetails.length) {
    bool isAlreadySelected = false;
    //print(index);
    print("amnadara ${productsDetails[index]}");

    for (var element in selectedProducts) {
      if (productsDetails[index]["name"]
          .toString()
          .contains(element["name"])) {
            print("detail name ${productsDetails[index]["name"]}");
        isAlreadySelected = true;
        print("${element["name"]} already available");
        Fluttertoast.showToast(msg: "${element["name"]} already available");
        break; 
      }
    }

    if (!isAlreadySelected) {
      print("${productsDetails[index]["name"]} not available");
      
      if (productsDetails[index]["quantity"] == null) {
        productsDetails[index]["quantity"] = 1.0;
      }
      selectedProducts.add(productsDetails[index]);
      print("selected products: ${productsDetails[index]}");
    }

   searched = false;
    isOpen = !isOpen;

    print("selected products: ${selectedProducts}");
    productCount = selectedProducts.length;
    print("Number of Products: $productCount");
    //print("selected products: ${selectedProducts}");

    notifyListeners();
  } else {
    print("Invalid index selected!"); 
  }
} */


//caliculate 
double calculateTotalPrice(List<Map<String, dynamic>> selectedProducts) {
  double totalPrice = 0.0;

  for (var product in selectedProducts) {
    double sellingPrice = product["sellingPrice"] ?? 0.0;
    double quantity = product["quantity"] ?? 0.0; 
    totalPrice += sellingPrice * quantity;
  }

  return totalPrice;
}


 double totalPrice = 0.0;
  saveOrder() async {
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
       totalPrice = ( double.parse(element["sellingPrice"])* double.parse(quantity));
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
  }
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
    selectedProducts.removeAt(productIndex);
    print(productIndex);
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