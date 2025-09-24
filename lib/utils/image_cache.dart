import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ImageCacheUtil {
  static late Box<String> logoBox;

  static Future<void> init() async {
    logoBox = await Hive.openBox<String>('logos');
  }

  static Future<String> getLogo(String coinId) async {
    if (logoBox.containsKey(coinId)) {
      return logoBox.get(coinId)!;
    }

    final url = Uri.parse('https://api.coingecko.com/api/v3/coins/$coinId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final logoUrl = data['image']['thumb'];
      await logoBox.put(coinId, logoUrl);
      return logoUrl;
    }

    return '';
  }
}
