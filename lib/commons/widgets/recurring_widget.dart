import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [PopupMenuButton].

// This is the type used by the popup menu below.
enum SampleItem { itemOne, itemTwo, itemThree }

class PopupMenuExample extends StatefulWidget {
  const PopupMenuExample({super.key});

  @override
  State<PopupMenuExample> createState() => _PopupMenuExampleState();
}

class _PopupMenuExampleState extends State<PopupMenuExample> {
  SampleItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PopupMenuButton<String>(
        padding: EdgeInsetsDirectional.zero,
        icon: const Icon(Icons.more_vert),
        onSelected: (value) {},
        itemBuilder: (context) => [
          PopupMenuItem(
            value: context.tr('editKey'),
            child: Row(
              children: [
                Icon(Icons.edit, size: 20.sp(context)),
                const SizedBox(width: 8),

                CustomTextView(text: context.tr('editKey')),
              ],
            ),
          ),
          PopupMenuItem(
            value: context.tr('deleteKey'),
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red, size: 20.sp(context)),
                const SizedBox(width: 8),

                CustomTextView(text: context.tr('deleteKey')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
