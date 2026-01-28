import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Account/Cubits/add_account_cubit.dart';
import 'package:expenseapp/features/Account/Cubits/update_account_cubit.dart';
import 'package:flutter/material.dart';

void showCreateAccountSheet(
  BuildContext context, {
  bool? isEdit,
  Account? account,
}) {
  showModalBottomSheet<void>(
    enableDrag: false,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: UiUtils.bottomSheetTopRadius,
    ),
    constraints: const BoxConstraints(),
    builder: (sheetContext) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          final isAddLoading = sheetContext.read<AddAccountCubit>().state is AddAccountLoading;

          final isUpdateLoading = sheetContext.read<UpdateAccountCubit>().state is UpdateAccountLoading;

          if (!isAddLoading && !isUpdateLoading) {
            Navigator.of(sheetContext).pop();
          }
        },
        child: _AccountCreateWidget(
          isEdit: isEdit ?? false,
          account: account,
        ),
      );
    },
  );
}

class _AccountCreateWidget extends StatefulWidget {
  const _AccountCreateWidget({required this.isEdit, this.account, super.key});
  final bool? isEdit;
  final Account? account;

  @override
  State<_AccountCreateWidget> createState() => _AccountCreateWidgetState();
}

class _AccountCreateWidgetState extends State<_AccountCreateWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _nameControllerFocusNode = FocusNode();
  final FocusNode _balanceControllerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.isEdit! ? widget.account?.name ?? '' : '';
    _balanceController.text = widget.isEdit! ? widget.account?.amount.toString() ?? '' : '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _nameControllerFocusNode.dispose();
    _balanceControllerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: UiUtils.bottomSheetTopRadius),
      padding: EdgeInsetsDirectional.only(top: context.height * .02),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextView(text: widget.isEdit! ? context.tr('updateAccount') : context.tr('addAccountKey'), fontWeight: FontWeights.bold, fontSize: 18.sp(context), color: colorScheme.onTertiary),

            SizedBox(height: context.height * 0.01),

            Expanded(
              child: ResponsivePadding(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(8),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        focusNode: _nameControllerFocusNode,
                        nextFocusNode: _balanceControllerFocusNode,
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        hintText: context.tr('accountNameKey'),
                        prefixIcon: const Icon(Icons.wallet),
                      ),
                      SizedBox(height: context.height * 0.01),
                      CustomTextFormField(
                        controller: _balanceController,
                        focusNode: _balanceControllerFocusNode,
                        keyboardType: TextInputType.number,
                        hintText: context.tr('balanceKey'),
                        prefixIcon: const Icon(Icons.currency_bitcoin),
                      ),
                      const Spacer(),
                      BlocConsumer<UpdateAccountCubit, UpdateAccountState>(
                        listener: (context, updateState) {
                          if (updateState is UpdateAccountSuccess) {
                            context.read<GetAccountCubit>().updateAccountLocally(account: updateState.account);
                            UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('accountUpdateSucess'));
                            Navigator.pop(context);
                          }
                          if (updateState is UpdateAccountFailure) {
                            UiUtils.showCustomSnackBar(context: context, errorMessage: updateState.errorMessage);
                            Navigator.pop(context);
                          }
                        },
                        builder: (context, updateState) {
                          return BlocConsumer<AddAccountCubit, AddAccountState>(
                            listener: (context, addAccount) {
                              if (addAccount is AddAccountSuccess) {
                                context.read<GetAccountCubit>().addAccountLocally(account: addAccount.account);
                                UiUtils.showCustomSnackBar(
                                  context: context,
                                  errorMessage: context.tr('accountAddSucess'),
                                );
                                Navigator.pop(context);
                              }
                              if (addAccount is AddAccountFailure) {
                                UiUtils.showCustomSnackBar(context: context, errorMessage: addAccount.errorMessage);
                                Navigator.pop(context);
                              }
                            },
                            builder: (context, addAccount) {
                              return CustomRoundedButton(
                                onPressed: () {
                                  final accountId = 'ACCT'.withDateTimeMillisRandom();
                                  if (_nameController.text.isEmpty) {
                                    UiUtils.showCustomSnackBar(
                                      context: context,
                                      errorMessage: context.tr('accountNameReqKey'),
                                    );
                                    return;
                                  }

                                  if (widget.isEdit!) {
                                    context.read<UpdateAccountCubit>().updateAccount(
                                      account: Account(id: widget.account?.id ?? '', name: _nameController.text, amount: double.tryParse(_balanceController.text) ?? 0.0),
                                    );
                                  } else {
                                    context.read<AddAccountCubit>().addAccount(
                                      account: Account(id: accountId, name: _nameController.text, amount: double.tryParse(_balanceController.text) ?? 0.0),
                                    );
                                  }
                                },
                                isLoading: widget.isEdit! ? updateState is UpdateAccountLoading : addAccount is AddAccountLoading,
                                // width: 1,
                                backgroundColor: Theme.of(context).primaryColor,
                                text: widget.isEdit! ? context.tr('update') : context.tr('addKey'),
                                borderRadius: BorderRadius.circular(8),

                                height: context.isTablet ? context.height * 0.035 : context.height * 0.05,
                                textStyle: TextStyle(fontSize: 20.sp(context)),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
