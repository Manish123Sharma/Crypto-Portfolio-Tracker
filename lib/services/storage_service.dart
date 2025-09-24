import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asset.dart';

class StorageService {
  static const String portfolioKey = 'portfolio_assets';

  static Future<void> savePortfolio(List<Asset> assets) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = assets.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(portfolioKey, jsonList);
  }

  static Future<List<Asset>> loadPortfolio() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(portfolioKey) ?? [];
    return jsonList.map((e) => Asset.fromJson(jsonDecode(e))).toList();
  }
}
