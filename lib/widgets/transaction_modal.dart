import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/view/transaction/add_income_view.dart';
import 'package:monexa_app/view/transaction/create_expense_view.dart';

class TransactionModal extends StatelessWidget {
  const TransactionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.gray70.withOpacity(0.98),
            TColor.gray70,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 14),
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: TColor.gray30.withOpacity(0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 28),
          _buildTitle(),
          const SizedBox(height: 36),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                TColor.secondary.withOpacity(0.2),
                TColor.primary.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: TColor.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Add Transaction',
          style: TextStyle(
            color: TColor.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _ModalButton(
              icon: Icons.arrow_upward_rounded,
              label: 'Create Expense',
              colors: [TColor.secondary, TColor.secondary.withOpacity(0.8)],
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateExpenseView()));
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _ModalButton(
              icon: Icons.arrow_downward_rounded,
              label: 'Add Income',
              colors: [TColor.primary, TColor.primary.withOpacity(0.8)],
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddIncomeView()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for buttons inside the modal
class _ModalButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  const _ModalButton({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: TColor.white, size: 32),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: TextStyle(
                color: TColor.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}