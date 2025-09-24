class Coin {
    final String id;
    final String symbol;
    final String name;
    final String image;
    final double price;

    Coin({
        required this.id,
        required this.symbol,
        required this.name,
        required this.image,
        required this.price
    });

    factory Coin.fromJson(Map<String, dynamic> json) {
        return Coin(
            id: json['id'],
            price: (json['current_price'] ?? 0).toDouble(),
            symbol: json['symbol'],
            name: json['name'],
            image: json['image'] ?? '', // fallback empty string
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'symbol': symbol,
            'name': name,
            'image': image,
            'price': price,
        };
    }
}
