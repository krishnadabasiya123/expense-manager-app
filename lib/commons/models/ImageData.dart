import 'dart:typed_data';

import 'package:expenseapp/core/app/all_import_file.dart';

part 'ImageData.g.dart';

@HiveType(typeId: 5)
class ImageData extends HiveObject {
  ImageData({this.imageId, this.picture});

  @HiveField(0)
  final String? imageId;

  @HiveField(1)
  final Uint8List? picture;

  Map<String, dynamic> toMap() => {'id': imageId, 'picture': picture};

  Map<String, dynamic> toJson() {
    return {'id': imageId, 'picture': picture};
  }
}
