import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asset.dart';
import '../models/coin.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static const _portfolioKey = 'portfolio_assets';
  static const _coinsKey = 'coins_list_v1';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Portfolio (list of Asset) persistence
  static List<Asset> loadPortfolio() {
    final raw = _prefs.getString(_portfolioKey);
    if (raw == null) return [];
    final List parsed = jsonDecode(raw);
    return parsed.map((e) => Asset.fromJson(e)).toList();
  }

  static Future<void> savePortfolio(List<Asset> assets) async {
    final raw = jsonEncode(assets.map((a) => a.toJson()).toList());
    await _prefs.setString(_portfolioKey, raw);
  }

  // Coins list cache (store minimal fields)
  static Future<void> saveCoins(List<Coin> coins) async {
    final raw = jsonEncode(coins.map((c) => c.toJson()).toList());
    await _prefs.setString(_coinsKey, raw);
  }

  static List<Coin> loadCoins() {
    final raw = _prefs.getString(_coinsKey);
    if (raw == null) return [];
    final List parsed = jsonDecode(raw);
    return parsed.map((e) => Coin.fromJson(e)).toList();
  }
}
