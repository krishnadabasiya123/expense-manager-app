import 'dart:typed_data';

import 'package:expenseapp/core/app/all_import_file.dart';

part 'ImageData.g.dart';

@HiveType(typeId: 5)
class ImageData extends HiveObject {
 ImageData({
    this.imageId = '',
    Uint8List? picture,
  }) : picture = picture ?? Uint8List(0);
  
  @HiveField(0)
  String imageId;

  @HiveField(1)
  Uint8List picture;

  Map<String, dynamic> toMap() => {'id': imageId, 'picture': picture};

  Map<String, dynamic> toJson() {
    return {'id': imageId, 'picture': picture};
  }

  ImageData copyWith({
    String? imageId,
    Uint8List? picture,
  }) {
    return ImageData(
      imageId: imageId ?? this.imageId,
      picture: picture ?? this.picture,
    );
  }
}
