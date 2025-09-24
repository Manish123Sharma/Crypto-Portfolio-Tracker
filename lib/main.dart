import 'package:crypto_portfolio_tracker/bindings/portfolio_binding.dart';
import 'package:crypto_portfolio_tracker/screens/portfolio_view.dart';
import 'package:crypto_portfolio_tracker/screens/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Portfolio Tracker',
      initialBinding: PortfolioBinding(),
      home: SplashView(),
    );
  }
}
