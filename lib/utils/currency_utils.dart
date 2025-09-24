import 'package:intl/intl.dart';

String formatCurrency(double value) {
  final f = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  return f.format(value);
}
