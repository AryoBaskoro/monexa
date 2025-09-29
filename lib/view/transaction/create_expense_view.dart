import 'package:flutter/material.dart';
import 'package:monexa_app/widgets/amount_input_field.dart';
import 'package:monexa_app/widgets/animated_entry.dart';
import 'package:monexa_app/widgets/checkbox_text.dart';
import 'package:monexa_app/widgets/custom_header.dart';
import 'package:monexa_app/widgets/date_picker_field.dart';
import 'package:monexa_app/widgets/note_input_field.dart';
import 'package:monexa_app/widgets/tertiary_button.dart';
import '../../common/color_extension.dart';
import 'dart:async';

class CreateExpenseView extends StatefulWidget {
  const CreateExpenseView({super.key});

  @override
  State<CreateExpenseView> createState() => _CreateExpenseViewState();
}

class _CreateExpenseViewState extends State<CreateExpenseView> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  String selectedCategory = 'Entertainment';
  DateTime selectedDate = DateTime.now();
  bool _isRecurring = false; // <-- VARIABEL BARU
  
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
            // 2. Ganti widget lama dengan widget kustom
            const CustomHeader(title: 'Add Expenses'),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    AnimatedEntry(
                      index: 0,
                      controller: _animationController,
                      child: AmountInputField(controller: _amountController),
                    ),
                    const SizedBox(height: 20),
                    AnimatedEntry(index: 1, controller: _animationController, child: _buildCategorySection(media)),
                    const SizedBox(height: 20),
                    AnimatedEntry(
                      index: 2,
                      controller: _animationController,
                      child: DatePickerField(
                        selectedDate: selectedDate,
                        onDateSelected: (newDate) {
                          setState(() {
                            selectedDate = newDate;
                          });
                        },
                      ),
                  ),
                    const SizedBox(height: 20),

                    AnimatedEntry(
                      index: 3,
                      controller: _animationController,
                      child: CheckboxText(
                        label: "Mark as recurring expense",
                        value: _isRecurring,
                        activeColor: TColor.secondary, // Warna untuk expense
                        onChanged: (newValue) {
                          setState(() {
                            _isRecurring = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedEntry(
                      index: 4,
                      controller: _animationController,
                      child: NoteInputField(controller: _noteController),
                    ),
                    const SizedBox(height: 32),

                    AnimatedEntry(
                      index: 5,
                      controller: _animationController,
                      child: TertiaryButton(
                        title: 'Save',
                        onTap: _saveExpense,
                        gradient: LinearGradient(colors: [TColor.secondary, TColor.secondary.withOpacity(0.8)]),
                        shadowColor: TColor.secondary,
                      ),
                    ),
                    
                    // ... (sisa widget Anda)
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
  
  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: TColor.border.withOpacity(0.1))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('or', style: TextStyle(color: TColor.gray40, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
        Expanded(child: Container(height: 1, color: TColor.border.withOpacity(0.1))),
      ],
    );
  }
  
  Widget _buildScanReceiptButton(Size media) {
    return InkWell(
      onTap: _scanReceipt,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: TColor.border.withOpacity(0.15)),
          color: TColor.gray60.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.document_scanner_rounded, color: TColor.white, size: 22),
            const SizedBox(width: 12),
            Text('Scan Receipt', style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700)),
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

  void _saveExpense() {
    if (_amountController.text.isEmpty) {
      _showCustomSnackBar('Please enter an amount', backgroundColor: TColor.secondary);
      return;
    }
    _showCustomSnackBar('Expense saved successfully!', backgroundColor: TColor.primary);
    
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void _scanReceipt() {
     _showCustomSnackBar('Scan receipt feature coming soon!', backgroundColor: TColor.gray60);
  }
}