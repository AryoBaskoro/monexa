import 'package:flutter/material.dart';
import 'package:monexa_app/widgets/amount_input_field.dart';
import 'package:monexa_app/widgets/animated_entry.dart';
import 'package:monexa_app/widgets/checkbox_text.dart';
import 'package:monexa_app/widgets/custom_header.dart';
import 'package:monexa_app/widgets/date_picker_field.dart';
import 'package:monexa_app/widgets/divider_with_text.dart';
import 'package:monexa_app/widgets/note_input_field.dart';
import 'package:monexa_app/widgets/outlined_icon_button.dart';
import 'package:monexa_app/widgets/tertiary_button.dart';
import '../../common/color_extension.dart';
import '../../common/currency_helper.dart';
import '../../models/transaction.dart';
import '../../services/transaction_service.dart';
import 'dart:async';

class CreateExpenseView extends StatefulWidget {
  const CreateExpenseView({super.key});

  @override
  State<CreateExpenseView> createState() => _CreateExpenseViewState();
}

class _CreateExpenseViewState extends State<CreateExpenseView> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TransactionService _transactionService = TransactionService();
  
  String selectedCategory = 'Entertainment';
  DateTime selectedDate = DateTime.now();
  bool _isRecurring = false;
  bool _isSaving = false;
  
  late AnimationController _animationController;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Entertainment', 'icon': Icons.movie_rounded, 'color': const Color(0xFF5CB85C)},
    {'name': 'Home', 'icon': Icons.home_rounded, 'color': const Color(0xFFD4AF37)},
    {'name': 'Food', 'icon': Icons.restaurant_rounded, 'color': const Color(0xFFFF6B35)},
    {'name': 'Transport', 'icon': Icons.directions_car_rounded, 'color': const Color(0xFF4A90E2)},
    {'name': 'Shopping', 'icon': Icons.shopping_bag_rounded, 'color': const Color(0xFFE94B3C)},
    {'name': 'Health', 'icon': Icons.favorite_rounded, 'color': const Color(0xFFFF1744)},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: 'Add Expenses'),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    AnimatedEntry(index: 0, controller: _animationController, child: AmountInputField(controller: _amountController)),
                    const SizedBox(height: 20),
                    AnimatedEntry(index: 1, controller: _animationController, child: _buildCategorySection(media)),
                    const SizedBox(height: 20),
                    AnimatedEntry(
                      index: 2,
                      controller: _animationController,
                      child: DatePickerField(
                        selectedDate: selectedDate,
                        onDateSelected: (newDate) {
                          setState(() => selectedDate = newDate);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedEntry(
                      index: 3,
                      controller: _animationController,
                      child: CheckboxText(
                        label: "Set as a recurring monthly expense",
                        value: _isRecurring,
                        activeColor: TColor.secondary,
                        onChanged: (newValue) {
                          setState(() => _isRecurring = newValue);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedEntry(index: 4, controller: _animationController, child: NoteInputField(controller: _noteController)),
                    const SizedBox(height: 32),
                    AnimatedEntry(
                      index: 5,
                      controller: _animationController,
                      child: TertiaryButton(
                        title: _isSaving ? 'Saving...' : 'Save',
                        onTap: _isSaving ? () {} : _saveExpense,
                        gradient: LinearGradient(colors: [TColor.secondary, TColor.secondary.withOpacity(0.8)]),
                        shadowColor: TColor.secondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedEntry(
                      index: 6,
                      controller: _animationController,
                      child: const DividerWithText(text: 'or'),
                    ),
                    const SizedBox(height: 20),
                    AnimatedEntry(
                      index: 7,
                      controller: _animationController,
                      child: OutlinedIconButton(
                        title: 'Scan Receipt',
                        icon: Icons.document_scanner_rounded,
                        onTap: _scanReceipt,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategorySection(Size media) {
    // ... (kode ini tetap sama karena spesifik untuk halaman ini)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(Icons.category_rounded, color: TColor.gray30, size: 18),
              const SizedBox(width: 8),
              Text('Category', style: TextStyle(color: TColor.gray30, fontSize: 14, fontWeight: FontWeight.w500)),
              const Spacer(),
              InkWell(
                onTap: () { /* Add new category logic */ },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.add_circle_outline_rounded, color: TColor.gray30, size: 20),
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = selectedCategory == category['name'];
            return _buildCategoryButton(
              name: category['name'],
              icon: category['icon'],
              color: category['color'],
              isSelected: isSelected,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryButton({required String name, required IconData icon, required Color color, required bool isSelected}) {
    // ... (kode ini juga tetap sama)
    return InkWell(
      onTap: () => setState(() => selectedCategory = name),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color.withOpacity(0.5) : TColor.border.withOpacity(0.15),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? color.withOpacity(0.2) : TColor.gray60.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? color : TColor.gray30, size: 20),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? TColor.white : TColor.gray30,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // _buildOrDivider() dan _buildScanReceiptButton() telah dihapus.

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

  void _saveExpense() async {
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

    // Determine transaction type - if recurring, it's a bill, otherwise expense
    final transactionType = _isRecurring ? TransactionType.bill : TransactionType.expense;
    
    // CRITICAL: Determine isPaid status based on date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final isFutureDate = transactionDate.isAfter(today);

    // Create transaction
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: transactionType,
      amount: amount,
      category: selectedCategory,
      date: selectedDate,
      note: _noteController.text.trim(),
      isRecurring: _isRecurring,
      isPaid: !isFutureDate, // Future transactions are unpaid, today/past are paid
    );

    // Save to service
    final success = await _transactionService.addTransaction(transaction);

    setState(() => _isSaving = false);

    if (success) {
      final typeLabel = _isRecurring ? 'Bill' : 'Expense';
      _showCustomSnackBar(
        '$typeLabel saved successfully! ${CurrencyHelper.formatRupiah(amount)}',
        backgroundColor: TColor.primary,
      );
      
      Timer(const Duration(milliseconds: 800), () {
        if (mounted) Navigator.pop(context, true); // Return true to indicate success
      });
    } else {
      _showCustomSnackBar('Failed to save expense', backgroundColor: TColor.secondary);
    }
  }

  void _scanReceipt() {
     _showCustomSnackBar('Scan receipt feature coming soon!', backgroundColor: TColor.gray60);
  }
}