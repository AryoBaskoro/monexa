// lib/widgets/history_list.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../common/color_extension.dart';

// Helper function to format currency for Indonesian Rupiah
String _formatCurrency(dynamic amount) {
  if (amount is! num) {
    return 'Rp 0'; 
  }
  final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return format.format(amount);
}

class HistoryList extends StatelessWidget {
  final Map sObj;
  final VoidCallback onPressed;

  const HistoryList(
      {super.key, required this.sObj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius:  BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          height: 64,
            padding: const EdgeInsets.all( 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: TColor.border.withOpacity(0.15),
            ),
            
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              
              
              Image.asset(
                sObj["icon"],
                width: 40,
                height: 40,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  sObj["name"],
                  style: TextStyle(
                      color: TColor.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                // FIXED: Now uses the currency formatting function
                _formatCurrency(sObj["price"]),
                style: TextStyle(
                    color: TColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}