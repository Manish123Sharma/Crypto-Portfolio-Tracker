import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/portfolio_controller.dart';
import '../utils/helper.dart';
import 'add_asset_view.dart';

class PortfolioView extends StatefulWidget {
  const PortfolioView({super.key});

  @override
  _PortfolioViewState createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView> {
  final PortfolioController pc = Get.find();

  Set<String> selectedAssets = {}; // store selected coin IDs

  bool get isSelectionMode => selectedAssets.isNotEmpty;

  void toggleSelection(String coinId) {
    setState(() {
      if (selectedAssets.contains(coinId)) {
        selectedAssets.remove(coinId);
      } else {
        selectedAssets.add(coinId);
      }
    });
  }

  void deleteSelected() async {
    for (var id in selectedAssets) {
      final asset = pc.portfolio.firstWhere((a) => a.coin.id == id);
      await pc.removeAsset(asset);
    }
    setState(() {
      selectedAssets.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSelectionMode
            ? Text('${selectedAssets.length} selected')
            : const Text('My Portfolio'),
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: deleteSelected,
            ),
        ],
      ),
      body: Obx(() {
        if (pc.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => pc.fetchPrices(),
          child: ListView.builder(
            itemCount: pc.portfolio.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  title: Text(
                    'Total: ${pc.totalValueFormatted.value}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              final asset = pc.portfolio[index - 1];
              final price = pc.prices[asset.coin.id] ?? 0.0;
              final isSelected = selectedAssets.contains(asset.coin.id);

              return GestureDetector(
                onLongPress: () => toggleSelection(asset.coin.id),
                onTap: () {
                  if (isSelectionMode) toggleSelection(asset.coin.id);
                },
                child: Dismissible(
                  key: ValueKey(asset.coin.id),
                  onDismissed: (_) => pc.removeAsset(asset),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    color: isSelected ? Colors.blue.shade100 : null,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: isSelectionMode
                          ? Checkbox(
                        value: isSelected,
                        onChanged: (_) => toggleSelection(asset.coin.id),
                      )
                          : null,
                      title: Text(
                        '${Helpers.capitalize(asset.coin.name)} (${asset.coin.symbol.toUpperCase()})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Quantity: ${asset.quantity}\nPrice: ${Helpers.formatCurrency(price)}',
                      ),
                      trailing: Text(
                        'Value: ${Helpers.formatCurrency(asset.quantity * price)}',
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => const AddAssetView()),
      ),
    );
  }
}
