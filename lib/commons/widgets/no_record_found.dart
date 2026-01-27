import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

class NoDataFoundScreen extends StatelessWidget {
  const NoDataFoundScreen({
    required this.title,
    this.subTitle,
    super.key,
  });
  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: context.width * 0.05,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: context.height * 0.02),
            CustomTextView(
              text: title,
              fontSize: 18.sp(context),
              color: Colors.black,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.height * 0.01),
            CustomTextView(
              text: subTitle ?? '',
              fontSize: 15.sp(context),
              color: Colors.black,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
