import 'package:expenseapp/core/app/all_import_file.dart';

import 'package:flutter/material.dart';

class DateTimeCard extends StatefulWidget {
  const DateTimeCard({
    required this.icon,
    required this.controller,
    required this.onTap,
    super.key,
    this.title,
    this.onRepeatTapDown,
    this.repeat = false,
    this.isEdit,
  });
  final IconData icon;
  final String? title;
  final TextEditingController controller;
  final VoidCallback onTap;
  final GestureTapDownCallback? onRepeatTapDown;
  final bool? repeat;
  final bool? isEdit;

  @override
  State<DateTimeCard> createState() => _DateTimeCardState();
}

class _DateTimeCardState extends State<DateTimeCard> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.04, vertical: context.height * 0.008),
          decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(14)),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 22.sp(context),
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: CustomTextView(text: widget.title!, fontSize: 16.sp(context), fontWeight: FontWeight.bold),
                  ),
                  // if (!widget.isEdit!)
                  //   GestureDetector(
                  //     child: CustomTextView(
                  //       text: UiUtils.getRecurringString(widget.selectedRecurring!.value),
                  //       fontSize: 15.sp(context),
                  //       color: colorScheme.primary,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                ],
              ),
              SizedBox(height: context.height * 0.01),

              CustomTextView(
                text: widget.controller.text,
                fontSize: 18.sp(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
