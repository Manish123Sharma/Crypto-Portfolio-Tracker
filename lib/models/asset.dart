class Asset {
    final String coinId;
    final String name;
    final String symbol;
    double quantity;

    Asset({
        required this.coinId,
        required this.name,
        required this.symbol,
        required this.quantity,
    });

    factory Asset.fromJson(Map<String, dynamic> j) => Asset(
        coinId: j['coinId'],
        name: j['name'],
        symbol: j['symbol'],
        quantity: (j['quantity'] as num).toDouble(),
    );

    Map<String, dynamic> toJson() => {
        'coinId': coinId,
        'name': name,
        'symbol': symbol,
        'quantity': quantity,
    };
}
