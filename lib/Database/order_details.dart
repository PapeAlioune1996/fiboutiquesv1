import 'package:hive/hive.dart';

part 'order_details.g.dart';

@HiveType(typeId: 2)
class OrderDetails {
  OrderDetails({required this.details});
  @HiveField(1)
  Map details;

}
