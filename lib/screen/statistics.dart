import 'package:fiboutiquesv1/Providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}
class _StatisticsState extends State<Statistics> {
  List day = ['Day', 'Week', 'Month', 'Year'];
  Color mcolor = const Color.fromRGBO(54, 137, 131, 1);
  int index_color = 1;
  @override
  void initState() {
     WidgetsBinding.instance?.addPostFrameCallback((_) {
    fetchData();
  });

    super.initState();
  }
  Future<void> fetchData() async {
  await Provider.of<DatabaseProvider>(context, listen: false).getOrders();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child:  Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          children: [
        Consumer<DatabaseProvider>(
          builder: (context, databaseProvider, child) => SfCartesianChart(
          title: ChartTitle(text: "Today's Hourly Order Count"),
          tooltipBehavior: TooltipBehavior(enable: true, header: "Orders"),
          series: <ChartSeries>[
            LineSeries<ChartData, int>(
              dataSource: databaseProvider.chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
          primaryXAxis: NumericAxis(
            title: AxisTitle(text: 'Hour'),
            interval: 1,
            majorGridLines: MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Order Count'),
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0),
          ),
      ),
        ),
        Center(
        child:  Text(
      'Sales',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
        ),
        
    
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      
        ElevatedButton(
          onPressed: ()  {
            Provider.of<DatabaseProvider>(context, listen: false).getOrdersForCurrentDay();
          },
          child: Text('Day'),
        ),
        
        ElevatedButton(
          onPressed: ()  {
         
             Provider.of<DatabaseProvider>(context, listen: false).getOrdersForCurrentWeek();
          },
          child: Text('Week'),
        ),
        ElevatedButton(
          onPressed: () {
          
            //Provider.of<DatabaseProvider>(context, listen: false).getOrdersForCurrentMonth();
          },
          child: Text('Month'),
        ),
        ElevatedButton(
          onPressed: () {
            // Add functionality for the fourth button here
          },
          child: Text('Year'),
        ),
      ],
    ),

     // Add the DataTable widget with three columns: Total Price, Quantity, and Profit
    Consumer<DatabaseProvider>(
              builder: (context, databaseProvider, child) {
                 String totalSalesText = databaseProvider.totalSales.toStringAsFixed(2);
                 String totalQuantityText = databaseProvider.totalQuantity.toStringAsFixed(2);
                 String totalProfitText = databaseProvider.totalProfit.toStringAsFixed(2);


                List<DataRow> rows = []; // Initialize with actual data

                return DataTable(
  columns: const <DataColumn>[
    DataColumn(
      label: Text(
        'Total Price',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        'Quantité',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        'Bénéfice',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
  rows: <DataRow>[
    DataRow(
      cells: <DataCell>[
        DataCell(Text(totalSalesText)),
        DataCell(Text(totalQuantityText)),
        DataCell(Text(totalProfitText)),
      ],
    ),
  ],
);

                  
              },
            ),
    
  ],
),

          
      ),
      ),
    );
  }


}
