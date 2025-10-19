import 'package:flutter/material.dart';
import '../common/color_extension.dart'; // Sesuaikan path jika perlu

class NoteInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const NoteInputField({
    super.key,
    required this.controller,
    this.hintText = 'Add note (optional)',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: TColor.border.withOpacity(0.15)),
        color: TColor.inputBackground(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.notes_rounded, color: TColor.secondaryText(context), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: TColor.text(context), fontSize: 15),
              maxLines: 1,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: TColor.secondaryText(context), fontSize: 15),
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