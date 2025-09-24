import 'package:get/get.dart';
import '../models/coin.dart';
import '../services/api_service.dart';

class CoinController extends GetxController {
  var coinsList = <Coin>[].obs; // Full list
  var coinMapByName = <String, Coin>{}.obs; // name -> coin
  var coinMapBySymbol = <String, Coin>{}.obs; // symbol -> coin
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchCoins();
    super.onInit();
  }

  Future<void> fetchCoins() async {
    try {
      isLoading.value = true;

      // Fetch coin data including images from CoinGecko markets endpoint
      final list = await ApiService.fetchCoinsWithImages();

      coinsList.value = list;

      // Build maps for fast search
      coinMapByName.clear();
      coinMapBySymbol.clear();
      for (var coin in list) {
        coinMapByName[coin.name.toLowerCase()] = coin;
        coinMapBySymbol[coin.symbol.toLowerCase()] = coin;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load coin list: $e');
    } finally {
      isLoading.value = false;
    }
  }

  double getPrice(String coinId) {
    try {
      return coinsList.firstWhere((c) => c.id == coinId).price;
    } catch (e) {
      return 0.0;
    }
  }

  // Fast search by name or symbol
  List<Coin> searchCoins(String query) {
    query = query.toLowerCase();
    final result = <Coin>{};

    coinMapByName.forEach((key, coin) {
      if (key.contains(query)) result.add(coin);
    });

    coinMapBySymbol.forEach((key, coin) {
      if (key.contains(query)) result.add(coin);
    });

    return result.toList();
  }
}
