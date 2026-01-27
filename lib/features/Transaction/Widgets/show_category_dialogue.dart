import 'package:expenseapp/core/app/all_import_file.dart';

import 'package:flutter/material.dart';

void showCategoryBottomSheet(BuildContext context, {required ValueNotifier<String> selectedCategoryId, required TextEditingController categoryController}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    constraints: const BoxConstraints(),
    builder: (context) => CategoryBottomSheet(selectedCategoryId: selectedCategoryId, categoryController: categoryController),
  );
}

class CategoryBottomSheet extends StatefulWidget {
  const CategoryBottomSheet({required this.selectedCategoryId, required this.categoryController, super.key});
  final ValueNotifier<String> selectedCategoryId;
  final TextEditingController categoryController;

  @override
  State<CategoryBottomSheet> createState() => CategoryBottomSheetState();
}

class CategoryBottomSheetState extends State<CategoryBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: widget.selectedCategoryId,
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsetsDirectional.all(16),
          height: MediaQuery.of(context).size.height * 0.5,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextView(text: context.tr('selectCategoryLbl'), fontSize: 18.sp(context), fontWeight: FontWeight.bold, color: colorScheme.onTertiary),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<GetCategoryCubit, GetCategoryState>(
                  builder: (context, state) {
                    if (state is GetCategorySuccess) {
                      return ListView.builder(
                        padding: EdgeInsetsDirectional.zero,
                        itemCount: state.category.length,
                        itemBuilder: (_, index) {
                          final category = state.category[index];

                          return RadioListTile<String>(
                            value: category.id,
                            controlAffinity: ListTileControlAffinity.trailing,
                            groupValue: widget.selectedCategoryId.value,
                            // groupValue: widget.selectedCategoryId.value,
                            title: CustomTextView(text: category.name, fontSize: 15.sp(context), color: colorScheme.onTertiary, softWrap: true, maxLines: 2),
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -2, horizontal: -3),
                            contentPadding: EdgeInsetsDirectional.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onChanged: (value) {
                              // if (widget.selectedCategoryId.value == category.id) {
                              //   Navigator.pop(context);
                              // }
                              widget.selectedCategoryId.value = value!;
                              widget.categoryController.text = category.name;
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }
                    return const CustomCircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
