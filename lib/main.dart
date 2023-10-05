import 'package:fiboutiquesv1/Database/order_details.dart';
import 'package:fiboutiquesv1/Database/product.dart';
import 'package:fiboutiquesv1/Providers/database_provider.dart';
import 'package:fiboutiquesv1/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'Providers/audio_rec_play_provider.dart';
late Box products ;
late Box orders ;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(OrderDetailsAdapter());
  products = await Hive.openBox<Product>("products");
  orders = await Hive.openBox<Product>("orders");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return ScreenUtilInit(
      designSize: const Size(393, 759),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AudioProvider()),
          ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Bottom(),
        ),
      ),
    );
  }
}
