import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_GH',
      symbol: 'GH₵',
      decimalDigits: 2,
    );

    return formatter.format(amount);
  }
}
