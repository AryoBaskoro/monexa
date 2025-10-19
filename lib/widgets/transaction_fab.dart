import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/widgets/transaction_modal.dart';

class TransactionFAB extends StatelessWidget {
  const TransactionFAB({super.key});

  void _showAddTransactionModal(BuildContext context) async {
    // CRITICAL FIX: No callback needed - Provider auto-updates!
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const TransactionModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primary,
            TColor.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAddTransactionModal(context),
          customBorder: const CircleBorder(),
          child: Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}

