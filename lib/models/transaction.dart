class Transaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String category;
  final DateTime date;
  final String note;
  final bool isRecurring;
  final bool isPaid; // CRITICAL: Track payment status for bills and expenses

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
    this.isRecurring = false,
    this.isPaid = true, // Default true for income/expenses, false for future bills
  });

  // Convert Transaction to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
      'isRecurring': isRecurring,
      'isPaid': isPaid,
    };
  }

  // Create Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String? ?? '',
      isRecurring: json['isRecurring'] as bool? ?? false,
      isPaid: json['isPaid'] as bool? ?? true, // Default true for backward compatibility
    );
  }

  // Create a copy with modified fields
  Transaction copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
    bool? isRecurring,
    bool? isPaid,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      isRecurring: isRecurring ?? this.isRecurring,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}

enum TransactionType {
  income,
  expense,
  bill,
}
