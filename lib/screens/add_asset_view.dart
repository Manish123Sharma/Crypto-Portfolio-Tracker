import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coin_controller.dart';
import '../controllers/portfolio_controller.dart';
import '../models/asset.dart';
import '../models/coin.dart';
import '../utils/helper.dart';

class AddAssetView extends StatefulWidget {
  const AddAssetView({super.key});

  @override
  _AddAssetViewState createState() => _AddAssetViewState();
}

class _AddAssetViewState extends State<AddAssetView> {
  final CoinController coinController = Get.find<CoinController>();
  final PortfolioController portfolioController = Get.find<PortfolioController>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  RxList<Coin> searchResults = <Coin>[].obs;
  Coin? selectedCoin;

  @override
  void initState() {
    super.initState();

    // Show full list initially
    ever(coinController.coinsList, (_) {
      searchResults.value = coinController.coinsList.toList();
    });

    searchController.addListener(() {
      final query = searchController.text.trim().toLowerCase();

      if (query.isEmpty) {
        searchResults.value = coinController.coinsList.toList();
        selectedCoin = null;
        return;
      }

      final results = <Coin>{};

      coinController.coinMapByName.forEach((key, coin) {
        if (key.contains(query)) results.add(coin);
      });
      coinController.coinMapBySymbol.forEach((key, coin) {
        if (key.contains(query)) results.add(coin);
      });

      searchResults.value = results.toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Asset')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search field
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Coin by Name or Symbol',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 8),

            // Search results with image, name, price
            Obx(
                  () => Expanded(
                child: searchResults.isEmpty
                    ? const Center(child: Text('No coins found'))
                    : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final coin = searchResults[index];
                    final price = coinController.getPrice(coin.id);

                    return ListTile(
                      leading: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.network(
                          coin.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.monetization_on),
                        ),
                      ),
                      title: Text('${Helpers.capitalize(coin.name)}'),
                      subtitle: Text('Price: ${Helpers.formatCurrency(
                          portfolioController.prices[coin.id] ?? 0.0)}'),
                      onTap: () {
                        selectedCoin = coin;
                        searchController.text = coin.name;
                        searchResults.value=[coin];
                      },
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quantity Input
            TextField(
              controller: quantityController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Quantity',
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 16),

            // Add Asset Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCoin == null ||
                      quantityController.text.trim().isEmpty) {
                    Get.snackbar('Error', 'Select a coin and enter quantity');
                    return;
                  }

                  final quantity =
                  Helpers.parseDouble(quantityController.text.trim());

                  if (quantity <= 0) {
                    Get.snackbar('Error', 'Enter a valid quantity');
                    return;
                  }

                  portfolioController.addAsset(
                      Asset(coin: selectedCoin!, quantity: quantity));

                  Get.back();
                },
                child: const Text('Add Asset'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
