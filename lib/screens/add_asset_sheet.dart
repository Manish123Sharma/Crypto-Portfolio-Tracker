// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/portfolio_controller.dart';
// import '../models/asset.dart';
// import '../models/coin.dart';

// class AddAssetSheet extends StatefulWidget {
//   @override
//   State<AddAssetSheet> createState() => _AddAssetSheetState();
// }

// class _AddAssetSheetState extends State<AddAssetSheet> {
//   final ctrl = Get.find<PortfolioController>();
//   final TextEditingController _searchController = TextEditingController();
//   final TextEditingController _qtyController = TextEditingController();
//   Coin? selectedCoin;
//   List<Coin> suggestions = [];

//   void onSearch(String q) {
//     final s = ctrl.searchCoins(q, limit: 40);
//     setState(() => suggestions = s);
//   }

//   void onSave() async {
//     final qty = double.tryParse(_qtyController.text);
//     if (selectedCoin == null) {
//       Get.snackbar('Validation', 'Please select a coin');
//       return;
//     }
//     if (qty == null || qty <= 0) {
//       Get.snackbar('Validation', 'Enter valid quantity');
//       return;
//     }

//     final asset = Asset(
//       coinId: selectedCoin!.id,
//       name: selectedCoin!.name,
//       symbol: selectedCoin!.symbol,
//       quantity: qty,
//     );

//     await ctrl.addOrUpdateAsset(asset);
//     Get.back(); // close sheet
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(labelText: 'Search coin by name or symbol'),
//               onChanged: onSearch,
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 160,
//               child: ListView(
//                 children: suggestions.map((c) => ListTile(
//                   title: Text('${c.name} (${c.symbol.toUpperCase()})'),
//                   onTap: () {
//                     setState(() {
//                       selectedCoin = c;
//                       _searchController.text = '${c.name} (${c.symbol.toUpperCase()})';
//                       suggestions = [];
//                     });
//                   },
//                 )).toList(),
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _qtyController,
//               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//               decoration: const InputDecoration(labelText: 'Quantity'),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(child: ElevatedButton(onPressed: onSave, child: const Text('Save'))),
//               ],
//             )
//           ]),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto_portfolio_tracker/controllers/portfolio_controller.dart';
import 'package:crypto_portfolio_tracker/models/coin.dart';

class AddAssetView extends StatefulWidget {
  const AddAssetView({super.key});

  @override
  State<AddAssetView> createState() => _AddAssetViewState();
}

class _AddAssetViewState extends State<AddAssetView> {
  final PortfolioController ctrl = Get.find<PortfolioController>();
  final TextEditingController searchCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController();

  Coin? selectedCoin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Asset"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Search Coin"),
            const SizedBox(height: 8),
            TextField(
              controller: searchCtrl,
              decoration: const InputDecoration(
                hintText: "Enter coin name or symbol",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {}); // re-render filtered list
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final query = searchCtrl.text.toLowerCase();
                final coins = ctrl.allCoins.where((c) {
                  return c.name.toLowerCase().contains(query) ||
                      c.symbol.toLowerCase().contains(query);
                }).take(20); // limit results
                return ListView(
                  children: coins
                      .map((c) => ListTile(
                            leading: c.logoUrl.isNotEmpty
                                ? Image.network(c.logoUrl, width: 32, height: 32)
                                : const Icon(Icons.monetization_on),
                            title: Text("${c.name} (${c.symbol.toUpperCase()})"),
                            onTap: () {
                              setState(() {
                                selectedCoin = c;
                                searchCtrl.text = c.name;
                              });
                            },
                          ))
                      .toList(),
                );
              }),
            ),
            const Divider(height: 32),
            const Text("Quantity"),
            const SizedBox(height: 8),
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: "Enter quantity owned",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCoin == null) {
                    Get.snackbar("Error", "Please select a coin.");
                    return;
                  }
                  final qty = double.tryParse(qtyCtrl.text) ?? 0;
                  if (qty <= 0) {
                    Get.snackbar("Error", "Enter a valid quantity.");
                    return;
                  }
                  if (ctrl.assets.any((a) => a.coinId == selectedCoin!.id)) {
                    Get.snackbar("Error", "Coin already exists in portfolio.");
                    return;
                  }

                  ctrl.addAsset(selectedCoin!, qty);
                  Get.back(); // close AddAssetView
                },
                child: const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
