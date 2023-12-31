// ignore_for_file: avoid_print

import 'package:fiboutiquesv1/Providers/database_provider.dart';
import 'package:fiboutiquesv1/Providers/totalprice.dart';
import 'package:fiboutiquesv1/screen/loginscreen.dart';
import 'package:fiboutiquesv1/screen/modifierpassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class HomeAppBar extends StatelessWidget {
  final double totalPrice;

  const HomeAppBar({
    Key? key, required this.totalPrice
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    // Access TotalPriceProvider to update totalPrice
 



    TotalPriceProvider totalPriceProvider =
        Provider.of<TotalPriceProvider>(context);
    const mColor = Color(0xff368983);
    return AnimatedContainer(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: mColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.r)),
      ),
      duration: const Duration(seconds: 1),
      curve: Curves.bounceIn,
      child:  Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<DatabaseProvider>(
        builder: (context, databaseProvider, child)  => PopupMenuButton<String>(
            
              color: Colors.white,
                   onSelected: (value) {
                  if (value == 'deconnexion') {
                    databaseProvider.logout();
                   // await FirebaseAuth.instance.signOut();
                     Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
                  } else if (value == 'modifier_password') {
                  
                   
                    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const ModifierPassword(),
      ),
      (route) => false,
    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Deconnexion', 'Modifier_password'}
                      .map((String choice) {
                        print(choice);
                    return PopupMenuItem<String>(
                      
                      value: choice.toLowerCase(),
                      child: Text(choice,
                      style: const TextStyle(
                        color: mColor,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    );
                  }).toList();
                },
                child: Icon(Icons.settings, size: 30.sp, color: Colors.white),
                ),
        ),
                
              Text(
                "${totalPriceProvider.totalPrice} FCFA", // Updated to use provider's total price
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
              Consumer<DatabaseProvider>(
                builder: (context, databaseProvider, child) => IconButton(
                    onPressed: databaseProvider.openClose,
                    icon: Icon(
                        databaseProvider.isOpen ? Icons.close : Icons.search,
                        size: 30.sp,
                        color: Colors.white)),
              ),
            ],
          ),
          Visibility(
            visible: Provider.of<DatabaseProvider>(context).isOpen,
            child: Column(
              children: [
                Consumer<DatabaseProvider>(
                    builder: (context, databaseProvider, child) {
                  return SizedBox(
                    // height: 60.h,
                    width: 350.w,
                    child: TextField(
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp),
                      controller: databaseProvider.searchController,
                      onChanged: (value) async {
                        await databaseProvider.filterProducts(value);
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          fillColor: Colors.black26,
                          filled: true,
                          hintText: "Search Products",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.sp),
                          suffixIcon: const Icon(
                            CupertinoIcons.search,
                            color: Colors.white,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 18.sp),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide.none)),
                    ),
                  );
                }),
                SizedBox(
                  height: 8.h,
                ),
                Consumer<DatabaseProvider>(
                  builder: (context, databaseProvider, child) => SizedBox(
                    height: databaseProvider.filteredProductsDetails.isEmpty
                        ? 80.h
                        : databaseProvider.searched
                            ? databaseProvider.filteredProductsDetails.length *
                                52.h
                            : 2 * 52.h,
                    child: ListView.builder(
                      itemCount:
                          databaseProvider.filteredProductsDetails.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var product =
                            databaseProvider.filteredProductsDetails[index];
                        print(
                            "Filtered Products Length: ${databaseProvider.filteredProductsDetails.length}"); // Print filtered products length for debugging

                        return InkWell(
                          onTap: () {
                            databaseProvider.onSelect(product["ProductName"]);
                          //  databaseProvider.onSelectbarcode(product["name"]);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            margin: EdgeInsets.all(5.sp),
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 8.w),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.cart),
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Text(
                                    product["ProductName"],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
