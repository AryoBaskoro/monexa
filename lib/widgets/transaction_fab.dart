import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/widgets/transaction_modal.dart';

class TransactionFAB extends StatefulWidget {
  const TransactionFAB({super.key});

  @override
  State<TransactionFAB> createState() => _TransactionFABState();
}

class _TransactionFABState extends State<TransactionFAB> {
  // Key untuk memicu animasi secara independen
  int _rotationKey = 0;

  void _onAddButtonTapped() {
    setState(() {
      _rotationKey++; // Update key untuk memutar ikon
    });
    _showAddTransactionModal();
  }

  void _showAddTransactionModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const TransactionModal(),
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
            TColor.secondary,
            TColor.secondary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: TColor.secondary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onAddButtonTapped,
          customBorder: const CircleBorder(),
          child: TweenAnimationBuilder<double>(
            key: ValueKey(_rotationKey),
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 0.785398, 
                child: child,
              );
            },
            child: Icon(
              Icons.add_rounded,
              color: TColor.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}