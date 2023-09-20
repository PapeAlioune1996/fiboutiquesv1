
import 'package:fiboutiquesv1/screen/home.dart';
import 'package:fiboutiquesv1/screen/statistics.dart';
import 'package:flutter/material.dart';



class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  set _fabHeight(double fabHeight) {}

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List Screen = [const MyHomeScree(),  const Statistics()];

  //late final RecorderController recorderController;


 


 
 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Screen[index_color],
      bottomNavigationBar: BottomAppBar(
        height: 55,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(bottom : 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               IconButton(
                  onPressed: (){
                    setState(() {
                    index_color = 0;
                  });
                  },
                 
                 icon : Icon(
                  Icons.home,
                  color: index_color == 0 ? const Color(0xff368983) : Colors.grey,
                ),
                
                ),
                IconButton(
                  onPressed: (){
                    setState(() {
                    index_color = 1;
                  });

                },
                icon : Icon(
                  Icons.bar_chart_outlined,
                  color: index_color == 1 ? const Color(0xff368983) : Colors.grey,
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