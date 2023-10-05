import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Providers/database_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    Provider.of<DatabaseProvider>(context, listen: false).getOrders();
    super.initState();
  }

  Color mcolor = const Color(0xff368983);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Orders List",
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
          centerTitle: true,
          backgroundColor: mcolor),
      body: Column(
        children: [
          Expanded(
              child: Consumer<DatabaseProvider>(
            builder: (context, databaseProvider, child) => ListView.builder(
              itemCount: databaseProvider.ordersDetails.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: ListTile(
                    tileColor: mcolor,
                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                                "Product Name :",style: TextStyle(color: Colors.white)),
                            Text(
                                "${databaseProvider.ordersDetails[index]["productName"]}",style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                                "Order No.",style: TextStyle(color: Colors.white)),
                            Text(
                                "${databaseProvider.ordersDetails[index]["orderNo"]}",style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 20.w,
                        children: [
                          Text("Selling Price : ${databaseProvider.ordersDetails[index]["sellingPrice"]}",style: const TextStyle(color: Colors.white)),
                          Text("Buying Price : ${databaseProvider.ordersDetails[index]["buyingPrice"]}",style: const TextStyle(color: Colors.white)),
                          Text("Quantity : ${databaseProvider.ordersDetails[index]["quantity"]}",style: const TextStyle(color: Colors.white)),
                          Text("Total Price : ${databaseProvider.ordersDetails[index]["totalPrice"]}",style: const TextStyle(color: Colors.white)),
                          Text("Date : ${databaseProvider.ordersDetails[index]["date"]}",style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}
