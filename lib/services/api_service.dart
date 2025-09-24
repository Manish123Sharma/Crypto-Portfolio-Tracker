import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin.dart';

class ApiService {
  static const baseUrl = 'https://api.coingecko.com/api/v3';

  static Future<List<Coin>> fetchCoinsList() async {
    final response = await http.get(Uri.parse('$baseUrl/coins/list'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(data);
      return data.map((e) => Coin.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load coins');
    }
  }

  static Future<List<Coin>> fetchCoinsWithImages() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Coin.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch coins with images');
    }
  }

  /// Fetch current prices for selected coins
  static Future<Map<String, double>> fetchPrices(List<String> coinIds) async {
    if (coinIds.isEmpty) return {};

    final ids = coinIds.join(',');
    final response = await http.get(Uri.parse(
        '$baseUrl/simple/price?ids=$ids&vs_currencies=usd'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, double> prices = {};
      data.forEach((key, value) {
        prices[key] = (value['usd'] as num).toDouble();
      });
      return prices;
    } else {
      throw Exception('Failed to fetch prices');
    }
  }


}
