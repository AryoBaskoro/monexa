import 'package:flutter/material.dart';
import 'package:monexa_app/widgets/checkbox_text.dart';
import 'package:monexa_app/widgets/tertiary_button.dart';
import '../../common/color_extension.dart';
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
  
  DateTime selectedDate = DateTime.now();
  bool _isRecurring = false;
  
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
                        title: 'Add Income',
                        onTap: _addIncome,
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

  void _addIncome() {
    if (_amountController.text.isEmpty) {
      _showCustomSnackBar('Please enter an amount', backgroundColor: TColor.secondary);
      return;
    }
    _showCustomSnackBar('Income added successfully!', backgroundColor: TColor.primary);
    
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.pop(context);
    });
  }
}