import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // You need to import the intl package
import '../common/color_extension.dart'; 

// A custom formatter for Indonesian Rupiah
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digit characters
    String sanitizedText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (sanitizedText.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    
    // Parse the number
    num value = num.tryParse(sanitizedText) ?? 0;

    // Format using Indonesian locale for dot separators
    final formatter = NumberFormat.decimalPattern('id_ID');
    String newText = formatter.format(value);

    // Return the formatted value and update cursor position to the end
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}


class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String currencySymbol;

  const AmountInputField({
    super.key,
    required this.controller,
    this.currencySymbol = 'Rp', // Changed default to 'Rp'
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: TColor.border.withOpacity(0.15)),
        color: TColor.gray60.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            currencySymbol,
            style: TextStyle(
              color: TColor.gray30,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              // Use number keyboard without decimals
              keyboardType: TextInputType.number, 
              inputFormatters: [
                // This ensures only digits are entered
                FilteringTextInputFormatter.digitsOnly,
                // This formats the digits with dot separators
                CurrencyInputFormatter(), 
              ],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  color: TColor.gray30,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}