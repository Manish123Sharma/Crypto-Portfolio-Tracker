import 'package:hive/hive.dart';
import '../models/coin.dart';

class HiveManager {
  static late Box<Coin> coinBox;

  static Future<void> init() async {
    coinBox = await Hive.openBox<Coin>('coins');
  }

  static List<Coin> getCoins() => coinBox.values.toList();

  static Future<void> saveCoins(List<Coin> coins) async {
    await coinBox.clear();
    await coinBox.addAll(coins);
  }
}
