import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  Product({required this.details});
  @HiveField(0)
  Map details;

   Product.fromMap(Map<dynamic, dynamic> map)
      : details = map;

      // Getter pour obtenir le nom du produit à partir du champ 'details'
  String get productName {
    return details['ProductName'];
  }

}
