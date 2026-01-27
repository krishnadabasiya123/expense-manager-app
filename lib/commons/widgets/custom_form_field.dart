import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionRow extends StatelessWidget {
  const SelectionRow({required this.icon, required this.label, required this.value, required this.onTap, super.key, this.trailing});
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextView(text: label, fontSize: 12, color: Colors.grey.shade600),
                  const SizedBox(height: 6),

                  CustomTextView(text: value, fontSize: 15, fontWeight: FontWeight.w500),
                ],
              ),
            ),

            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
