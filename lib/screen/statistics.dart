import 'package:fiboutiquesv1/Providers/database_provider.dart';
import 'package:fiboutiquesv1/widgets/bottom_navbar.dart';
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
 
// Use databaseProvider to access the data and update the UI


  List<Map<dynamic, dynamic>> allOrders = <Map<dynamic, dynamic>>[];
 
  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
    fetchData();
  });
    
    super.initState();
  }
 
 
  Future<void> fetchData() async {
   // print("Fetching data...");
  await Provider.of<DatabaseProvider>(context, listen: false).getOrders();
}




  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context);
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
           color: mcolor,
          ),
          onPressed: () {
             Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const Bottom(),
                              ),
                              (route) => false); // Ajoutez ici la logique de navigation vers l'écran précédent
          },
        ),
        title: Text("Statistiques",
            style: TextStyle(fontSize: 20.sp,
             fontWeight: FontWeight.bold,
             color: mcolor,
             ),
             
            ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<dynamic, dynamic>>>(
        stream: databaseProvider.ordersStream,
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
      'Mes ventes',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
        ),
        
    Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
    child : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      
        ElevatedButton(
          onPressed:  Provider.of<DatabaseProvider>(context, listen: false).isDayDataCalculated  
        ? null // Disable the button if Day or Week button is clicked
        : ()   async {
         
              await Provider.of<DatabaseProvider>(context, listen: false).getOrdersForCurrentDay();
            setState(() {
              Provider.of<DatabaseProvider>(context, listen: false).setIsSelectedButton();
            });
          },
          child: const Text('Day',
          style: TextStyle(
            color: Color(0xff368983),
          ),
          ),
        ),
        
        ElevatedButton(
           onPressed: Provider.of<DatabaseProvider>(context, listen: false).isWeekDataCalculated 
        ? null // Disable the button if Day or Week button is clicked
        : ()  {
             
              Provider.of<DatabaseProvider>(context, listen: false).getOrdersForCurrentWeek();
             setState(() {
              Provider.of<DatabaseProvider>(context, listen: false).setIsSelectedButton();
             });
          },
          child: const Text('Week',
           style: TextStyle(
            color: Color(0xff368983),),
          ),
        ),
        ElevatedButton(
          onPressed: Provider.of<DatabaseProvider>(context, listen: false).isMounthDataCalculated
      ? null // Disable the button if it's already clicked
      : () async {
          // Fetch data for the current month
          await Provider.of<DatabaseProvider>(context, listen: false).getOrdersForCurrentMonth();

          // Set the state to update the UI
          setState(() {
            Provider.of<DatabaseProvider>(context, listen: false).setIsSelectedButton();
          });
        },
          child: const Text('Month',
           style: TextStyle(
            color: Color(0xff368983),),
            ),
        ),
       Visibility(
        visible: false,
        child:  ElevatedButton(
          onPressed: () async {
            // Add functionality for the fourth button here
            //await Provider.of<DatabaseProvider>(context, listen: false).getOrdersForCurrentDay();
           // for (var e in allOrders){
           //   print('all orders: $e');
             
           // }
            
           // print(allOrders.length);
          },
          child: const Text('Year',
           style: TextStyle(
            color: Color(0xff368983),
            ),
            ),
        ),
        ),
      ],
    ),
),
     // Add the DataTable widget with three columns: Total Price, Quantity, and Profit
    Consumer<DatabaseProvider>(
              builder: (context, databaseProvider, child) {
                String totalSalesText = Provider.of<DatabaseProvider>(context, listen: false).isMounthDataCalculated
    ? databaseProvider.totalMounthSales.toStringAsFixed(2)
    : Provider.of<DatabaseProvider>(context, listen: false).isDayDataCalculated
        ? databaseProvider.totalSales.toStringAsFixed(2)
        : Provider.of<DatabaseProvider>(context, listen: false).isWeekDataCalculated
            ? databaseProvider.totalWeekSales.toStringAsFixed(2)
            : '';

String totalQuantityText = Provider.of<DatabaseProvider>(context, listen: false).isMounthDataCalculated
    ? databaseProvider.totalMounthQuantity.toStringAsFixed(2)
    : Provider.of<DatabaseProvider>(context, listen: false).isDayDataCalculated
        ? databaseProvider.totalQuantity.toStringAsFixed(2)
        : Provider.of<DatabaseProvider>(context, listen: false).isWeekDataCalculated
            ? databaseProvider.totalWeekQuantity.toStringAsFixed(2)
            : '';

String totalProfitText = Provider.of<DatabaseProvider>(context, listen: false).isMounthDataCalculated
    ? databaseProvider.totalMounthProfit.toStringAsFixed(2)
    : Provider.of<DatabaseProvider>(context, listen: false).isDayDataCalculated
        ? databaseProvider.totalProfit.toStringAsFixed(2)
        : Provider.of<DatabaseProvider>(context, listen: false).isWeekDataCalculated
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
