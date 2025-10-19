import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

// CRITICAL FIX: Extend ChangeNotifier untuk real-time updates
class TransactionService extends ChangeNotifier {
  static const String _transactionsKey = 'transactions';
  
  // Singleton pattern
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  // Cache for transactions
  List<Transaction>? _cachedTransactions;

  // Get all transactions
  Future<List<Transaction>> getAllTransactions() async {
    if (_cachedTransactions != null) {
      return List.from(_cachedTransactions!);
    }

    final prefs = await SharedPreferences.getInstance();
    final String? transactionsJson = prefs.getString(_transactionsKey);
    
    if (transactionsJson == null || transactionsJson.isEmpty) {
      _cachedTransactions = [];
      return [];
    }

    try {
      final List<dynamic> decoded = json.decode(transactionsJson);
      _cachedTransactions = decoded
          .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
          .toList();
      return List.from(_cachedTransactions!);
    } catch (e) {
      print('Error loading transactions: $e');
      _cachedTransactions = [];
      return [];
    }
  }

  // Save all transactions
  Future<bool> _saveTransactions(List<Transaction> transactions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(
        transactions.map((t) => t.toJson()).toList(),
      );
      await prefs.setString(_transactionsKey, encoded);
      _cachedTransactions = List.from(transactions);
      return true;
    } catch (e) {
      print('Error saving transactions: $e');
      return false;
    }
  }

  // CRITICAL FIX: Add transaction dan trigger notifyListeners
  Future<bool> addTransaction(Transaction transaction) async {
    final transactions = await getAllTransactions();
    transactions.add(transaction);
    final success = await _saveTransactions(transactions);
    
    if (success) {
      // NOTIFY ALL LISTENERS untuk instant update!
      notifyListeners();
    }
    
    return success;
  }

  // CRITICAL FIX: Update transaction dan trigger notifyListeners
  Future<bool> updateTransaction(Transaction transaction) async {
    final transactions = await getAllTransactions();
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    
    if (index == -1) return false;
    
    transactions[index] = transaction;
    final success = await _saveTransactions(transactions);
    
    if (success) {
      notifyListeners();
    }
    
    return success;
  }

  // CRITICAL FIX: Delete transaction dan trigger notifyListeners
  Future<bool> deleteTransaction(String id) async {
    final transactions = await getAllTransactions();
    transactions.removeWhere((t) => t.id == id);
    final success = await _saveTransactions(transactions);
    
    if (success) {
      notifyListeners();
    }
    
    return success;
  }

  // Get transactions by type
  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    final transactions = await getAllTransactions();
    return transactions.where((t) => t.type == type).toList();
  }

  // Get transactions by date range
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final transactions = await getAllTransactions();
    return transactions.where((t) {
      return t.date.isAfter(start.subtract(const Duration(days: 1))) &&
             t.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Get transactions for current month
  Future<List<Transaction>> getCurrentMonthTransactions() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return await getTransactionsByDateRange(start, end);
  }

  // CRITICAL FIX: Calculate total balance (income - paid expenses/bills)
  // Only deduct expenses/bills that are paid OR dated today or earlier
  Future<double> calculateTotalBalance() async {
    final transactions = await getAllTransactions();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    double balance = 0;

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        balance += transaction.amount;
      } else {
        // Only deduct if: (1) Already paid, OR (2) Date is today or earlier
        final transactionDate = DateTime(
          transaction.date.year,
          transaction.date.month,
          transaction.date.day,
        );
        
        if (transaction.isPaid || transactionDate.isBefore(today) || transactionDate.isAtSameMomentAs(today)) {
          balance -= transaction.amount;
        }
        // Future unpaid bills/expenses don't affect current balance
      }
    }

    return balance;
  }

  // Calculate monthly income
  Future<double> calculateMonthlyIncome() async {
    final transactions = await getCurrentMonthTransactions();
    return transactions
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  // CRITICAL FIX: Calculate monthly expenses (Type: 'Expense' only)
  // This is what should be displayed as "This Month Expenses"
  // CRITICAL FIX: Calculate monthly expenses including ALL expenses in the month (past + future)
  Future<double> calculateMonthlyExpenses() async {
    final transactions = await getCurrentMonthTransactions();
    
    return transactions
        .where((t) {
          // Include ALL expenses and bills for the current month
          return t.type == TransactionType.expense || t.type == TransactionType.bill;
        })
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  // Calculate monthly bills (Type: 'Bill' only)
  Future<double> calculateMonthlyBills() async {
    final transactions = await getCurrentMonthTransactions();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return transactions
        .where((t) {
          // Only count bills that are paid or dated today/past
          if (t.type != TransactionType.bill) return false;
          
          final transactionDate = DateTime(
            t.date.year,
            t.date.month,
            t.date.day,
          );
          
          return t.isPaid || transactionDate.isBefore(today) || transactionDate.isAtSameMomentAs(today);
        })
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  // CRITICAL FIX: Get upcoming bills/expenses (future dated and unpaid)
  // Should NOT affect current balance calculation
  Future<List<Transaction>> getUpcomingBills() async {
    final transactions = await getAllTransactions();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return transactions
        .where((t) {
          // Include bills or expenses that are:
          // 1. Future-dated (tomorrow or later), OR
          // 2. Not yet paid
          final transactionDate = DateTime(
            t.date.year,
            t.date.month,
            t.date.day,
          );
          
          final isFutureDate = transactionDate.isAfter(today);
          
          return (t.type == TransactionType.bill || t.type == TransactionType.expense) &&
                 isFutureDate &&
                 !t.isPaid;
        })
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get spending by category for current month
  Future<Map<String, double>> getMonthlySpendingByCategory() async {
    final transactions = await getCurrentMonthTransactions();
    final Map<String, double> categorySpending = {};

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.expense || 
          transaction.type == TransactionType.bill) {
        categorySpending[transaction.category] = 
            (categorySpending[transaction.category] ?? 0) + transaction.amount;
      }
    }

    return categorySpending;
  }

  // CRITICAL FIX: Get statistics for a specific date range
  // CRITICAL FIX: Statistics include ALL expenses/bills within date range (regardless of isPaid)
  Future<Map<String, dynamic>> getStatisticsForDateRange(DateTime start, DateTime end) async {
    final transactions = await getTransactionsByDateRange(start, end);
    
    double totalIncome = 0;
    double totalExpense = 0;
    double highestExpense = 0;
    Map<String, double> categorySpending = {};
    Map<String, int> categoryCount = {};

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        totalIncome += transaction.amount;
      } else {
        // Include ALL expenses and bills within date range
        totalExpense += transaction.amount;
        if (transaction.amount > highestExpense) {
          highestExpense = transaction.amount;
        }
        
        // Track by category
        categorySpending[transaction.category] = 
            (categorySpending[transaction.category] ?? 0) + transaction.amount;
        categoryCount[transaction.category] = 
            (categoryCount[transaction.category] ?? 0) + 1;
      }
    }

    // Find most used category
    String mostUsedCategory = 'None';
    int maxCount = 0;
    categoryCount.forEach((category, count) {
      if (count > maxCount) {
        maxCount = count;
        mostUsedCategory = category;
      }
    });

    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'highestExpense': highestExpense,
      'mostUsedCategory': mostUsedCategory,
      'categorySpending': categorySpending,
      'transactionCount': transactions.length,
    };
  }

  // Clear all transactions (for testing or reset)
  Future<bool> clearAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_transactionsKey);
    _cachedTransactions = null;
    return true;
  }

  // Clear cache (force reload from storage)
  void clearCache() {
    _cachedTransactions = null;
  }
}
