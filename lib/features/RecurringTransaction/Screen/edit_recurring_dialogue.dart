import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/update_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

// Future<void> showEditRecurringDialogue(BuildContext context, {required Recurring? recurring}) async {
//   await showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     barrierColor: Colors.black.withValues(alpha: 0.3),
//     constraints: const BoxConstraints(),

//     builder: (BuildContext context) {
//       return EditRecurringDialogue(recurring: recurring);
//     },
//     // transitionDuration: const Duration(milliseconds: 250),
//     // pageBuilder: (context, animation, secondaryAnimation) {
//     //   return Center(
//     //     child: ConstrainedBox(
//     //       constraints: BoxConstraints(minWidth: context.width * 0.5, maxWidth: context.isDesktop ? context.width * 0.6 : double.infinity),
//     //       child: EditRecurringDialogue(recurring: recurring),
//     //     ),
//     //   );
//     // },
//     // transitionBuilder: (context, animation, secondaryAnimation, child) {
//     //   return Transform.scale(
//     //     scale: Curves.easeOutBack.transform(animation.value),
//     //     child: Opacity(opacity: animation.value, child: child),
//     //   );
//     // },
//   );
// }

class EditRecurringScreen extends StatefulWidget {
  const EditRecurringScreen({super.key, this.recurring});
  final Recurring? recurring;

  @override
  State<EditRecurringScreen> createState() => EditRecurringDialogueState();
  static Route<dynamic>? route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>?;

    final recurring = args?['recurring'] as Recurring?;

    return CupertinoPageRoute(
      builder: (_) => EditRecurringScreen(recurring: recurring),
    );
  }
}

