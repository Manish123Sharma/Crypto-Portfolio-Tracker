# 📊 Crypto Portfolio Tracker

A Flutter application to track your cryptocurrency portfolio.  
Built using **GetX** (state management, dependency injection, routing) and **SharedPreferences** for local storage.
---

## 🚀 Features

- 📌 **Add / Remove Assets** to your portfolio
- 💰 **Real-time Price Updates** using [CoinGecko API](https://www.coingecko.com/en/api)
- 📈 **Auto-calculated Portfolio Value**
- 🔄 **Swipe-to-Delete** single assets
- ✅ **Multi-select Delete** (via long press + checkboxes)
- 🎨 **Custom Splash Screen** with smooth zoom animation
- ⚡ **GetX Architecture (MVC)** for clean and scalable code
- 🗄 **Local persistence** with SharedPreferences (stores portfolio as JSON)

---

## 🛠️ Tech Stack

- **Flutter** (UI)
- **GetX** (state management, DI, routing)
- **Dart**
- **SharedPreferences** (local storage)
- **HTTP** (API calls)
- **CoinGecko API** (crypto data)
---

## 📂 Project Structure

    lib/
    │
    ├── bindings/
    │ └── portfolio_binding.dart
    │
    ├── controllers/
    │ ├── coin_controller.dart
    │ └── portfolio_controller.dart
    │
    ├── models/
    │ ├── coin.dart
    │ └── portfolio_asset.dart
    │
    ├── screens/
    │ ├── splash_view.dart
    │ ├── portfolio_view.dart
    │ └── add_asset_view.dart
    │
    ├── services/
    │ └── storage_service.dart
    │
    └── utils/
    └── helper.dart

---

## 📦 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/crypto_portfolio_tracker.git
   cd crypto_portfolio_tracker

2. **Install dependencies**

      ```bash
     flutter pub get

4. **Generate Hive adapters**

      ```bash
     flutter packages pub run build_runner build

6. **Run the app**

      ```bash
     flutter run

**🔑** **API Information**

This project uses CoinGecko API.

  https://api.coingecko.com/api/v3/coins/list

1. Fetch coins list:

    https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd

2. Fetch coin details/logo:

    https://api.coingecko.com/api/v3/coins/{id}
3. Fetch Prices:

  https://api.coingecko.com/api/v3/simple/price?ids={coinIds}&vs_currencies=usd

**🧩** **Future Improvements**

    🔔 Price Alerts & Notifications
    
    📊 Charts for Portfolio History
    
    🌙 Dark Mode
    
    ☁️ Cloud Sync (Firebase / Supabase)

**👨‍💻** **Author**

Manish Kumar Sharma

[📧 Email](mailto:your-mksharma256001@gmail.com) | [💼 LinkedIn](https://www.linkedin.com/in/mks001/) | [🌐 GitHub](https://github.com/Manish123Sharma)


## 🧑‍💻 Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

##  📜 License


---

✅ This README includes:
- Features  
- Tech stack  
- Screenshots section (you can replace with your actual images later)  
- Setup steps  
- API reference  
- Future improvements  

Do you want me to also add **demo GIFs** (like splash animation and adding assets) in the README so it looks more impressive?

