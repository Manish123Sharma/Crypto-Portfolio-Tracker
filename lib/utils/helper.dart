import 'package:intl/intl.dart';

class Helpers {
  /// Format a number as USD currency
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return formatter.format(amount);
  }

  /// Safely parse string to double
  static double parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }

  /// Capitalize first letter of a string
  static String capitalize(String str) {
    if (str.isEmpty) return '';
    return str[0].toUpperCase() + str.substring(1);
  }
}
