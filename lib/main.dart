import 'package:flutter/material.dart';
import 'package:flutter_application_2/admin/admindashboard.dart';
import 'package:flutter_application_2/controllers/sessioncontroller.dart';
import 'package:flutter_application_2/controllers/subscriptioncontroller.dart';
import 'package:flutter_application_2/homepage.dart';
import 'package:flutter_application_2/provider/sessionprovider.dart';
import 'package:flutter_application_2/provider/subscription%20provider.dart';
import 'package:flutter_application_2/routes.dart';
import 'package:flutter_application_2/routes/home.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
   Get.put(Sessioncontroller());
    Get.put(Subscriptioncontroller());
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SessionProvider(),child: const AdminDashboard(),),
        ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
      ],
      child: MyApp(token: token),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getHomeScreen(),
      routes: {
        '/routes': (context) =>  Routes(token:token,),
      },
    );
  }

  Widget _getHomeScreen() {
    if (token != null && JwtDecoder.isExpired(token!) == false) {
      return Home(token: token!);
    }
    return const Homepage();
  }
}
  



