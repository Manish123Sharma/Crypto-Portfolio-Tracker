import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/coin.dart';
import 'storage/hive_manager.dart';
import 'utils/image_cache.dart';
import 'widgets/coin_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CoinAdapter());

  // Open storage boxes
  await HiveManager.init();
  await ImageCacheUtil.init();

  runApp(const CoinTrackerApp());
}

class CoinTrackerApp extends StatelessWidget {
  const CoinTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin Tracker',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   useMaterial3: true,
      // ),
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CoinList(),
    );
  }
}
