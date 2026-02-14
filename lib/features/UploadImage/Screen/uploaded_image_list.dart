import 'dart:developer';

import 'package:expenseapp/commons/models/ImageData.dart';
import 'package:expenseapp/commons/widgets/custom_app_bar.dart';
import 'package:expenseapp/features/UploadImage/LocalStorage/uploaded_image_local_storage.dart';
import 'package:flutter/material.dart';

class UploadedImageList extends StatefulWidget {
  const UploadedImageList({super.key});

  @override
  State<UploadedImageList> createState() => _UploadedImageListState();
}

class _UploadedImageListState extends State<UploadedImageList> {
  List<ImageData> images = [];
  @override
  void initState() {
    super.initState();
    images = UploadedImageLocalStorage().getImages();
    for (final image in images) {
      log('image ${image.toJson()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: QAppBar(title: Text('Uploaded Images')),
    );
  }
}
