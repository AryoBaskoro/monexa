import 'package:flutter/material.dart';
import 'package:monexa_app/widgets/checkbox_text.dart';
import 'package:monexa_app/widgets/tertiary_button.dart';
import '../../common/color_extension.dart';
import '../../common/currency_helper.dart';
import '../../models/transaction.dart';
import '../../services/transaction_service.dart';
import '../../widgets/amount_input_field.dart';
import '../../widgets/animated_entry.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/date_picker_field.dart';
import 'dart:async';

class AddIncomeView extends StatefulWidget {
  const AddIncomeView({super.key});

  @override
  State<AddIncomeView> createState() => _AddIncomeViewState();
}

class _AddIncomeViewState extends State<AddIncomeView> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TransactionService _transactionService = TransactionService();
  
  DateTime selectedDate = DateTime.now();
  bool _isRecurring = false;
  bool _isSaving = false;
  
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: 'Add Income'),
            
            const Spacer(flex: 2),
            
            Expanded(
              flex: 18,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedEntry(
                      index: 0, 
                      controller: _animationController, 
                      child: AmountInputField(controller: _amountController)
                    ),
                    const SizedBox(height: 24),
                    AnimatedEntry(
                      index: 1, 
                      controller: _animationController, 
                      child: DatePickerField(
                        selectedDate: selectedDate,
                        onDateSelected: (newDate) {
                          setState(() => selectedDate = newDate);
                        },
                      )
                    ),
                    const SizedBox(height: 24),
                    AnimatedEntry(
                      index: 2, 
                      controller: _animationController, 
                      child: CheckboxText(
                        label: "Set as a recurring monthly income",
                        value: _isRecurring,
                        activeColor: TColor.primary, // Warna primer untuk income
                        onChanged: (newValue) {
                          setState(() => _isRecurring = newValue);
                        },
                      )
                    ),
                    const SizedBox(height: 40),
                    AnimatedEntry(
                      index: 3, 
                      controller: _animationController, 
                      child: TertiaryButton(
                        title: _isSaving ? 'Saving...' : 'Add Income',
                        onTap: _isSaving ? () {} : _addIncome,
                        gradient: LinearGradient(colors: [TColor.primary, TColor.primary.withOpacity(0.8)]),
                        shadowColor: TColor.primary,
                      )
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  void _showCustomSnackBar(String message, {required Color backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _addIncome() async {
    if (_amountController.text.isEmpty) {
      _showCustomSnackBar('Please enter an amount', backgroundColor: TColor.secondary);
      return;
    }

    // Parse amount - remove any formatting
    final amountText = _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      _showCustomSnackBar('Please enter a valid amount', backgroundColor: TColor.secondary);
      return;
    }

    setState(() => _isSaving = true);

    // Create transaction
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: TransactionType.income,
      amount: amount,
      category: 'Income',
      date: selectedDate,
      note: 'Income',
      isRecurring: _isRecurring,
      isPaid: true, // Income is always "paid" (received)
    );

    // Save to service
    final success = await _transactionService.addTransaction(transaction);

    setState(() => _isSaving = false);

    if (success) {
      _showCustomSnackBar(
        'Income added successfully! ${CurrencyHelper.formatRupiah(amount)}',
        backgroundColor: TColor.primary,
      );
      
      Timer(const Duration(milliseconds: 800), () {
        if (mounted) Navigator.pop(context, true); // Return true to indicate success
      });
    } else {
      _showCustomSnackBar('Failed to save income', backgroundColor: TColor.secondary);
    }
  }
}