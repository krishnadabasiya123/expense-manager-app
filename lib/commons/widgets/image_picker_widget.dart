import 'package:expenseapp/commons/widgets/DashBoardContainer.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  ImagePickerWidget({required this.picker, required this.selectedImage, super.key});
  ValueNotifier<List<File>> selectedImage = ValueNotifier<List<File>>([]);

  final ImagePicker picker;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickMultipleImages() async {
    UiUtils.hasStoragePermissionGiven().then((value) async {
      final pickedFiles = await widget.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);

      if (pickedFiles.isNotEmpty) {
        final newList = List<File>.from(widget.selectedImage.value);
        for (final pickedFile in pickedFiles) {
          newList.add(File(pickedFile.path));
        }
        widget.selectedImage.value = newList;
      } else {
        UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('noImagesSelected'));
      }
    });
  }

  void _removeImage(int index) {
    final newList = List<File>.from(widget.selectedImage.value)..removeAt(index);
    widget.selectedImage.value = newList;
  }

  String _getImageName(File image) {
    //return image.path.split('/').last;
    return 'Image ${widget.selectedImage.value.indexOf(image) + 1}';
  }

  Widget _buildMultiImageContainer({required ColorScheme colorScheme}) {
    return widget.selectedImage.value.isEmpty
        ? DashedBorderContainer(
            borderColor: colorScheme.primary,
            radius: 16,
            child: Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.all(12.sp(context)),
              child: _buildAddImageWidget(colorScheme: colorScheme),
            ),
          )
        : DashedBorderContainer(
            borderColor: colorScheme.primary,
            radius: 16,
            child: Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.all(12.sp(context)),
              child: _buildSelectedImagesWidget(colorScheme: colorScheme),
            ),
          );
  }

  Widget _buildAddImageWidget({required ColorScheme colorScheme}) {
    return GestureDetector(
      onTap: _pickMultipleImages,
      // borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(vertical: 10.sp(context), horizontal: 10.sp(context)),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 28.sp(context), color: context.colorScheme.onTertiary),
            SizedBox(height: 8.sp(context)),
            CustomTextView(text: context.tr('addImageLbl'), fontSize: 14.sp(context), color: context.colorScheme.onTertiary, fontWeight: FontWeight.w500),

            SizedBox(height: 4.sp(context)),

            CustomTextView(text: context.tr('tapSelectImageLBl'), fontSize: 14.sp(context), color: const Color.fromARGB(255, 0, 0, 0)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagesWidget({required ColorScheme colorScheme}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Add more images button
        Align(
          child: Container(
            padding: EdgeInsetsDirectional.symmetric(vertical: 8.sp(context), horizontal: 12.sp(context)),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: GestureDetector(
              onTap: _pickMultipleImages,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 20.sp(context), color: context.colorScheme.onTertiary),
                  SizedBox(width: 8.sp(context)),
                  CustomTextView(
                    text: context.tr('addMoreImagesLbl'),
                    fontSize: 14.sp(context),
                    color: context.colorScheme.onTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.sp(context)),

        // Selected images list
        Flexible(
          child: ListView.separated(
            padding: EdgeInsetsDirectional.zero,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.selectedImage.value.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.sp(context)),
            itemBuilder: (context, index) {
              final image = widget.selectedImage.value[index];
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.sp(context)),
                    child: Container(
                      width: 60.sp(context),
                      height: 60.sp(context),
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8.sp(context))),
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return ColoredBox(
                            color: Colors.grey.shade200,
                            child: Icon(Icons.image_not_supported, color: Colors.grey.shade400, size: 24.sp(context)),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 12.sp(context)),

                  // Image name and size
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getImageName(image),
                          style: TextStyle(fontSize: 14.sp(context), fontWeight: FontWeight.w500, color: colorScheme.onTertiary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.sp(context)),
                        FutureBuilder<int>(
                          future: image.length(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final sizeInKB = (snapshot.data! / 1024).round();
                              return Text(
                                '$sizeInKB KB',
                                style: TextStyle(fontSize: 12.sp(context), color: colorScheme.onTertiary),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8.sp(context)),

                  // Delete button
                  Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      //   borderRadius: BorderRadius.circular(20.sp(context)),
                      child: Container(
                        padding: EdgeInsetsDirectional.all(5.sp(context)),
                        decoration: BoxDecoration(color: context.colorScheme.expenseColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20.sp(context))),
                        child: Icon(Icons.close_rounded, color: context.colorScheme.expenseColor, size: 22.sp(context)),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: widget.selectedImage,
      builder: (context, imageFile, _) {
        return GestureDetector(
          onTap: _pickMultipleImages,
          //borderRadius: BorderRadius.circular(12),
          child: _buildMultiImageContainer(colorScheme: colorScheme),
        );
      },
    );
  }
}
