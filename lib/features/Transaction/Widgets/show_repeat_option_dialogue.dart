import 'package:expenseapp/commons/widgets/common_text_view.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringFrequency.dart';
import 'package:expenseapp/utils/extensions/localization_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<String?> showRepeatOptionDialogue({required BuildContext context}) {
  return showDialog<String>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),

            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.repeat, color: Colors.indigo),
                const SizedBox(width: 8),
                CustomTextView(
                  text: context.tr('repeatLbl'),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),

            SizedBox(height: context.height * 0.01),
            const Divider(height: 1),

            _repeatItem(context, UiUtils.getRecurringFrequencyString(RecurringFrequency.daily)),
            _repeatItem(context, UiUtils.getRecurringFrequencyString(RecurringFrequency.weekly)),
            _repeatItem(context, UiUtils.getRecurringFrequencyString(RecurringFrequency.monthly)),
            _repeatItem(context, UiUtils.getRecurringFrequencyString(RecurringFrequency.yearly)),
          ],
        ),
      );
    },
  );
}

Widget _repeatItem(BuildContext context, String title) {
  return InkWell(
    onTap: () {
      Navigator.pop(context, title);
    },
    child: Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ),
  );
}
