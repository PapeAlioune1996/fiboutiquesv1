import 'dart:io';

import 'package:fiboutiquesv1/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyHomeScree extends StatefulWidget {
  const MyHomeScree({super.key});

  @override
  State<MyHomeScree> createState() => _MyHomeScreeState();
}

class CardItem {
  final String title;
  final String subtitle;

  const CardItem({
    required this.title,
    required this.subtitle,
  });
}


class _MyHomeScreeState extends State<MyHomeScree> {

  Color mcolor = Color(0xff368983);

  var history;
  final List<String> day = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'friday',
    'saturday',
    'sunday'
  ];

  List<CardItem> items = [
    CardItem(
      title : '2:30',
      subtitle : 'naudio',
    ),
    CardItem(
      title : '1:30',
      subtitle : 'naudio',
    ),
    CardItem(
      title : '2:50',
      subtitle : 'naudio',
    ),
    CardItem(
      title : '6:00',
      subtitle : 'naudio',
    )
  ];

 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                SizedBox(height: 90, child: _head()),
                SizedBox(
                        height: 10,
                      ),
                 
                 Container(
                 color: Colors.grey.withOpacity(0.1),
                  height: 100,
                  
                  child: ListView.separated(
                    
                  padding: EdgeInsets.all(8) ,                 
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (context, index) => SizedBox(width: 12,),
                  itemBuilder: (context, index) => builderCard(item : items[index] ),
                 ),
                 ),
                 
                 
                 Container(
                  child: Padding (

                    padding: const EdgeInsets.all(15),

                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.shopping_cart,
                      color: mcolor,
                       size: 30,
                       shadows: [
                        BoxShadow(
                            blurRadius: 2,
                            
                        ),
                         ],
                      ),
                       Icon(Icons.add,
                       color: mcolor,
                       size: 30,
                       shadows: [
                        BoxShadow(
                            blurRadius: 2,
                            
                        ),
                       ],
                       ),
                    ],
                  ),
                    ),
                 ),
                 //
                
                    Expanded(
                      child: 
                 Container(
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      
                        buildProduct(),
                        SizedBox(height: 10,),
                        buildProduct(),
                        SizedBox(height: 10,),
                        buildProduct(),
                        SizedBox(height: 10,),
                        buildProduct(),
                    ],
                  ),
                    
                  
                 ),
                    ),
                  ],
               
            ),
           ),
    );
  }

Widget buildProduct()   =>     Container(
                        width: 400,
                       // padding: EdgeInsets.all(12),
                        
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                                  
                          children: [
                           
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Product name'),
                                Flexible(
  
  child: Container(
    
    width: 80,
  height: 35,// Add this line
    child: TextField(
      decoration: InputDecoration(
        labelText: '2500',
        labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2, color: Color(0xff368983)),
        ),
      ),
    ),
  ),
),

                                
    Flexible(
         flex: 1,
           child: Container(
    
             width: 80,
            height: 35,
   // Add this line
    child: TextField(
      decoration: InputDecoration(
        labelText: '300',
        labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2, color: Color(0xff368983)),
        ),
      ),
    ),
  ),
),

                                  
                                  
                                

                                
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.delete,color: Colors.red,),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
  //
  Widget builderCard({required CardItem item,}) => 
                  Container(
                        width: 200,
                        
                        color: Colors.white54,
                        child: Column(
                         
                          children: [
                           Padding(
                            padding: EdgeInsets.all(10),
                           child : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            
                            children: [
                              Text(item.title),
                               Icon(Icons.close,
                               color: Colors.black.withOpacity(0.3),
                               ),
                               
                                  ],
                                ),
                                
                           ),

                             Padding(
                             padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                             child : Row(
                             
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.play_arrow,
                               color: Colors.black.withOpacity(0.3),
                              ),
                              LinearPercentIndicator(
                                      width: 140,
                                    )
                            ],
                           ),
                             ),
                    
                          ],
                        ),
                      );

  Widget getList(String history, int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
        //  history.delete();
        },
        child: get(index, history));
  }

  ListTile get(int index, String history) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        //child: Image.asset('images/${history.name}.png', height: 40),
      ),
      title: Text(
       // history.name,
       'historyname',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
       'historydate',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
       // history.amount,
        'Total price',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19,
        ),
      ),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              decoration: BoxDecoration(
                color: Color(0xff368983),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Color.fromRGBO(250, 250, 250, 0.1),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => const SearchPage()) );
                          },
                          
                         child: Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.white,
                        ),
                        )
                        
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Text(
                          'Prix Total : FCFA',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  
}