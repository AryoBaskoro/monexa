import 'package:intl/intl.dart';

class CurrencyHelper {
  // Format amount as Rupiah (IDR)
  static String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // CRITICAL FIX: Format dengan thousands separator Indonesian (100.000)
  // TANPA simbol Rp, TANPA K/M abbreviation
  // Gunakan locale id_ID untuk separator dengan titik (.)
  static String formatNumber(double amount) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    return formatter.format(amount.round());
  }

  // CRITICAL FIX: Format untuk Expense/Bill dengan tanda minus (-)
  // Format: "- 250.000" dengan space setelah minus
  static String formatExpense(double amount) {
    final formatted = formatNumber(amount);
    return '- $formatted';
  }

  // Format untuk Income (tanpa tanda, positif)
  static String formatIncome(double amount) {
    return formatNumber(amount);
  }

  // Format for display (returns empty string if amount is 0 or null for "no transactions" case)
  // Use this when you want to hide zero values for empty states
  static String formatRupiahOrEmpty(double? amount, {bool showZero = false}) {
    if (amount == null || (amount == 0 && !showZero)) {
      return '';
    }
    return formatRupiah(amount);
  }

  // Parse formatted rupiah string back to double
  static double parseRupiah(String formattedAmount) {
    // Remove "Rp", spaces, and dots
    String cleaned = formattedAmount
        .replaceAll('Rp', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0;
  }
}
