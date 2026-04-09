import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/database_helper.dart';

class ExportService {
  static Future<String?> exportSales() async {
    // 🔐 Request permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      return null;
    }

    final db = DatabaseHelper.instance;
    final data = await db.getDailySales();

    var excel = Excel.createExcel();
    Sheet sheet = excel['Sales'];

    // Header
    sheet.appendRow(["Date", "Total"]);

    // Data
    for (var row in data) {
      sheet.appendRow([row['day'], row['total']]);
    }

    // 📁 Save to Downloads folder
    Directory? dir = await getExternalStorageDirectory();

    // Move to real Downloads path
    String newPath = "";
    List<String> folders = dir!.path.split("/");
    for (int i = 1; i < folders.length; i++) {
      String folder = folders[i];
      if (folder != "Android") {
        newPath += "/$folder";
      } else {
        break;
      }
    }
    newPath = "$newPath/Download";

    final file = File("$newPath/sales.xlsx");

    file.writeAsBytesSync(excel.encode()!);

    // 📂 Auto open file
    await OpenFile.open(file.path);

    return file.path; // return path for snackbar
  }
}
