// lib/widgets/upcoming_list.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/color_extension.dart';

// ADDED: The currency formatting function
String _formatCurrency(dynamic amount) {
  if (amount is! num) {
    return 'Rp 0';
  }
  final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return format.format(amount);
}


class UpcomingList extends StatelessWidget {
  final Map sObj;
  final VoidCallback onPressed;

  const UpcomingList(
      {super.key, required this.sObj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final DateTime date = sObj["date"] ?? DateTime.now();
    final String month = DateFormat('MMM').format(date);
    final String day = DateFormat('dd').format(date);
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
              Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TColor.cardBackground(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      month,
                      style: TextStyle(
                          color: TColor.secondaryText(context),
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      day,
                      style: TextStyle(
                          color: TColor.text(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sObj["name"] ?? "Bill",
                      style: TextStyle(
                          color: TColor.text(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due ${DateFormat('MMM dd, yyyy').format(date)}",
                      style: TextStyle(
                          color: TColor.secondaryText(context),
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                // FIXED: Removed '$' and now uses the formatter
                "-${_formatCurrency(sObj["price"])}",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}