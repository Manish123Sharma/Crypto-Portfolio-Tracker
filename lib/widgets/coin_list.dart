import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/coin.dart';
import '../services/api_service.dart';
import '../storage/hive_manager.dart';
import 'package:crypto_portfolio_tracker/screens/add_asset_sheet.dart';

class CoinList extends StatefulWidget {
  const CoinList({super.key});

  @override
  State<CoinList> createState() => _CoinListState();
}

class _CoinListState extends State<CoinList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<Coin> _coins = [];

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    try {
      List<Coin> coins = HiveManager.getCoins();
      if (coins.isNotEmpty) {
        setState(() => _coins = coins);
      }
      coins = await ApiService.fetchCoins();
      _animateReplaceList(coins);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _animateReplaceList(List<Coin> newCoins) {
    for (int i = _coins.length - 1; i >= 0; i--) {
      final removed = _coins.removeAt(i);
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => _buildTile(removed, animation),
        duration: const Duration(milliseconds: 300),
      );
    }

    Future.delayed(const Duration(milliseconds: 350), () {
      for (int i = 0; i < newCoins.length; i++) {
        _coins.insert(i, newCoins[i]);
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  Widget _buildTile(Coin coin, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        leading: coin.logoUrl.isNotEmpty
            ? Image.network(coin.logoUrl, width: 32, height: 32)
            : const Icon(Icons.monetization_on),
        title: Text(coin.name),
        subtitle: Text(coin.symbol.toUpperCase()),
        trailing: Text('\$${coin.price.toStringAsFixed(2)}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coin Tracker')),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _coins.length,
        itemBuilder: (context, index, animation) {
          return _buildTile(_coins[index], animation);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Get.to(() => const AddAssetView());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
