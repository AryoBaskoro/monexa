// lib/widgets/history_list.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/color_extension.dart';
import '../common/currency_helper.dart';
import '../common/transaction_helper.dart';
import '../models/transaction.dart';

class HistoryList extends StatelessWidget {
  final Map sObj;
  final VoidCallback onPressed;

  const HistoryList(
      {super.key, required this.sObj, required this.onPressed});
  
  // CRITICAL FIX: Format date to match Upcoming tab format: "MMM dd, yyyy"
  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final String typeString = sObj["type"] ?? "expense";
    TransactionType transactionType;
    try {
      transactionType = TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == typeString,
        orElse: () => TransactionType.expense,
      );
    } catch (e) {
      transactionType = TransactionType.expense;
    }
    
    final iconData = TransactionHelper.getIconForCategory(sObj["name"] ?? "");
    final typeColor = TransactionHelper.getColorForType(transactionType, context);
    final bgColor = TransactionHelper.getBackgroundColorForType(transactionType);
    
    final amount = sObj["price"] as num? ?? 0;
    final formattedAmount = transactionType == TransactionType.income
        ? CurrencyHelper.formatIncome(amount.toDouble())
        : CurrencyHelper.formatExpense(amount.toDouble());
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10), 
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          height: 76, 
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), 
          decoration: BoxDecoration(
            border: Border.all(
              color: TColor.border.withOpacity(0.15),
            ),
            color: isDark ? TColor.cardBackground(context).withOpacity(0.5) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                width: 48, 
                height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconData,
                  color: typeColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      sObj["name"] ?? "Transaction",
                      style: TextStyle(
                        color: TColor.text(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4), 
                    
                    if (sObj["date"] != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                            color: TColor.gray40,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(sObj["date"] as DateTime),
                            style: TextStyle(
                              color: TColor.secondaryText(context),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    
                    if (sObj["note"] != null && (sObj["note"] as String).isNotEmpty) ...[
                      const SizedBox(height: 2), 
                      Row(
                        children: [
                          Icon(
                            Icons.notes_outlined,
                            size: 11,
                            color: TColor.gray40,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              sObj["note"],
                              style: TextStyle(
                                color: TColor.gray40,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formattedAmount,
                style: TextStyle(
                  color: typeColor, 
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}