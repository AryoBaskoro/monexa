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
        color: TColor.gray60.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.notes_rounded, color: TColor.gray30, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              maxLines: 1,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: TColor.gray30, fontSize: 15),
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