import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/color_extension.dart';

class UpcomingBillRow extends StatelessWidget {
  final Map sObj;
  final VoidCallback onPressed;

  const UpcomingBillRow(
      {super.key, required this.sObj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final DateTime date = sObj["date"] ?? DateTime.now();
    final String month = DateFormat('MMM').format(date);
    final String day = DateFormat('dd').format(date);
    
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
                  color: TColor.gray70.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      month,
                      style: TextStyle(
                          color: TColor.gray30,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      day,
                      style: TextStyle(
                          color: TColor.white,
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
                          color: TColor.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due ${DateFormat('MMM dd, yyyy').format(date)}",
                      style: TextStyle(
                          color: TColor.gray30,
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
                "-\$${sObj["amount"]?.toStringAsFixed(2) ?? sObj["price"] ?? '0.00'}",
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
