import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReusableAppBar({super.key, this.title, this.onBackTap, this.showDrawer = false, this.actions, this.backgroundColor, this.textColor, this.elevation});
  final String? title;
  final VoidCallback? onBackTap;
  final bool showDrawer;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? textColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.w500, fontSize: 22.sp(context)),
            )
          : null,
      centerTitle: true,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      elevation: elevation ?? 4.0,
      leading: _buildLeading(context),
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    // Show drawer icon if showDrawer is true
    if (showDrawer) {
      return Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: textColor ?? Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      );
    }

    // Show back button if we can pop (came from another screen)
    if (Navigator.of(context).canPop()) {
      return BackButton(color: textColor ?? Colors.white, onPressed: onBackTap ?? () => Navigator.of(context).pop());
    }

    // Show nothing if no drawer and can't pop
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
