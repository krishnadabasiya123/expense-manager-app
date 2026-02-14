import 'package:expenseapp/commons/widgets/custom_back_button.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

class QAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QAppBar({
    required this.title,
    super.key,
    this.roundedAppBar = true,
    this.removeSnackBars = true,
    this.bottom,
    this.bottomHeight = 52,
    this.usePrimaryColor = false,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.onTapBackButton,
    this.elevation,
  });

  final Widget title;
  final double? elevation;
  final TabBar? bottom;
  final bool automaticallyImplyLeading;
  final VoidCallback? onTapBackButton;
  final List<Widget>? actions;
  final bool roundedAppBar;
  final double bottomHeight;
  final bool removeSnackBars;
  final bool usePrimaryColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: roundedAppBar ? colorScheme.surface : Theme.of(context).scaffoldBackgroundColor,
      // ),
      scrolledUnderElevation: roundedAppBar ? elevation : 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      // elevation: elevation ?? (roundedAppBar ? 2 : 0),
      centerTitle: false,
      shadowColor: colorScheme.surface.withValues(alpha: 0.4),
      foregroundColor: usePrimaryColor ? Theme.of(context).primaryColor : colorScheme.onTertiary,
      backgroundColor: Theme.of(context).primaryColor,
      surfaceTintColor: roundedAppBar ? colorScheme.surface : Theme.of(context).scaffoldBackgroundColor,

      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      // ),
      iconTheme: const IconThemeData(color: Colors.white),
      // leading: automaticallyImplyLeading
      //     ? QBackButton(
      //         onTap: onTapBackButton,
      //         removeSnackBars: removeSnackBars,
      //         color: Colors.white,
      //       )
      //     : const SizedBox(),
      titleTextStyle: GoogleFonts.nunito(
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.sp(context),
        ),
      ),
      title: title,
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight),
              child: Container(
                margin: EdgeInsetsDirectional.symmetric(
                  horizontal: context.width * UiUtils.hzMarginPct,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: bottom,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => bottom == null ? const Size.fromHeight(kToolbarHeight) : Size.fromHeight(kToolbarHeight + bottomHeight + 32);
}

// class QAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const QAppBar({
//     required this.title,
//     super.key,
//     this.roundedAppBar = true,
//     this.bottom,
//     this.bottomHeight = 52,
//     this.usePrimaryColor = false,
//     this.actions,
//     this.automaticallyImplyLeading = true, // If true, Flutter tries to show it automatically
//     this.onTapBackButton,
//     this.elevation,
//   });

//   final Widget title;
//   final double? elevation;
//   final TabBar? bottom;
//   final bool automaticallyImplyLeading;
//   final VoidCallback? onTapBackButton;
//   final List<Widget>? actions;
//   final bool roundedAppBar;
//   final double bottomHeight;
//   final bool usePrimaryColor;

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return AppBar(
//       scrolledUnderElevation: roundedAppBar ? elevation : 0,

//       // FIX: Force the leading icon if automaticallyImplyLeading is true
//       // This ensures an arrow shows up even if it's the first screen
//       leading: automaticallyImplyLeading
//           ? IconButton(
//               icon: const Icon(Icons.arrow_back), // Standard Flutter icon
//               color: Colors.white,
//               onPressed:
//                   onTapBackButton ??
//                   () {
//                     if (Navigator.canPop(context)) {
//                       Navigator.pop(context);
//                     }
//                   },
//             )
//           : null,

//       automaticallyImplyLeading: automaticallyImplyLeading,
//       centerTitle: false,
//       backgroundColor: Theme.of(context).primaryColor,
//       iconTheme: const IconThemeData(color: Colors.white),
//       titleTextStyle: GoogleFonts.nunito(
//         textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//       ),
//       title: title,
//       actions: actions,
//       bottom: bottom != null
//           ? PreferredSize(
//               preferredSize: Size.fromHeight(bottomHeight),

//               child: Container(
//                 margin: EdgeInsetsDirectional.symmetric(
//                   horizontal: context.width * UiUtils.hzMarginPct,
//                   vertical: 16,
//                 ),
//                 // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white),
//                 child: bottom,
//               ),
//             )
//           : null,
//     );
//   }

//   @override
//   Size get preferredSize => bottom == null ? const Size.fromHeight(kToolbarHeight) : Size.fromHeight(kToolbarHeight + bottomHeight + 32);
// }
