# 📊 Crypto Portfolio Tracker

A Flutter application that allows users to track their cryptocurrency portfolio in real-time.  
Users can add cryptocurrencies they own, specify the quantity, and view the current market price, total value, and profit/loss.  
The app uses **Hive** for local storage and the **CoinGecko API** for live data.

---

## 🚀 Features

- Add / Remove cryptocurrencies from your portfolio.
- Store holdings persistently with **Hive**.
- Fetch real-time prices using **CoinGecko API**.
- View:
  - Current market price
  - Quantity owned
  - Total value
  - Profit / Loss
- Smooth UI with **AnimatedList** for insert/delete.
- Crypto logos loaded and cached from CoinGecko.
- Responsive design (works on both Android & iOS).

---

## 🛠️ Tech Stack

- **Flutter** (Dart)
- **Hive** (Local NoSQL storage)
- **HTTP** (API requests)
- **CoinGecko API** (Live market data)

---

## 📦 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/crypto_portfolio_tracker.git
   cd crypto_portfolio_tracker

2. **Install dependencies**
    flutter pub get

3. **Generate Hive adapters**
    flutter packages pub run build_runner build

4. **Run the app**
    flutter run

**🔑** **API Information**

This project uses CoinGecko API.
https://api.coingecko.com/api/v3/coins/list

1. Fetch coins list:
    https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd

2. Fetch coin details/logo:
    https://api.coingecko.com/api/v3/coins/{id}

**🗄️** **Hive Storage**

We use Hive for local persistence.
Example adapter for storing portfolio coins:

@HiveType(typeId: 0)
class PortfolioCoin extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String symbol;

  @HiveField(2)
  String name;

  @HiveField(3)
  double quantity;

  @HiveField(4)
  double priceUsd;

  @HiveField(5)
  String imageUrl;

  PortfolioCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.priceUsd,
    required this.imageUrl,
  });
}


