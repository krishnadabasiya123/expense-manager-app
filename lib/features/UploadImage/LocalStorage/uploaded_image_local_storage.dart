import 'package:expenseapp/core/app/all_import_file.dart';

class UploadedImageLocalStorage {
  static late Box<ImageData> box;

  static Future<void> init() async {
    //Hive.registerAdapter(ImageDataAdapter());

    box = await Hive.openBox<ImageData>(imageBox);
  }

  Future<void> saveImages(List<ImageData> image) async {
    for (final imageData in image) {
      await box.add(imageData);
    }
  }

  List<ImageData> getImages() {
    final images = box.values.toList();
    return images;
  }
}
