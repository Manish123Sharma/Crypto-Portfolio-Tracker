import 'dart:convert';
import 'package:get/get.dart';
import '../models/asset.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../utils/helper.dart';

class PortfolioController extends GetxController {
  var portfolio = <Asset>[].obs;
  var prices = <String, double>{}.obs;
  var totalValue = 0.0.obs;
  var totalValueFormatted = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    loadPortfolio();
    super.onInit();
  }

  Future<void> loadPortfolio() async {
    isLoading.value = true;

    final saved = await StorageService.loadPortfolio();
    portfolio.value = saved;

    if (portfolio.isNotEmpty) {
      await fetchPrices();
    } else {
      totalValue.value = 0.0;
      totalValueFormatted.value = Helpers.formatCurrency(0.0);
    }

    isLoading.value = false;
  }

  Future<void> fetchPrices() async {
    if (portfolio.isEmpty) return;

    try {
      isLoading.value = true;

      final ids = portfolio.map((e) => e.coin.id).toList();
      final data = await ApiService.fetchPrices(ids);

      prices.clear();
      prices.addAll(data);
      data.forEach((key, value) {
        prices[key] = value;
      });

      calculateTotalValue();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch prices: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void calculateTotalValue() {
    double total = 0.0;

    for (var asset in portfolio) {
      final price = prices[asset.coin.id] ?? 0.0;
      total += asset.quantity * price;
    }

    totalValue.value = total;
    totalValueFormatted.value = Helpers.formatCurrency(total);
  }

  Future<void> addAsset(Asset asset) async {
    final existing =
    portfolio.firstWhereOrNull((a) => a.coin.id == asset.coin.id);

    if (existing != null) {
      existing.quantity += asset.quantity;
    } else {
      portfolio.add(asset);
    }

    await StorageService.savePortfolio(portfolio);
    await fetchPrices(); // instantly fetch prices after adding
  }

  Future<void> removeAsset(Asset asset) async {
    portfolio.remove(asset);
    await StorageService.savePortfolio(portfolio);
    await fetchPrices(); // instantly update prices and total
  }
}
