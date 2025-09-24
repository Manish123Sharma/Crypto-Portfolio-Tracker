import 'coin.dart';

class Asset {
    final Coin coin;
    double quantity;

    Asset({required this.coin, required this.quantity});

    factory Asset.fromJson(Map<String, dynamic> json) {
        return Asset(
            coin: Coin.fromJson(json['coin']),
            quantity: json['quantity'],
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'coin': coin.toJson(),
            'quantity': quantity,
        };
    }
}
