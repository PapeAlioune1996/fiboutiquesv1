
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  int indexx;
  Chart({Key? key, required this.indexx}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<String>? a;
  bool b = true;
  bool j = true;
  @override
  Widget build(BuildContext context) {
   
    
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: SfCartesianChart(
        
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final int sales;
}
