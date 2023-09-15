
import 'dart:io';

import 'package:fiboutiquesv1/screen/add.dart';
import 'package:fiboutiquesv1/screen/home.dart';
import 'package:fiboutiquesv1/screen/settings.dart';
import 'package:fiboutiquesv1/screen/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List Screen = [MyHomeScree(),  Statistics()];
 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
           
          
        },
        child: Icon(Icons.mic_none_outlined),
        backgroundColor: Color(0xff368983),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 55,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 35,
                  color: index_color == 0 ? Color(0xff368983) : Colors.grey,
                ),
              ),
             
              
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 35,
                  color: index_color == 1 ? Color(0xff368983) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //methode
  


}