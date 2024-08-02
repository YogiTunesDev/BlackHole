import 'dart:io';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DownloadService {
  late Box _box;
  late Stream<BoxEvent> _eventStream;

  DownloadService() {
    _box = Hive.box('downloads');
    _eventStream = _box.watch();
    _eventStream.listen(_handleBoxEvent);
  }

  void _handleBoxEvent(BoxEvent event) {
    // Handle the box event (add, update, delete)
    _backupBoxData();
  }

  Future<void> _backupBoxData() async {
    // Convert box data to a suitable format
    final boxData = _box.toMap();

    // print('Downloads Backup data: $boxData');

    // final response = await http.post(
    //   Uri.parse('https://your-backup-api.com/backup'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: boxData.toString(), // Convert to JSON string if needed
    // );

    // if (response.statusCode == 200) {
    //   // print('Backup successful');
    // } else {
    //   // print('Backup failed: ${response.statusCode}');
    // }
  }

  Future<void> _migrateFiles() async {
    final oldDir = await getApplicationDocumentsDirectory();
    final newDir = await getExternalStorageDirectory(); // Or any new directory

    if (oldDir != null && newDir != null) {
      final oldFiles = oldDir.listSync();

      for (var oldFile in oldFiles) {
        if (oldFile is File) {
          final newFilePath = path.join(newDir.path, path.basename(oldFile.path));
          await oldFile.copy(newFilePath);
          await oldFile.delete(); // Optionally delete old file after copying
        }
      }
    }
  }
}
