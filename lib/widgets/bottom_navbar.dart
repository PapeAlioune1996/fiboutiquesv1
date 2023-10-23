import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:fiboutiquesv1/screen/home.dart';
import 'package:fiboutiquesv1/screen/scanproductforregister.dart';
import 'package:fiboutiquesv1/screen/statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  // ignore: non_constant_identifier_names
  int index_color = 0;
  List screen = [const MyHomeScree(),const ScanProdut(), const Statistics()];

  late CircularBottomNavigationController navigationController;

  @override
  void initState() {
    
    navigationController = CircularBottomNavigationController(index_color);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: screen[index_color],
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
              CupertinoIcons.camera_circle_fill,
              "Camera",
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
              circleStrokeColor: Colors.white,
              index_color == 1 ? const Color(0xff368983) : Colors.grey,
              ),
          TabItem(
              CupertinoIcons.chart_bar_alt_fill,
              "Analytics",
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
              circleStrokeColor: Colors.white,
              
              index_color == 2 ? const Color(0xff368983) : Colors.grey,
              ),
        ],
        selectedCallback: (selectedPos) {
          setState(() {
            index_color = selectedPos!;
          });
        },
      ),
    
    );
  }

//methode
}
