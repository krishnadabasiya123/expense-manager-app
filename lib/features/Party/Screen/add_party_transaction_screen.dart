import 'dart:typed_data';

import 'package:expenseapp/commons/widgets/custom_app_bar.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Party/Cubits/PartyTransaction/add_party_transaction_cubit.dart';
import 'package:expenseapp/features/Party/Cubits/PartyTransaction/update_party_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Widgets/show_category_dialogue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPartyTransactionWidget extends StatefulWidget {
  const AddPartyTransactionWidget({this.isEdit = false, super.key, this.partyTransaction, this.partyId});
  final bool isEdit;
  final PartyTransaction? partyTransaction;
  final Party? partyId;
  // final String? transactionId;
  // final String? partyTransactionId;

  @override
  State<AddPartyTransactionWidget> createState() => _AddPartyTransactionWidgetState();

  static Route<dynamic>? route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>?;

    final partyTransaction = args?['party'] as PartyTransaction?;

    final isEdit = args?['isEdit'] as bool? ?? false;

    final partyId = args?['partyId'] as Party?;

    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AddPartyTransactionCubit()),
          BlocProvider(create: (context) => UpdatePartyTransactionCubit()),
        ],
        child: AddPartyTransactionWidget(isEdit: isEdit, partyTransaction: partyTransaction, partyId: partyId),
      ),
    );
  }
}

