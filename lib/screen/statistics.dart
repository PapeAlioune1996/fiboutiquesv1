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
      body: Padding(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sales',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              
                Icon(
                  Icons.swap_vert,
                  size: 25.sp,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// CustomScrollView custom() {
//   return CustomScrollView(
//     slivers: [
//       SliverToBoxAdapter(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               'Statistics',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ...List.generate(
//                     4,
//                     (index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             index_color = index;
//                             kj.value = index;
//                           });
//                         },
//                         child: Container(
//                           height: 40,
//                           width: 80,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: index_color == index
//                                 ? const Color.fromARGB(255, 47, 125, 121)
//                                 : Colors.white,
//                           ),
//                           alignment: Alignment.center,
//                           child: Text(
//                             day[index],
//                             style: TextStyle(
//                               color: index_color == index
//                                   ? Colors.white
//                                   : Colors.black,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             const SizedBox(height: 20),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Sales',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Icon(
//                     Icons.swap_vert,
//                     size: 25,
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       /*SliverList(
//           delegate: SliverChildBuilderDelegate(
//         (context, index) {
//           return ListTile(
//             leading: ClipRRect(
//               borderRadius: BorderRadius.circular(5),
//              ),
//
//           );
//         },
//        // childCount: a.length,
//       ),
//       )*/
//     ],
//   );
// }
}
