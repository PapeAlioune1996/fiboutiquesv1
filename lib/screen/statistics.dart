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
  bool _isDayButtonClicked = false;
  bool _isWeekButtonClicked = false;
  bool _isMonthButtonClicked = false;
 
  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
    fetchData();
  });
    
    super.initState();
  }
 
  Future<void> fetchData() async {
    print("Fetching data...");
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
      body: StreamBuilder<void>(
        stream: Provider.of<DatabaseProvider>(context).ordersStream,
        builder: (context, snapshot) {
         
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
             child :  
             CircularProgressIndicator(
              color: const Color(0xff368983),
              backgroundColor: const Color(0xff368983).withOpacity(0.1),
              value: 0.50,
            ),
            );
          }else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          ); // Display an error message if fetching data fails
        } else {
            return buildStatisticsContent(); // Call a separate function to build your Statistics widget content
          }
        },
      ),
     
    );
  }

  Widget buildStatisticsContent() {
    return SingleChildScrollView(
          child:  Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          children: [
        Consumer<DatabaseProvider>(
          builder: (context, databaseProvider, child) => SfCartesianChart(
          title: ChartTitle(text: "Graphique de vos ventes"),
          tooltipBehavior: TooltipBehavior(enable: true, header: "Ventes"),
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
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Order Count'),
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
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
          onPressed:  _isMonthButtonClicked
        ? null // Disable the button if Day or Week button is clicked
        : ()   {
         // await Provider.of<DatabaseProvider>(context, listen: false).saveOrder(); 
              Provider.of<DatabaseProvider>(context, listen: false).getOrdersForCurrentDay();
            setState(() {
                _isWeekButtonClicked = false;
                _isDayButtonClicked = false;
                _isMonthButtonClicked = true; 
            });
          },
          child: const Text('Day'),
        ),
        
        ElevatedButton(
           onPressed:  _isDayButtonClicked
        ? null // Disable the button if Day or Week button is clicked
        : ()  {
             // await Provider.of<DatabaseProvider>(context, listen: false).saveOrder(); 
              Provider.of<DatabaseProvider>(context, listen: false).getOrdersForCurrentWeek();
             setState(() {
              _isWeekButtonClicked = false;
                _isDayButtonClicked = true;
                _isMonthButtonClicked = false; 
             });
          },
          child: const Text('Week'),
        ),
        ElevatedButton(
          onPressed: _isWeekButtonClicked
      ? null // Disable the button if it's already clicked
      : () async {
          // Fetch data for the current month
          await Provider.of<DatabaseProvider>(context, listen: false).getOrdersForCurrentMonth();

          // Set the state to update the UI
          setState(() {
            _isMonthButtonClicked = false;
            _isDayButtonClicked = false;
            _isWeekButtonClicked = true;
          });
        },
          child: const Text('Month'),
        ),
        ElevatedButton(
          onPressed: () {
            // Add functionality for the fourth button here
          },
          child: const Text('Year'),
        ),
      ],
    ),

     // Add the DataTable widget with three columns: Total Price, Quantity, and Profit
    Consumer<DatabaseProvider>(
              builder: (context, databaseProvider, child) {
                String totalSalesText = !_isMonthButtonClicked
    ? databaseProvider.totalMounthSales.toStringAsFixed(2)
    : !_isDayButtonClicked
        ? databaseProvider.totalSales.toStringAsFixed(2)
        : !_isWeekButtonClicked
            ? databaseProvider.totalWeekSales.toStringAsFixed(2)
            : '';

String totalQuantityText = !_isMonthButtonClicked
    ? databaseProvider.totalMounthQuantity.toStringAsFixed(2)
    : !_isDayButtonClicked
        ? databaseProvider.totalQuantity.toStringAsFixed(2)
        : !_isWeekButtonClicked
            ? databaseProvider.totalWeekQuantity.toStringAsFixed(2)
            : '';

String totalProfitText = !_isMonthButtonClicked
    ? databaseProvider.totalMounthProfit.toStringAsFixed(2)
    : !_isDayButtonClicked
        ? databaseProvider.totalProfit.toStringAsFixed(2)
        : !_isWeekButtonClicked
            ? databaseProvider.totalWeekProfit.toStringAsFixed(2)
            : '';



                List<DataRow> rows = []; // Initialize with actual data

                return DataTable(
  columns: const <DataColumn>[
    DataColumn(
      label: Text(
        'Prix Total',
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
      );
  }


}
