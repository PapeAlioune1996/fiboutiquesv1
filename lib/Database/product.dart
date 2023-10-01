import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  Product({required this.details});
  @HiveField(0)
  Map details;

}
