import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin.dart';
import '../storage/hive_manager.dart';
import '../utils/image_cache.dart';

class ApiService {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  // For PortfolioController.fetchCoinsList()
  static Future<List<Coin>> fetchCoinList() async {
    final url = Uri.parse('$baseUrl/coins/markets?vs_currency=usd');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Coin> coins = [];
      for (var item in data) {
        String id = item['id'];
        String logoUrl = await ImageCacheUtil.getLogo(id);
        coins.add(Coin.fromJson(item, logo: logoUrl));
      }
      await HiveManager.saveCoins(coins);
      return coins;
    } else {
      throw Exception('Failed to fetch coins');
    }
  }

  // For PortfolioController.fetchPricesForPortfolio()
  static Future<Map<String, double>> fetchPrices(List<String> coinIds) async {
    if (coinIds.isEmpty) return {};
    final ids = coinIds.join(',');
    final url = Uri.parse('$baseUrl/simple/price?ids=$ids&vs_currencies=usd');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final prices = <String, double>{};
      data.forEach((key, value) {
        prices[key] = (value['usd'] as num).toDouble();
      });
      return prices;
    } else {
      throw Exception('Failed to fetch prices');
    }
  }

  static Future<List<Coin>> fetchCoins() async {
    final url = Uri.parse('$baseUrl/coins/markets?vs_currency=usd');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      List<Coin> coins = [];
      for (var item in data) {
        String id = item['id'];
        String logoUrl = await ImageCacheUtil.getLogo(id);
        coins.add(Coin.fromJson(item, logo: logoUrl));
      }

      await HiveManager.saveCoins(coins);
      return coins;
    } else {
      throw Exception('Failed to fetch coins');
    }
  }
}
