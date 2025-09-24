import 'package:crypto_portfolio_tracker/screens/add_asset_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto_portfolio_tracker/controllers/portfolio_controller.dart';
import 'package:crypto_portfolio_tracker/utils/formatters.dart';

class PortfolioView extends StatefulWidget {
  const PortfolioView({super.key});

  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView> {
  final PortfolioController ctrl = Get.find<PortfolioController>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late int _oldLength;

  @override
  void initState() {
    super.initState();
    _oldLength = ctrl.assets.length;

    ever<List>(ctrl.assets, (newAssets) {
      final newLength = newAssets.length;

      if (newLength > _oldLength) {
        _listKey.currentState?.insertItem(newLength - 1);
      } else if (newLength < _oldLength) {
        _listKey.currentState?.removeItem(
          _oldLength - 1,
          (context, animation) =>
              _buildItem(ctrl.assets[_oldLength - 1], animation),
        );
      }

      _oldLength = newLength; // update tracker
    });
  }

  Widget _buildItem(dynamic a, Animation<double> animation) {
    final price = ctrl.prices[a.coinId] ?? 0.0;
    final total = a.quantity * price;

    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: a.logoUrl.isNotEmpty
              ? Image.network(a.logoUrl, width: 32, height: 32)
              : const Icon(Icons.monetization_on),
          title: Text('${a.name} (${a.symbol.toUpperCase()})'),
          subtitle: Text('Qty: ${a.quantity}'),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatCurrency(price),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(formatCurrency(total)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ctrl.fetchPricesForPortfolio(),
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value || ctrl.coinsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.assets.isEmpty) {
          return const Center(child: Text('No assets yet. Tap + to add.'));
        }

        return AnimatedList(
          key: _listKey,
          initialItemCount: ctrl.assets.length,
          itemBuilder: (context, index, animation) {
            final a = ctrl.assets[index];
            return _buildItem(a, animation);
          },
        );
      }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      //   onPressed: () {
      //     Get.to(() => const AddAssetView());
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
