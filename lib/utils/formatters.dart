import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 2);

String formatCurrency(double value) {
  return _currencyFormatter.format(value);
}
