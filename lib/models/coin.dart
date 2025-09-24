import 'package:hive/hive.dart';

part 'coin.g.dart';

@HiveType(typeId: 0)
class Coin extends HiveObject {
    @HiveField(0)
    final String id;

    @HiveField(1)
    final String name;

    @HiveField(2)
    final String symbol;

    @HiveField(3)
    final double price;

    @HiveField(4)
    final String logoUrl;

    Coin({
        required this.id,
        required this.name,
        required this.symbol,
        required this.price,
        required this.logoUrl,
    });

    factory Coin.fromJson(Map<String, dynamic> json, {String? logo}) {
        return Coin(
            id: json['id'],
            name: json['name'],
            symbol: json['symbol'],
            price: (json['current_price'] as num).toDouble(),
            logoUrl: logo ?? '',
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'name': name,
            'symbol': symbol,
            'price': price,
            'logoUrl': logoUrl,
        };
    }
}
