import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_selector/file_selector.dart' as file_selector;

class FileSaver {
  static Future<String> saveFile(String fileName, Uint8List content) async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception("Storage permission not granted");
      }
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception("Could not determine downloads directory");
      }
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(content);
      return filePath;
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(content);
      return filePath;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final directoryPath = await file_selector.getDirectoryPath();
      if (directoryPath == null) {
        throw Exception("File save operation cancelled by user.");
      }
      final filePath = '${directoryPath}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(content);
      return filePath;
    } else {
      throw Exception("Unsupported platform for file saving.");
    }
  }
}