class EditRecurringDialogueState extends State<EditRecurringScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _endsDateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _oldEndsDateController = TextEditingController();

  final FocusNode _titleControllerFocusNode = FocusNode();
  final FocusNode _amountControllerFocusNode = FocusNode();
  String? selectedAccountId;
  final TextEditingController accountController = TextEditingController();
  String? selectedCatgoryId;
  final TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _endsDateController.text = widget.recurring!.endDate ?? '';
    _oldEndsDateController.text = widget.recurring!.endDate ?? '';
    _amountController.text = widget.recurring!.amount.toString();
    _titleController.text = widget.recurring!.title ?? '';
    selectedAccountId = widget.recurring?.accountId ?? '';
    accountController.text = context.read<GetAccountCubit>().getAccountName(id: widget.recurring?.accountId ?? '');
    selectedCatgoryId = widget.recurring?.categoryId ?? '';
    categoryController.text = context.read<GetCategoryCubit>().getCategoryName(widget.recurring?.categoryId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.read<UpdateRecurringTransactionCubit>().state is! UpdateRecurringTransactionLoading) {
          Navigator.of(context).pop();
          return;
        }
      },
      child: Scaffold(
        // color: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: CustomTextView(text: context.tr('editRecurringKey'), fontSize: 20.sp(context), color: colorScheme.surface),
          iconTheme: IconThemeData(color: colorScheme.surface),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ResponsivePadding(
                    topPadding: context.height * 0.01,
                    leftPadding: context.width * 0.05,
                    rightPadding: context.width * 0.05,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Center(
                        //   child: CustomTextView(
                        //     text: context.tr('editRecurringKey'),
                        //     fontSize: 18.sp(context),
                        //     fontWeight: FontWeight.bold,
                        //     color: colorScheme.onSurface,
                        //   ),
                        // ),
                        // SizedBox(height: context.height * 0.01),
                        CustomTextView(
                          text: context.tr('dateLbl'),
                          fontSize: 14.sp(context),

                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: context.height * 0.01),
                        InkWell(
                          onTap: () async {
                            final pickedDate = await UiUtils.selectDate(context, _endsDateController, isChangeEndDate: true);

                            if (pickedDate == null) return;

                            _endsDateController.text = DateFormat(dateFormat).format(pickedDate);
                          },
                          child: IgnorePointer(
                            child: CustomTextFormField(
                              controller: _endsDateController,
                              suffixIcon: const Icon(
                                Icons.calendar_month,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomTextView(
                          text: context.tr('titleLbl'),
                          fontSize: 14.sp(context),

                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomTextFormField(
                          focusNode: _titleControllerFocusNode,
                          nextFocusNode: _amountControllerFocusNode,
                          controller: _titleController,
                          hintText: context.tr('titleKey'),
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomTextView(
                          text: context.tr('amountLbl'),
                          fontSize: 14.sp(context),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomTextFormField(
                          focusNode: _amountControllerFocusNode,
                          controller: _amountController,
                          hintText: context.tr('amountKey'),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: context.height * 0.02),
                        CustomTextView(
                          text: context.tr('accountLbl'),
                          fontSize: 14.sp(context),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomDropdown(
                          items: context.read<GetAccountCubit>().getAccountList(),
                          controller: accountController,
                          hintText: context.tr('selectAccountLbl'),
                          hintStyle: const TextStyle(color: Colors.black),
                          iconSize: 0,
                          menuBackgroundColor: colorScheme.primary,
                          isEnabled: true,
                          borderColor: colorScheme.surface,
                          borderType: DropdownBorderType.outline,
                          borderRadius: 12,
                          textStyle: TextStyle(color: colorScheme.onTertiary.withValues(alpha: 0.8), fontSize: 15.sp(context), fontWeight: FontWeights.regular),
                          backgroundColor: Colors.white,
                          onSelected: (value, label) {
                            selectedAccountId = value;
                          },
                        ),
                        SizedBox(height: context.height * 0.02),
                        CustomTextView(
                          text: context.tr('categoryLbl'),
                          fontSize: 14.sp(context),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomDropdown(
                          items: context.read<GetCategoryCubit>().getCatgoryList(),
                          controller: categoryController,
                          hintText: context.tr('selectCategoryLbl'),
                          hintStyle: const TextStyle(color: Colors.black),
                          iconSize: 0,
                          menuBackgroundColor: colorScheme.primary,
                          isEnabled: true,
                          borderColor: colorScheme.surface,
                          borderType: DropdownBorderType.outline,
                          borderRadius: 12,
                          textStyle: TextStyle(color: colorScheme.onTertiary.withValues(alpha: 0.8), fontSize: 15.sp(context), fontWeight: FontWeights.regular),
                          backgroundColor: Colors.white,
                          onSelected: (value, label) {
                            selectedCatgoryId = value;
                          },
                        ),
                        SizedBox(height: context.height * 0.01),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.03, vertical: context.height * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.surfaceDim,
                      offset: const Offset(0, -2.5),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: BlocConsumer<UpdateRecurringTransactionCubit, UpdateRecurringTransactionState>(
                  listener: (context, state) {
                    if (state is UpdateRecurringTransactionSuccess) {
                      Navigator.pop(context);
                      context.read<GetRecurringTransactionCubit>().updateRecurringTransactionLocally(recurringTransaction: state.transaction!);
                      context.read<GetTransactionCubit>().updateRecurringDetailsLocally(recurring: state.transaction);
                      //if end date chnage create new transaction
                      context.read<GetRecurringTransactionCubit>().updateRecurringTransaction(state.transaction!);
                    }
                  },
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomRoundedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<UpdateRecurringTransactionCubit>().updateRecurringTransaction(
                                  recurringId: widget.recurring!.recurringId!,
                                  title: _titleController.text,
                                  amount: double.parse(_amountController.text),
                                  endDate: _endsDateController.text,
                                  accountId: selectedAccountId,
                                  categoryId: selectedCatgoryId,
                                );
                              }
                            },
                            width: 1,
                            backgroundColor: Theme.of(context).primaryColor,
                            text: context.tr('update'),
                            borderRadius: BorderRadius.circular(8),
                            //showBorder: false,
                            height: 40.sp(context),
                            textStyle: TextStyle(fontSize: 15.sp(context)),
                            isLoading: state is UpdateRecurringTransactionLoading,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomRoundedButton(
                            onPressed: () {
                              if (state is! UpdateRecurringTransactionLoading) {
                                Navigator.pop(context);
                              }
                            },
                            width: 1,
                            backgroundColor: Theme.of(context).primaryColor,
                            text: context.tr('cancelKey'),
                            borderRadius: BorderRadius.circular(8),
                            height: 40.sp(context),
                            textStyle: TextStyle(
                              fontSize: 15.sp(context),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
