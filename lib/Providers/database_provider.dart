import 'package:fiboutiquesv1/Database/order_details.dart';
import 'package:fiboutiquesv1/Database/product.dart';
import 'package:fiboutiquesv1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productSellingPriceController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  TextEditingController productSellingPriceController1 =
      TextEditingController();
  TextEditingController productBuyingPriceController = TextEditingController();
  TextEditingController productBuyingPriceController1 = TextEditingController();
  List<Map<dynamic, dynamic>> productsDetails = <Map<dynamic, dynamic>>[];
  List<Map<dynamic, dynamic>> ordersDetails = <Map<dynamic, dynamic>>[];
  List<Map<dynamic, dynamic>> filteredProductsDetails =
      <Map<dynamic, dynamic>>[];

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
      bool matches = product["name"].toLowerCase().contains(val.toLowerCase());
      print("Product: ${product["name"]}, Matches: $matches"); // Debug statement
      return matches;
    }).toList();
  }

  print("Filtered products count: ${filteredProductsDetails.length}"); // Debug statement

  notifyListeners();
}






  int selectedIndex = -1;
  TextEditingController selectedText = TextEditingController();

 onSelect(int index) async {
  print("Selected Index: $index"); // Debug statement

  // Ensure the index is within the bounds of the productsDetails list
  if (index >= 0 && index < productsDetails.length) {
    selectedIndex = index;
    selectedText.text = await productsDetails[selectedIndex]["name"];
    productBuyingPriceController1.text = productsDetails[index]["buyingPrice"];
    productSellingPriceController1.text = productsDetails[index]["sellingPrice"];
    searched = false;
    isOpen = !isOpen;

    // Print selected product details for debugging
    print("Selected Product Name: ${selectedText.text}");
    print("Buying Price: ${productBuyingPriceController1.text}");
    print("Selling Price: ${productSellingPriceController1.text}");
    
    notifyListeners();
  } else {
    print("Invalid index selected!"); // Debug statement for invalid index
  }
}


  

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
            Navigator.pop(context); // Close the dialog after adding the product
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

  double totalPrice = 0.0;

  saveOrder()async{
    String a = selectedText.text ;
    print(a);
    totalPrice = productBuyingPriceController1.text.isEmpty
        ? 0
        : productSellingPriceController1.text.isEmpty
            ? 0
            : productQuantityController.text.isEmpty
                ? 0
                : (double.parse(productSellingPriceController1.text) *
                    double.parse(productQuantityController.text));
    DateTime dateTime = DateTime.now();
    productSellingPriceController1.text.isEmpty
        ? Fluttertoast.showToast(msg: "Please enter selling price")
        : productBuyingPriceController1.text.isEmpty
            ? Fluttertoast.showToast(msg: "Please enter buying price")
            : productQuantityController.text.isEmpty
                ? Fluttertoast.showToast(msg: "Please enter product quantity")
                : orders
                    .put(
                        "order${orders.length}",
                        Product(details: {
                          "productName": a,
                          "orderNo": "${orders.length}",
                          "date":
                              "Time: ${dateTime.minute} : ${dateTime.hour}  Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}",
                          "sellingPrice": productSellingPriceController1.text,
                          "buyingPrice": productBuyingPriceController1.text,
                          "quantity" : productQuantityController.text,
                          "totalPrice": "$totalPrice",
                        }))
                    .then(
                        (value) => Fluttertoast.showToast(msg: "Order Saved"));
    print(orders.length);
  }

  getOrders() async {
    for (int a = 0; a < orders.length; a++) {
      var val = await orders.getAt(a);
      ordersDetails.add(val.details);
      print(ordersDetails);
      notifyListeners();
    }
  }
}
