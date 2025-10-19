import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'color_extension.dart';

class TransactionHelper {
  // Dapatkan ikon berdasarkan tipe transaksi
  static IconData getIconForType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Icons.arrow_upward_rounded; // Panah ke atas untuk income
      case TransactionType.expense:
        return Icons.shopping_bag_rounded; // Tas belanja untuk expense
      case TransactionType.bill:
        return Icons.receipt_long_rounded; // Receipt untuk bill
    }
  }

  // Dapatkan ikon berdasarkan kategori (lebih spesifik)
  static IconData getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      // Income categories
      case 'income':
      case 'salary':
      case 'gaji':
        return Icons.account_balance_wallet_rounded;
      
      // Expense categories
      case 'food':
      case 'makanan':
        return Icons.restaurant_rounded;
      case 'transport':
      case 'transportation':
      case 'transportasi':
        return Icons.directions_car_rounded;
      case 'shopping':
      case 'belanja':
        return Icons.shopping_bag_rounded;
      case 'entertainment':
      case 'hiburan':
        return Icons.movie_rounded;
      case 'health':
      case 'healthcare':
      case 'kesehatan':
        return Icons.local_hospital_rounded;
      case 'home':
      case 'rumah':
        return Icons.home_rounded;
      
      // Bill categories
      case 'electricity':
      case 'listrik':
        return Icons.bolt_rounded;
      case 'water':
      case 'air':
        return Icons.water_drop_rounded;
      case 'internet':
        return Icons.wifi_rounded;
      case 'phone':
      case 'telepon':
        return Icons.phone_android_rounded;
      case 'netflix':
      case 'spotify':
      case 'youtube':
        return Icons.subscriptions_rounded;
      
      default:
        return Icons.category_rounded;
    }
  }

  // Dapatkan warna berdasarkan tipe transaksi
  static Color getColorForType(TransactionType type, BuildContext context) {
    switch (type) {
      case TransactionType.income:
        return const Color(0xFF4CAF50); // Hijau untuk income
      case TransactionType.expense:
        return const Color(0xFFFF5252); // Merah untuk expense
      case TransactionType.bill:
        return const Color(0xFFFF6B35); // Orange-red untuk bill
    }
  }

  // Dapatkan warna background yang lebih soft
  static Color getBackgroundColorForType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return const Color(0xFF4CAF50).withOpacity(0.1);
      case TransactionType.expense:
        return const Color(0xFFFF5252).withOpacity(0.1);
      case TransactionType.bill:
        return const Color(0xFFFF6B35).withOpacity(0.1);
    }
  }

  // Dapatkan label untuk tipe transaksi
  static String getLabelForType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'Income';
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.bill:
        return 'Bill';
    }
  }

  // Format amount dengan tanda + atau -
  static String formatAmountWithSign(TransactionType type, double amount) {
    final sign = type == TransactionType.income ? '+' : '-';
    return '$sign ${amount.toStringAsFixed(0)}';
  }
}
