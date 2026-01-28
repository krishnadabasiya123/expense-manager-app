import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/delete_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteRecurringDialogue(BuildContext context, {required String recurringId}) {
  final isCheck = ValueNotifier<bool>(false);
  return context.showAppDialog(
    child: BlocProvider(
      create: (context) => DeleteRecurringTransactionCubit(),
      child: Builder(
        builder: (dialogContext) {
          return ValueListenableBuilder(
            valueListenable: isCheck,
            builder: (context, value, child) {
              return Center(
                child: PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) {
                    if (didPop) return;
                    if (dialogContext.read<DeleteRecurringTransactionCubit>().state is! DeleteRecurringTransactionLoading) {
                      Navigator.of(dialogContext).pop();
                      return;
                    }
                  },
                  child: AlertDialog(
                    actions: [
                      Center(
                        child: Container(
                          child: ValueListenableBuilder(
                            valueListenable: isCheck,
                            builder: (context, value, child) {
                              return Column(
                                children: [
                                  SizedBox(height: context.height * 0.03),

                                  CustomTextView(text: context.tr('deleteAccountTitleKey'), fontWeight: FontWeight.bold, fontSize: 20.sp(context)),

                                  SizedBox(height: context.height * 0.01),
                                  CustomTextView(
                                    text: context.tr('recurringDialogueMsg'),
                                    softWrap: true,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    color: Colors.grey,
                                  ),

                                  SizedBox(height: context.height * 0.02),

                                  Container(
                                    padding: EdgeInsetsDirectional.symmetric(vertical: context.height * 0.01, horizontal: context.width * 0.04),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isCheck.value,
                                          activeColor: Colors.blue.shade800,
                                          onChanged: (value) {
                                            isCheck.value = value!;
                                          },
                                        ),
                                        SizedBox(width: context.width * 0.02),
                                        Expanded(
                                          child: CustomTextView(
                                            text: context.tr('keepAsNormalTransactionKey'),
                                            fontSize: 15.sp(context),
                                            color: Colors.black,
                                            softWrap: true,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: context.height * 0.02),

                                  /// Buttons
                                  BlocConsumer<DeleteRecurringTransactionCubit, DeleteRecurringTransactionState>(
                                    listener: (context, state) {
                                      if (state is DeleteRecurringTransactionSuccess) {
                                        context.read<GetRecurringTransactionCubit>().deleteRecurringTransactionLocally(recurringId: recurringId);
                                        Navigator.pop(context);
                                        if (isCheck.value) {
                                          context.read<GetTransactionCubit>().setNullRecurringTransactionId(recurringId: recurringId);
                                        } else {
                                          context.read<GetTransactionCubit>().permanentlyDeleteRecurringTransaction(recurringId: recurringId);
                                        }
                                      }
                                    },
                                    builder: (context, state) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(context).primaryColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                //  padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                                              ),
                                              onPressed: () {
                                                if (state is! DeleteRecurringTransactionLoading) {
                                                  Navigator.of(context).pop();
                                                }
                                              },

                                              child: CustomTextView(text: context.tr('deleteAccountCancelKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(context).primaryColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              ),
                                              onPressed: state is DeleteRecurringTransactionLoading
                                                  ? null
                                                  : () async {
                                                      await context.read<DeleteRecurringTransactionCubit>().deleteRecurringTransaction(recurringId: recurringId);
                                                    },
                                              child: state is DeleteRecurringTransactionLoading
                                                  ? const CustomCircularProgressIndicator(
                                                      color: Colors.white,
                                                    )
                                                  : CustomTextView(text: context.tr('deleteAccountConfirmKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
