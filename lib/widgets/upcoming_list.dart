// lib/widgets/upcoming_list.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/color_extension.dart';
import '../common/currency_helper.dart';
import '../common/transaction_helper.dart';
import '../models/transaction.dart';


class UpcomingList extends StatelessWidget {
  final Map sObj;
  final VoidCallback onPressed;

  const UpcomingList(
      {super.key, required this.sObj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final DateTime date = sObj["date"] ?? DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Upcoming bills selalu tipe bill (merah/orange)
    final typeColor = TransactionHelper.getColorForType(TransactionType.bill, context);
    final iconData = TransactionHelper.getIconForCategory(sObj["name"] ?? "");
    final bgColor = TransactionHelper.getBackgroundColorForType(TransactionType.bill);
    
    // CRITICAL FIX: Format dengan thousands separator, dengan minus untuk bill
    final amount = sObj["price"] as num? ?? 0;
    final formattedAmount = CurrencyHelper.formatExpense(amount.toDouble());
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(16),
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
              // Ikon dengan background warna
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconData,
                  color: typeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sObj["name"] ?? "Bill",
                      style: TextStyle(
                        color: TColor.text(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due ${DateFormat('MMM dd, yyyy').format(date)}",
                      style: TextStyle(
                        color: TColor.secondaryText(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formattedAmount,
                style: TextStyle(
                  color: typeColor, // Warna merah/orange untuk bill
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}