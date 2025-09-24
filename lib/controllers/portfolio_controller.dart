// import 'dart:async';
// import 'package:get/get.dart';
// import '../models/asset.dart';
// import '../models/coin.dart';
// import '../services//api_service.dart';
// import '../services/storage_service.dart';
// import 'package:flutter/foundation.dart';

// class PortfolioController extends GetxController {
//   // Observables
//   final RxList<Asset> assets = <Asset>[].obs;
//   final RxMap<String, double> prices = <String, double>{}.obs;
//   final RxBool isLoading = false.obs;
//   final RxBool coinsLoading = false.obs;
//   final RxList<Coin> coins = <Coin>[].obs;

//   Timer? _autoRefreshTimer;

//   @override
//   void onInit() {
//     super.onInit();
//     // load portfolio from storage
//     assets.assignAll(StorageService.loadPortfolio());
//     // load cached coins list if any
//     final cached = StorageService.loadCoins();
//     if (cached.isNotEmpty) {
//       coins.assignAll(cached);
//     } else {
//       // fetch once
//       fetchCoinsList();
//     }
//     // fetch prices for current portfolio
//     fetchPricesForPortfolio();
//     // optional auto refresh every X minutes (configure carefully)
//     // _startAutoRefresh(); // enable if desired
//   }

//   @override
//   void onClose() {
//     _autoRefreshTimer?.cancel();
//     super.onClose();
//   }

//   Future<void> fetchCoinsList() async {
//     coinsLoading.value = true;
//     try {
//       final list = await ApiService.fetchCoinList();
//       coins.assignAll(list);
//       await StorageService.saveCoins(list); // cache
//     } catch (e) {
//       // handle error (user may be offline)
//       debugPrint('Error fetching coins: $e');
//     } finally {
//       coinsLoading.value = false;
//     }
//   }

//   Future<void> fetchPricesForPortfolio() async {
//     isLoading.value = true;
//     try {
//       final ids = assets.map((a) => a.coinId).toSet().toList();
//       final Map<String, double> fresh = await ApiService.fetchPrices(ids);
//       prices.assignAll(fresh);
//     } catch (e) {
//       debugPrint('Price fetch error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   double get totalPortfolioValue {
//     double sum = 0.0;
//     for (final a in assets) {
//       final p = prices[a.coinId] ?? 0.0;
//       sum += a.quantity * p;
//     }
//     return sum;
//   }

//   // Add or update asset
//   Future<void> addOrUpdateAsset(Asset asset) async {
//     final idx = assets.indexWhere((a) => a.coinId == asset.coinId);
//     if (idx >= 0) {
//       assets[idx].quantity += asset.quantity;
//       assets[idx] = assets[idx]; // trigger update
//     } else {
//       assets.add(asset);
//     }
//     await StorageService.savePortfolio(assets.toList());
//     await fetchPricesForPortfolio();
//   }

//   Future<void> removeAsset(String coinId) async {
//     assets.removeWhere((a) => a.coinId == coinId);
//     await StorageService.savePortfolio(assets.toList());
//     prices.remove(coinId);
//   }

//   // Search helper (fast-ish). We'll do a case-insensitive prefix search on name and symbol.
//   List<Coin> searchCoins(String query, {int limit = 20}) {
//     if (query.isEmpty) return [];
//     final q = query.toLowerCase();
//     final results = <Coin>[];
//     for (final c in coins) {
//       if (c.name.toLowerCase().startsWith(q) ||
//           c.symbol.toLowerCase().startsWith(q)) {
//         results.add(c);
//         if (results.length >= limit) break;
//       }
//     }
//     return results;
//   }

//   void _startAutoRefresh({int minutes = 5}) {
//     _autoRefreshTimer?.cancel();
//     _autoRefreshTimer = Timer.periodic(Duration(minutes: minutes), (_) {
//       fetchPricesForPortfolio();
//     });
//   }
// }


import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/coin.dart';
import '../models/portfolio_asset.dart';

class PortfolioController extends GetxController {
  final assets = <PortfolioAsset>[].obs;
  final prices = <String, double>{}.obs;

  final allCoins = <Coin>[].obs; // ✅ used in AddAssetView
  final isLoading = false.obs;
  final coinsLoading = false.obs;

  late Box<PortfolioAsset> assetBox;
  late Box<Coin> coinBox;

  @override
  void onInit() {
    super.onInit();
    _initHive();
  }

  Future<void> _initHive() async {
    assetBox = await Hive.openBox<PortfolioAsset>('assetsBox');
    coinBox = await Hive.openBox<Coin>('coinsBox');

    assets.assignAll(assetBox.values.toList());
    allCoins.assignAll(coinBox.values.toList());

    if (allCoins.isEmpty) {
      fetchAllCoins();
    }
  }

  Future<void> fetchAllCoins() async {
    try {
      coinsLoading.value = true;
      final res = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false'));
      final data = jsonDecode(res.body) as List;
      final coins = data.map((e) => Coin.fromJson(e, logo: e['image'])).toList();

      allCoins.assignAll(coins);

      await coinBox.clear();
      await coinBox.addAll(coins);
    } finally {
      coinsLoading.value = false;
    }
  }

  Future<void> fetchPricesForPortfolio() async {
    if (assets.isEmpty) return;
    try {
      isLoading.value = true;
      final ids = assets.map((a) => a.coinId).join(',');
      final res = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=$ids&vs_currencies=usd'));
      final data = jsonDecode(res.body) as Map<String, dynamic>;

      data.forEach((id, val) {
        prices[id] = (val['usd'] as num).toDouble();
      });
    } finally {
      isLoading.value = false;
    }
  }

  void addAsset(Coin coin, double qty) {
    final asset = PortfolioAsset(
      coinId: coin.id,
      name: coin.name,
      symbol: coin.symbol,
      logoUrl: coin.logoUrl,
      quantity: qty,
    );
    assets.add(asset);
    assetBox.add(asset);
  }

  void removeAsset(String coinId) {
    final asset = assets.firstWhereOrNull((a) => a.coinId == coinId);
    if (asset != null) {
      assets.remove(asset);
      assetBox.delete(asset.key);
    }
  }
}
