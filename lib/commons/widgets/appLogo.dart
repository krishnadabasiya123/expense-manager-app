import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: QImage(imageUrl: AppImages.loginScreen, height: 120, width: 168));
  }
}