class _AddPartyTransactionWidgetState extends State<AddPartyTransactionWidget> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TransactionType selectedType = TransactionType.CREDIT;
  bool isMainTransaction = false;
  String selectedAccountId = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController accountController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ValueNotifier<List<File>> _selectedImage = ValueNotifier([]);
  ValueNotifier<String> selectedCategoryId = ValueNotifier('');
  final categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _dateController.text = DateFormat(dateFormat).format(tomorrow);
    _dateController.text = widget.isEdit ? widget.partyTransaction?.date ?? '' : DateFormat(dateFormat).format(tomorrow);
    selectedType = widget.isEdit ? widget.partyTransaction?.type ?? TransactionType.CREDIT : TransactionType.CREDIT;
    isMainTransaction = widget.isEdit && (widget.partyTransaction?.isMainTransaction ?? false);
    _amountController.text = widget.isEdit ? widget.partyTransaction?.amount.toString() ?? '' : '';
    _descriptionController.text = widget.isEdit ? widget.partyTransaction?.description ?? '' : '';
    selectedCategoryId.value = widget.isEdit ? widget.partyTransaction!.category : '';
    categoryController.text = widget.isEdit ? context.read<GetCategoryCubit>().getCategoryName(widget.partyTransaction!.category) : '';
    selectedAccountId = widget.isEdit ? widget.partyTransaction?.accountId ?? '' : '';
    accountController.text = context.read<GetAccountCubit>().getAccountName(id: widget.partyTransaction?.accountId ?? '');

    loadImages();
  }

  @override
  void dispose() {
    _selectedImage.dispose();
    selectedCategoryId.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    accountController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<void> loadImages() async {
    if (widget.isEdit && widget.partyTransaction!.image != []) {
      final files = <File>[];
      for (final img in widget.partyTransaction!.image) {
        if (img.picture != Uint8List(0)) {
          final file = await UiUtils.uint8ListToFile(
            img.picture,
            img.imageId,
          );
          files.add(file);
        }
      }

      _selectedImage.value = files;
    } else {
      _selectedImage.value = [];
    }
  }

  final String partyTransactionId = 'PTR'.withDateTimeMillisRandom();
  final String transactionId = 'TR'.withDateTimeMillisRandom();

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.read<AddPartyTransactionCubit>().state is! AddPartyTransactionLoading && context.read<UpdatePartyTransactionCubit>().state is! UpdatePartyTransactionLoading) {
          Navigator.of(context).pop();
          return;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: QAppBar(
          title: CustomTextView(text: widget.isEdit ? context.tr('updatePartyTransaction') : context.tr('addPartyTransaction'), color: colorScheme.surface, fontSize: 20.sp(context)),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: ResponsivePadding(
                    topPadding: context.height * 0.01,
                    leftPadding: context.width * 0.05,
                    rightPadding: context.width * 0.05,
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .start,
                      children: [
                        CustomTextView(
                          text: context.tr('dateLbl'),
                          fontSize: context.isTablet ? 18.sp(context) : 16.sp(context),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: context.height * 0.01),

                        CustomTextFormField(
                          isReadOnly: true,
                          controller: _dateController,
                          suffixIcon: const Icon(Icons.calendar_month),
                          onTap: () async {
                            final pickedDate = await UiUtils.selectDate(context, _dateController);

                            if (pickedDate == null) return;

                            _dateController.text = DateFormat(dateFormat).format(pickedDate);
                          },
                        ),
                        SizedBox(height: context.height * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextView(
                              text: context.tr('transactionTypeKey'),
                              fontSize: context.isTablet ? 18.sp(context) : 16.sp(context),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),

                            Row(
                              //mainAxisAlignment: .spaceEvenly,
                              children: [
                                _buildRadioButton(value: TransactionType.CREDIT, text: context.tr('creditKey')),
                                const SizedBox(width: 10),
                                _buildRadioButton(value: TransactionType.DEBIT, text: context.tr('debitKey')),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomTextFormField(
                          isReadOnly: true,

                          controller: categoryController,
                          hintText: context.tr('selectCategoryLbl'),

                          radius: 15,
                          onTap: () {
                            showCategoryBottomSheet(context, selectedCategoryId: selectedCategoryId, categoryController: categoryController);
                          },
                        ),

                        SizedBox(height: context.height * 0.01),
                        CustomTextView(
                          text: context.tr('amountLbl'),
                          fontSize: context.isTablet ? 18.sp(context) : 16.sp(context),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomTextFormField(
                          controller: _amountController,
                          hintText: context.tr('amtHintKey'),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: context.height * 0.02),
                        if (!widget.isEdit) ...[
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isMainTransaction = !isMainTransaction;
                                  });
                                },
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isMainTransaction ? colorScheme.primary : Colors.grey, width: 2),
                                    color: isMainTransaction ? colorScheme.primary : Colors.transparent,
                                  ),
                                  child: isMainTransaction ? Icon(Icons.check, color: Colors.white, size: 14.sp(context)) : const SizedBox.shrink(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              CustomTextView(text: context.tr('createMainTransactionKey'), fontSize: context.isTablet ? 18.sp(context) : 16.sp(context)),
                            ],
                          ),

                          if (isMainTransaction) ...[
                            Column(
                              children: [
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
                              ],
                            ),
                          ],
                          SizedBox(height: context.height * 0.02),
                        ],

                        CustomTextView(
                          text: context.tr('descriptionLbl'),
                          fontSize: context.isTablet ? 18.sp(context) : 16.sp(context),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomTextFormField(
                          maxLines: 3,
                          controller: _descriptionController,

                          hintText: context.tr('descriptionHintKey'),
                        ),
                        SizedBox(height: context.height * 0.02),
                        ImagePickerWidget(picker: _picker, selectedImage: _selectedImage),
                        SizedBox(height: context.height * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            BlocConsumer<UpdatePartyTransactionCubit, UpdatePartyTransactionState>(
              listener: (context, updateState) async {
                if (updateState is UpdatePartyTransactionSuccess) {
                  Navigator.of(context).pop();
                  context.read<GetPartyCubit>().updatePartyTransactinLocally(transaction: updateState.transaction, partyId: updateState.transaction.partyId);

                  if (isMainTransaction && widget.isEdit) {
                    context.read<GetTransactionCubit>().updateTransactionLocally(
                      Transaction(
                        id: widget.partyTransaction!.mainTransactionId,
                        date: _dateController.text,
                        title: updateState.transaction.partyName,
                        type: selectedType == TransactionType.CREDIT ? TransactionType.INCOME : TransactionType.EXPENSE,
                        amount: double.parse(_amountController.text),
                        description: _descriptionController.text,
                        categoryId: selectedCategoryId.value,
                        accountId: selectedAccountId,
                        image: updateState.transaction.image,
                        partyId: updateState.transaction.partyId,
                        partyTransactionId: updateState.transaction.id,
                        addFromType: selectedType,
                      ),
                    );
                  }
                }
                if (updateState is UpdatePartyTransactionFailure) {
                  Navigator.of(context).pop();
                  UiUtils.showCustomSnackBar(context: context, errorMessage: updateState.errorMessage);
                }
              },
              builder: (context, updateState) {
                return BlocConsumer<AddPartyTransactionCubit, AddPartyTransactionState>(
                  listener: (context, addPartyState) async {
                    if (addPartyState is AddPartyTransactionSuccess) {
                      context.read<GetPartyCubit>().addPartyTransactionLocally(transaction: addPartyState.transaction, partyId: addPartyState.transaction.partyId);

                      // if transaction is main then add in transaction List after add record in party transaction
                      if (isMainTransaction) {
                        context.read<GetTransactionCubit>().addTransactionLocally(
                          Transaction(
                            id: transactionId,
                            date: _dateController.text,
                            title: widget.partyId!.name,
                            type: selectedType == TransactionType.CREDIT ? TransactionType.INCOME : TransactionType.EXPENSE,
                            amount: double.parse(_amountController.text),
                            description: _descriptionController.text,
                            categoryId: selectedCategoryId.value,
                            accountId: selectedAccountId,
                            image: addPartyState.transaction.image,
                            partyId: addPartyState.transaction.partyId,
                            partyTransactionId: addPartyState.transaction.id,
                            addFromType: selectedType,

                            //image: partyImages,
                          ),
                        );
                      }

                      Navigator.of(context).pop();
                    }
                    if (addPartyState is AddPartyTransactionFailure) {
                      Navigator.of(context).pop();
                      UiUtils.showCustomSnackBar(context: context, errorMessage: addPartyState.message);
                    }
                  },
                  builder: (context, addPartyState) {
                    return Container(
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
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomRoundedButton(
                              onPressed: () async {
                                final partyImages = getPartyImages(_selectedImage.value);

                                if (_amountController.text.isEmpty) {
                                  await UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('amountKey'));
                                  return;
                                }
                                if (isMainTransaction && selectedAccountId == '') {
                                  await UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('plzSelectAccountKey'));
                                  return;
                                }
                                if (widget.isEdit) {
                                  await context.read<UpdatePartyTransactionCubit>().updatePartyTransaction(
                                    partyId: widget.partyTransaction!.partyId,
                                    transaction: PartyTransaction(
                                      id: widget.partyTransaction!.id,
                                      partyName: widget.partyTransaction!.partyName,

                                      date: _dateController.text,
                                      type: selectedType,
                                      image: await partyImages,
                                      category: selectedCategoryId.value,
                                      isMainTransaction: isMainTransaction,
                                      accountId: selectedAccountId,
                                      amount: double.parse(_amountController.text),
                                      description: _descriptionController.text,
                                      createdAt: widget.partyTransaction!.createdAt,
                                      updatedAt: DateTime.now().toString(),
                                      mainTransactionId: isMainTransaction ? widget.partyTransaction!.mainTransactionId : '',
                                      partyId: widget.partyTransaction!.partyId,
                                    ),
                                  );
                                } else {
                                  await context.read<AddPartyTransactionCubit>().addPartyTransaction(
                                    partyId: widget.partyId!.id,
                                    transaction: PartyTransaction(
                                      id: partyTransactionId,
                                      partyName: widget.partyId!.name,

                                      date: _dateController.text,
                                      type: selectedType,
                                      image: await partyImages,
                                      category: selectedCategoryId.value,
                                      isMainTransaction: isMainTransaction,
                                      accountId: selectedAccountId,
                                      amount: double.parse(_amountController.text),
                                      description: _descriptionController.text,
                                      createdAt: DateTime.now().toString(),
                                      updatedAt: DateTime.now().toString(),
                                      mainTransactionId: isMainTransaction ? transactionId : '',
                                      partyId: widget.partyId!.id,
                                    ),
                                  );
                                }
                              },
                              width: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              text: widget.isEdit ? context.tr('update') : context.tr('addKey'),
                              borderRadius: BorderRadius.circular(8),
                              height: context.height * 0.05,
                              textStyle: TextStyle(fontSize: context.isTablet ? 22.sp(context) : 18.sp(context)),
                              isLoading: widget.isEdit ? updateState is UpdatePartyTransactionLoading : addPartyState is AddPartyTransactionLoading,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomRoundedButton(
                              onPressed: () {
                                if (widget.isEdit) {
                                  if (updateState is! UpdatePartyTransactionLoading) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  if (addPartyState is! AddPartyTransactionLoading) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              width: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              text: context.tr('cancelKey'),
                              borderRadius: BorderRadius.circular(8),

                              height: context.height * 0.05,
                              textStyle: TextStyle(fontSize: context.isTablet ? 22.sp(context) : 18.sp(context)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton({required TransactionType value, required String text}) {
    return Row(
      children: [
        Radio<TransactionType>(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

          value: value,
          groupValue: selectedType,
          onChanged: (value) {
            setState(() {
              selectedType = value!;
            });
          },
        ),
        CustomTextView(text: text),
      ],
    );
  }

  List<Map<String, dynamic>> dropdownConfig({required List<Account> documentCategories}) {
    return documentCategories.map((acc) {
      return {'value': acc.id, 'label': acc.name, 'enabled': true};
    }).toList();
  }
}
