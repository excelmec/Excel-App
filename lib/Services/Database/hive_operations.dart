import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HiveDB {
 static Future  retrieveData({required String valueName}) async {
    Directory dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true); // make sure it exists
    Hive.init(join(dir.path, 'hiveDB'));
    Box box = await Hive.openBox(valueName);
    var data = box.get(valueName);
    try {
      box.close();
    } catch (_) {}
    return data;
  }

  static storeData({required String valueName, var value}) async {
    Directory dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true); // make sure it exists
    Hive.init(join(dir.path, 'hiveDB'));
    Box box = await Hive.openBox(valueName);
    await box.put(valueName, value);
    try {
      box.close();
    } catch (e) {
      print("Writing to DB error: $e");
    }
  }

  static deleteData({required String valueName}) async {
    Directory dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true); // make sure it exists
    try {
      Hive.init(join(dir.path, 'hiveDB'));
      await Hive.deleteBoxFromDisk(valueName);
      print("successfully deleted the box");
    } catch (_) {}
  }
}
