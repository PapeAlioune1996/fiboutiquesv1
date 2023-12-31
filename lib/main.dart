
import 'package:fiboutiquesv1/Database/order_details.dart';
import 'package:fiboutiquesv1/Database/product.dart';
import 'package:fiboutiquesv1/Database/user.dart';
import 'package:fiboutiquesv1/Database/user.g.dart';
import 'package:fiboutiquesv1/Providers/database_provider.dart';
import 'package:fiboutiquesv1/Providers/totalprice.dart';
import 'package:fiboutiquesv1/screen/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'Providers/audio_rec_play_provider.dart';
late Box products ;
late Box orders ;
late Box users;
void main() async {
 // final dir = await path.getApplicationDocumentDirectory();
// var path = Directory.current.path;
 //Hive.init(path);
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(OrderDetailsAdapter());
  Hive.registerAdapter(UserAdapter());
  products = await Hive.openBox<Product>("products");
  orders = await Hive.openBox<Product>("orders");
users = await Hive.openBox<User>("user");



//
await Firebase.initializeApp();
  //orders.close();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ChangeNotifierProvider(create: (context) => TotalPriceProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
