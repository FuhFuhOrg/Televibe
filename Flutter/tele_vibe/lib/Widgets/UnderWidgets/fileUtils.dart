import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileUtils {
  // Выбор фото
  static Future<File?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  // Выбор видео
  static Future<File?> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  // Выбор фото и видео
  static Future<File?> pickMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

}
