import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:fiboutiquesv1/screen/home.dart';
import 'package:fiboutiquesv1/screen/orders_screen.dart';
import 'package:fiboutiquesv1/screen/statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  set _fabHeight(double fabHeight) {}

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List Screen = [const MyHomeScree(), const Statistics()];

  //late final RecorderController recorderController;

  late CircularBottomNavigationController navigationController;

  @override
  void initState() {
    navigationController = CircularBottomNavigationController(index_color);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Screen[index_color],
      bottomNavigationBar: CircularBottomNavigation(
        controller: navigationController,
        barBackgroundColor: const Color(0xff368983),
        circleStrokeWidth: 2.w,
        [
          TabItem(
              CupertinoIcons.home,
              "Home",
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
              circleStrokeColor: Colors.white,
              index_color == 0 ? const Color(0xff368983) : Colors.grey),
         
          TabItem(
              CupertinoIcons.chart_bar_alt_fill,
              "Analytics",
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
              circleStrokeColor: Colors.white,
              index_color == 1 ? const Color(0xff368983) : Colors.grey),
        ],
        selectedCallback: (selectedPos) {
          setState(() {
            index_color = selectedPos!;
          });
        },
      ),
      // BottomAppBar(
      //   height: 55,
      //   shape: const CircularNotchedRectangle(),
      //   child: Padding(
      //     padding: const EdgeInsets.only(bottom : 15),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //          IconButton(
      //             onPressed: (){
      //               setState(() {
      //               index_color = 0;
      //             });
      //             },
      //
      //            icon : Icon(
      //             Icons.home,
      //             color: index_color == 0 ? const Color(0xff368983) : Colors.grey,
      //           ),
      //
      //           ),
      //           IconButton(
      //             onPressed: (){
      //               setState(() {
      //               index_color = 1;
      //             });
      //
      //           },
      //           icon : Icon(
      //             Icons.bar_chart_outlined,
      //             color: index_color == 1 ? const Color(0xff368983) : Colors.grey,
      //           ),
      //           ),
      //
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

//methode
}
