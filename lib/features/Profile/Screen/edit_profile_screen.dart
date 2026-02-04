import 'package:expenseapp/core/app/all_import_file.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  // File? _selectedImage; // Local picked image

  final ValueNotifier<File?> _selectedImage = ValueNotifier<File?>(null);

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    _selectedImage.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    UiUtils.hasStoragePermissionGiven().then((value) async {
      final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (image != null) {
        _selectedImage.value = File(image.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: QAppBar(
        title: CustomTextView(
          text: context.tr('editProfileKey'),
          color: Colors.white,
          fontSize: 20.sp(context),
        ),
      ),
      body: ResponsivePadding(
        topPadding: context.height * 0.02,
        bottomPadding: context.height * 0.02,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Use parent constraints to size the circle proportionally
                              final circleSize = constraints.maxWidth * 0.4; // 40% of parent width
                              final iconSize = circleSize * 0.15; // icon is 15% of circle size

                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Profile Image
                                  ValueListenableBuilder(
                                    valueListenable: _selectedImage,
                                    builder: (context, value, child) {
                                      return Container(
                                        width: context.screenWidth * (context.isMobile ? 0.35 : 0.3),
                                        height: context.screenWidth * (context.isMobile ? 0.35 : 0.3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(1000),
                                          child: const QImage(imageUrl: AppImages.splashScreen),
                                        ),
                                      );
                                    },
                                  ),

                                  // Edit Icon (keeps inside the circle)
                                  Positioned(
                                    bottom: circleSize * 0.05,
                                    right: circleSize * 0.05,
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
                                        height: iconSize,
                                        width: iconSize,
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius: BorderRadius.circular(iconSize / 3),
                                          border: Border.all(color: Colors.white, width: iconSize * 0.1),
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: iconSize * 0.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                        Column(
                          children: [
                            CustomTextFormField(
                              controller: firstNameController,
                              radius: 10,
                            ),

                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                            CustomTextFormField(
                              controller: lastNameController,
                              radius: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CustomRoundedButton(
              height: 45.sp(context),
              onPressed: () async {},
              padding: EdgeInsetsDirectional.symmetric(vertical: MediaQuery.of(context).size.height * 0.010, horizontal: MediaQuery.of(context).size.width * 0.002),
              backgroundColor: Colors.white,
              child: const CustomTextView(text: 'update'),
            ),
          ],
        ),
      ),
    );
  }
}
