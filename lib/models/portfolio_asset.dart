import 'package:hive/hive.dart';

part 'portfolio_asset.g.dart';

@HiveType(typeId: 1)
class PortfolioAsset extends HiveObject {
  @HiveField(0)
  final String coinId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String symbol;

  @HiveField(3)
  final String logoUrl;

  @HiveField(4)
  final double quantity;

  PortfolioAsset({
    required this.coinId,
    required this.name,
    required this.symbol,
    required this.logoUrl,
    required this.quantity,
  });
}
