// import 'dart:ui';
// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';

// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/features/Account/Screen/show_account_create_screen.dart';
// import 'package:expenseapp/features/Category/Widgets/add_category_dialogue.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/utils/Responsive_utils.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';

// void showAccountList(BuildContext context, {required TextEditingController controller}) {
//   showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     builder: (context) => ShowAccountBottomSheet(controller: controller),
//     barrierColor: Colors.black.withValues(alpha: 0.3),
//   );
// }

// class ShowAccountBottomSheet extends StatefulWidget {
//   const ShowAccountBottomSheet({required this.controller, super.key});
//   final TextEditingController controller;

//   @override
//   State<ShowAccountBottomSheet> createState() => ShowAccountBottomSheetState();
// }

// class ShowAccountBottomSheetState extends State<ShowAccountBottomSheet> {
//   //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
    
//   }

//   // String? selectedAccountId;

//   ValueNotifier<String> selectedAccountId = ValueNotifier('');
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Container(
//       padding: const EdgeInsetsDirectional.all(16),
//       height: MediaQuery.of(context).size.height * 0.5,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomTextView(text: context.tr('selectAccountLbl'), fontSize: 25.sp(context), fontWeight: FontWeight.bold),

//           const SizedBox(height: 10),
//           Expanded(
//             child: ValueListenableBuilder(
//               valueListenable: selectedAccountId,
//               builder: (context, value, child) {
//                 return ListView.builder(
//                   padding: EdgeInsetsDirectional.zero,
//                   itemCount: accounts.length,
//                   itemBuilder: (_, index) {
//                     final account = accounts[index];
//                     return RadioListTile<String>(
//                       value: account.id,
//                       controlAffinity: ListTileControlAffinity.trailing,
//                       groupValue: selectedAccountId.value,
//                       title: CustomTextView(text: account.name, fontSize: 20.sp(context)),
//                       dense: true,
//                       visualDensity: const VisualDensity(vertical: -2, horizontal: -3),
//                       contentPadding: EdgeInsetsDirectional.zero,
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       onChanged: (value) {
//                         selectedAccountId.value = value!;
//                         widget.controller.text = account.name;
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 10),

//           Center(
//             child: CustomRoundedButton(
             
//               onPressed: () {
//                 showCreateAccountSheet(context);
//               },
//               // width: 0.5,
//               backgroundColor: Theme.of(context).primaryColor,
//               text: context.tr('addAccountKey'),
//               borderRadius: BorderRadius.circular(8),
//               height: 45.sp(context),
//               textStyle: TextStyle(fontSize: 20.sp(context)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
