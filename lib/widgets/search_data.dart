
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  
  final products = [
     "Pain",
     "sac de riz",
     "1Litre d'huile",
     "ecouteur",
     "savon"
  ];

  final recentProduct = [
    "Pain",
    "sac de riz",
  ];
 
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
       IconButton(
        onPressed: (){
          query = "";
        }, 
       icon: const Icon(Icons.clear, 
          color: Color(0xff368983),
       ),
       )

    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
     return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation,
        color: const Color(0xff368983),
        ),
        onPressed: (){
      close(context, "");
       },
        );
   }

  @override
  Widget buildResults(BuildContext context) {
      return Container();
    }

  @override
  Widget buildSuggestions(BuildContext context) {
    
   final suggestionList = query.isEmpty
       ? recentProduct:
       products.where((element) => element.toLowerCase().contains(query.toLowerCase())).toList();

   return ListView.builder(itemBuilder: (
    context, index) => 
        ListTile(
          onTap: (){
            showResults(context);
          },
          leading: const Icon(Icons.menu),
          title: RichText(
            text: TextSpan(
             text : suggestionList[index].substring(0,query.length),
             style: const TextStyle(
              color: Color(0xff368983),
              fontWeight: FontWeight.bold,
             ),
             children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle( color: const Color(0xff368983).withOpacity(0.2),
                fontWeight: FontWeight.bold
                )
              ),
             ],
            ),
          ),

        ),
        itemCount: suggestionList.length,
   );
}

} 