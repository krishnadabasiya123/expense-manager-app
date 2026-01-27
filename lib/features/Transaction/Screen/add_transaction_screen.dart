import 'package:expenseapp/commons/widgets/date_time_card.dart';
import 'package:expenseapp/core/app/all_import_file.dart';

import 'package:expenseapp/features/Account/Widgets/account_list_widget.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/add_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/update_trasansaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:expenseapp/features/RecurringTransaction/Enums/RecurringFrequency.dart';
import 'package:expenseapp/features/RecurringTransaction/Enums/RecurringTransactionStatus.dart';

import 'package:expenseapp/features/Transaction/Widgets/show_category_dialogue.dart';
import 'package:expenseapp/features/Transaction/Widgets/show_repeat_option_dialogue.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({required this.type, super.key, this.transaction, this.isEdit = false});
  final TransactionType type;
  final Transaction? transaction;
  final bool isEdit;

  @override
  State<AddTransactionScreen> createState() => AddTransactionScreenState();
}

class AddTransactionScreenState extends State<AddTransactionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? _amountController;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final accountController = TextEditingController();
  final dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final timeController = TextEditingController(text: DateFormat(timeFormat).format(DateTime.now()));
  ValueNotifier<String> selectedCategoryId = ValueNotifier('-1');
  TimeOfDay? picked;
  String? selectedAccountId;
  final ValueNotifier<List<File>> _selectedImage = ValueNotifier([]);
  //final selectedRecurring = ValueNotifier<Recurring>(Recurring.no);
  final ImagePicker _picker = ImagePicker();
  final ValueNotifier<String?> selectedAccId = ValueNotifier(null);
  final ValueNotifier<String?> selectedAccFromId = ValueNotifier(null);
  final ValueNotifier<String?> selectedAccToId = ValueNotifier(null);
  var index = -1;
  ValueNotifier<String> selectedValue = ValueNotifier('');
  final categoryLocalStorage = CategoryLocalStorage();
  ValueNotifier<bool> isCheck = ValueNotifier(false);
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String? repeat;

  final FocusNode _titleControllerFocusNode = FocusNode();
  final FocusNode _descriptionControllerFocusNode = FocusNode();
  final FocusNode _amountControllerFocusNode = FocusNode();

  bool isExpense = false;
  bool isIncome = false;
  bool isTransfer = false;

  @override
  void dispose() {
    _amountController!.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    accountController.dispose();
    dateController.dispose();
    timeController.dispose();
    categoryController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final tomorrow = DateTime.now();
    dateController.text = widget.isEdit ? widget.transaction?.date ?? '' : DateFormat(dateFormat).format(tomorrow);

    _amountController = TextEditingController(
      text: widget.transaction?.amount?.toString() ?? '',
    );

    _titleController.text = widget.isEdit ? widget.transaction?.title ?? '' : '';
    _descriptionController.text = widget.isEdit ? widget.transaction?.description ?? '' : '';
    selectedAccFromId.value = widget.isEdit ? widget.transaction?.accountFromId ?? '' : '';
    selectedAccToId.value = widget.isEdit ? widget.transaction?.accountToId ?? '' : '';
    categoryController.text = context.read<GetCategoryCubit>().getCategoryName(widget.transaction?.categoryId ?? '');
    selectedCategoryId.value = widget.isEdit ? widget.transaction!.categoryId! : '-1';
    selectedAccId.value = widget.isEdit ? widget.transaction?.accountId ?? '' : '';
    isExpense = widget.type == TransactionType.EXPENSE;
    isIncome = widget.type == TransactionType.INCOME;
    isTransfer = widget.type == TransactionType.TRANSFER;
    loadImages();
  }

  Future<void> loadImages() async {
    if (widget.isEdit && widget.transaction?.image != null) {
      final files = <File>[];

      for (final img in widget.transaction!.image!) {
        if (img.picture != null) {
          final file = await UiUtils.uint8ListToFile(
            img.picture!,
            img.imageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
          );
          files.add(file);
        }
      }

      _selectedImage.value = files;
    } else {
      _selectedImage.value = [];
    }
  }

  Future<List<ImageData>> getPartyImages(List<File> imageFiles) async {
    final images = <ImageData>[];

    for (final file in imageFiles) {
      final bytes = await file.readAsBytes();

      final imageId = 'IMAGE'.withDateTimeMillisRandom();

      images.add(
        ImageData(
          imageId: imageId,
          picture: bytes,
        ),
      );
    }

    return images;
  }

  DateTime? _getStartDate() {
    if (_startDateController.text.isEmpty) return null;

    try {
      final dateText = _startDateController.text.contains(':') ? _startDateController.text.split(':')[1].split('-').first.trim() : _startDateController.text;

      return DateFormat(dateFormat).parse(dateText);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ResponsivePadding(
                leftPadding: context.width * 0.05,
                rightPadding: context.width * 0.05,
                child: Column(
                  //  mainAxisAlignment: .spaceEvenly,
                  children: [
                    CustomTextFormField(
                      focusNode: _titleControllerFocusNode,
                      nextFocusNode: _amountControllerFocusNode,
                      controller: _titleController,
                      hintText: isExpense
                          ? context.tr('expenseNameKeyLbl')
                          : isIncome
                          ? context.tr('incomeNameKeyLbl')
                          : isTransfer
                          ? context.tr('transferNameKeyLbl')
                          : context.tr('expenseNameKeyLbl'),
                      radius: 15,
                    ),
                    SizedBox(height: context.height * 0.02),

                    CustomTextFormField(
                      focusNode: _amountControllerFocusNode,
                      nextFocusNode: _descriptionControllerFocusNode,
                      controller: _amountController ?? TextEditingController(),
                      hintText: context.tr('amountLbl'),
                      radius: 15,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: context.height * 0.02),
                    CustomTextFormField(
                      focusNode: _descriptionControllerFocusNode,

                      controller: _descriptionController,
                      hintText: context.tr('descriptionLbl'),
                      radius: 15,
                    ),

                    if (!isTransfer)
                      Column(
                        children: [
                          SizedBox(height: context.height * 0.02),
                          GestureDetector(
                            onTap: () {
                              showCategoryBottomSheet(context, selectedCategoryId: selectedCategoryId, categoryController: categoryController);
                            },
                            child: AbsorbPointer(
                              child: CustomTextFormField(
                                controller: categoryController,
                                hintText: context.tr('selectCategoryLbl'),

                                radius: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: context.height * 0.02),

                    Row(
                      mainAxisAlignment: .spaceEvenly,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: dateController,
                          builder: (context, value, child) {
                            return DateTimeCard(
                              isEdit: widget.isEdit,
                              icon: Icons.calendar_month,
                              title: context.tr('dateLbl'),

                              controller: dateController,
                              repeat: true,
                              onTap: () async {
                                // await UiUtils.selectDate(context, dateController);

                                final pickedDate = await UiUtils.selectDate(context, dateController);

                                if (pickedDate == null) return;

                                dateController.text = DateFormat(dateFormat).format(pickedDate);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    if (!widget.isEdit && !isTransfer) ...[
                      SizedBox(height: context.height * 0.02),
                      ValueListenableBuilder(
                        valueListenable: isCheck,
                        builder: (context, value, child) {
                          return Container(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.04, vertical: context.height * 0.008),
                            decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.repeat, size: 22.sp(context)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: CustomTextView(text: context.tr('repeatKey'), fontSize: 15.sp(context), fontWeight: FontWeight.bold),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: isCheck,
                                      builder: (context, value, child) {
                                        return Checkbox(
                                          value: isCheck.value,
                                          checkColor: const Color.fromARGB(255, 255, 255, 255),
                                          fillColor: WidgetStateProperty.resolveWith((states) {
                                            if (states.contains(WidgetState.selected)) {
                                              return Colors.black;
                                            }
                                            return null;
                                          }),

                                          onChanged: (value) {
                                            isCheck.value = value!;
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                if (isCheck.value) ...[
                                  const CustomHorizontalDivider(endOpacity: 0.2, padding: EdgeInsetsDirectional.only()),
                                  SizedBox(height: context.height * 0.01),
                                  InkWell(
                                    onTap: () async {
                                      final pickedDate = await UiUtils.selectDate(context, _startDateController);

                                      if (pickedDate == null) return;

                                      if (isCheck.value) {
                                        repeat = await showRepeatOptionDialogue(context: context);

                                        _startDateController.text =
                                            '${context.tr('startKey')} : '
                                            '${DateFormat(dateFormat).format(pickedDate)} - $repeat';
                                      } else {
                                        _startDateController.text = DateFormat(dateFormat).format(pickedDate);
                                      }
                                    },
                                    child: IgnorePointer(
                                      child: CustomTextFormField(
                                        hintText: 'Select Start Date',
                                        controller: _startDateController,
                                        borderSide: const BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: context.height * 0.01),
                                  InkWell(
                                    onTap: () async {
                                      final pickedDate = await UiUtils.selectDate(context, _endDateController);

                                      final startDate = _getStartDate();

                                      if (pickedDate!.isBefore(startDate!)) {
                                        UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('endDateLessThanStartDate'));
                                      } else {
                                        _endDateController.text = DateFormat(dateFormat).format(pickedDate);
                                      }
                                    },
                                    child: IgnorePointer(
                                      child: CustomTextFormField(
                                        hintText: 'Select End Date',
                                        controller: _endDateController,
                                        borderSide: const BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ],

                    SizedBox(height: context.height * 0.01),
                    if (!isTransfer) ...[
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextView(text: context.tr('accountLbl'), fontSize: 16.sp(context), color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          //
                        ],
                      ),
                      SizedBox(height: context.height * 0.02),

                      AccountListWidget(selectedAccountId: selectedAccId),
                    ] else ...[
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          CustomTextView(
                            text: context.tr('fromAccountLbl'),
                            fontSize: 16.sp(context),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: context.height * 0.02),

                          AccountListWidget(selectedAccountId: selectedAccFromId),
                          SizedBox(height: context.height * 0.02),
                          CustomTextView(text: context.tr('toAccountLbl'), fontSize: 16.sp(context), color: Colors.black, fontWeight: FontWeight.bold),
                          SizedBox(height: context.height * 0.02),

                          AccountListWidget(selectedAccountId: selectedAccToId),
                        ],
                      ),
                    ],

                    SizedBox(height: context.height * 0.02),

                    if (!isTransfer) ImagePickerWidget(picker: _picker, selectedImage: _selectedImage),

                    SizedBox(height: context.height * 0.02),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: context.height * 0.01),

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
            child: BlocConsumer<UpdateTrasansactionCubit, UpdateTrasansactionState>(
              listener: (context, updateState) async {
                if (updateState is UpdateTrasansactionSuccess) {
                  context.read<GetTransactionCubit>().updateTransactionLocally(updateState.transaction);
                  UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('transactionUpdateSucess'));
                  Navigator.pop(context);
                  // reset();
                }

                if (updateState is UpdateTrasansactionFailure) {
                  UiUtils.showCustomSnackBar(context: context, errorMessage: updateState.errorMessage);
                }
              },
              builder: (context, updateState) {
                return BlocConsumer<AddTransactionCubit, AddTransactionState>(
                  listener: (context, addState) async {
                    if (addState is AddTransactionSuccess) {
                      await context.read<GetTransactionCubit>().addTransactionLocally(addState.transaction);
                      context.read<GetAccountCubit>().getTotalAccountBalance(type: addState.transaction.type!, accountId: addState.transaction.accountId, amount: addState.transaction.amount!);
                      UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('transactionAddSucess'));
                      Navigator.pop(context);
                      if (addState.transaction.recurringId != null) {
                        //TODO: add context.addtranstaioncubit addTransaction method

                        //TODO: call context getrequreing trascation cubit add one more method create recureing

                        await context.read<GetRecurringTransactionCubit>().createRecurringTransaction(
                          Recurring(
                            recurringId: addState.transaction.recurringId,
                            title: addState.transaction.title,
                            frequency: UiUtils.convertStringToRecurringFrequency(repeat!),
                            startDate: UiUtils.getFormatedDate(_startDateController),
                            endDate: _endDateController.text,
                            amount: double.parse(_amountController!.text),
                            accountId: addState.transaction.accountId,
                            categoryId: addState.transaction.categoryId,
                            type: addState.transaction.type,
                          ),
                        );

                        context.read<GetRecurringTransactionCubit>().attachTransactionIdToRecurring(
                          recurringId: addState.transaction.recurringId!,
                          scheduleDate: UiUtils.getFormatedDate(_startDateController)!,
                          transactionId: addState.transaction.id!,
                          recurringTransactionId: addState.transaction.recurringTransactionId!,
                        );
                      }
                    }
                    if (addState is AddTransactionFailure) {
                      UiUtils.showCustomSnackBar(context: context, errorMessage: addState.errorMessage);
                    }
                  },
                  builder: (context, addState) {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomRoundedButton(
                            onPressed: () async {
                              final partyImages = await getPartyImages(_selectedImage.value);

                              //final getFormatedStateDate = getFormatedDate(_startDateController);

                              if (_amountController!.text.isEmpty) {
                                UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('amountKey'));
                              } else if ((isIncome && selectedAccId.value == '') || (isExpense && selectedAccId.value == '')) {
                                UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('plzSelectAccountKey'));
                              } else if (isTransfer && (selectedAccFromId.value == '0' || selectedAccToId.value == '0')) {
                                UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('selectAccountLbl'));
                              } else if (isTransfer && selectedAccFromId.value == selectedAccToId.value) {
                                UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('sameAccountKey'));
                              } else {
                                final transactionId = 'TR'.withDateTimeMillisRandom();
                                final reccuringID = 'R'.withDateTimeMillisRandom();

                                if (widget.isEdit) {
                                  await context.read<UpdateTrasansactionCubit>().updateTransaction(
                                    Transaction(
                                      id: widget.transaction!.id,
                                      date: dateController.text,
                                      title: _titleController.text,
                                      type: widget.type,
                                      amount: double.parse(_amountController!.text),
                                      description: _descriptionController.text,
                                      categoryId: selectedCategoryId.value,
                                      accountId: selectedAccId.value,
                                      recurringId: isCheck.value ? reccuringID : null,
                                      accountFromId: selectedAccFromId.value,
                                      accountToId: selectedAccToId.value,
                                      image: partyImages,
                                      addFromType: isCheck.value ? TransactionType.RECURRING : TransactionType.NONE,
                                      recurringTransactionId: isCheck.value ? widget.transaction?.recurringTransactionId ?? 'RT'.withDateTimeMillisRandom() : null,
                                    ),
                                  );
                                } else {
                                  await context.read<AddTransactionCubit>().addTransaction(
                                    Transaction(
                                      id: transactionId,
                                      date: dateController.text,
                                      title: _titleController.text,
                                      type: widget.type,
                                      amount: double.parse(_amountController!.text),
                                      description: _descriptionController.text,
                                      categoryId: selectedCategoryId.value,
                                      accountId: selectedAccId.value,
                                      recurringId: isCheck.value ? reccuringID : null,
                                      accountFromId: selectedAccFromId.value,
                                      accountToId: selectedAccToId.value,
                                      image: partyImages,
                                      addFromType: isCheck.value ? TransactionType.RECURRING : TransactionType.NONE,
                                      recurringTransactionId: isCheck.value ? 'RT'.withDateTimeMillisRandom() : null,
                                    ),
                                  );
                                }
                              }
                            },
                            width: 1,
                            backgroundColor: colorScheme.primary,
                            text: widget.isEdit ? context.tr('update') : context.tr('addKey'),
                            textStyle: TextStyle(fontSize: context.isTablet ? 18.sp(context) : 16.sp(context)),
                            borderRadius: BorderRadius.circular(8),
                            height: context.height * 0.05,
                            isLoading: widget.isEdit ? updateState is UpdateTrasansactionLoading : addState is AddTransactionLoading,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomRoundedButton(
                            onPressed: () {
                              if (widget.isEdit) {
                                if (updateState is! UpdateTrasansactionLoading) {
                                  Navigator.pop(context);
                                }
                              } else {
                                if (addState is! AddTransactionLoading) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            width: 1,
                            backgroundColor: Theme.of(context).primaryColor,
                            text: context.tr('cancelKey'),
                            textStyle: TextStyle(fontSize: context.isTablet ? 18.sp(context) : 16.sp(context)),

                            borderRadius: BorderRadius.circular(8),
                            height: context.height * 0.05,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
