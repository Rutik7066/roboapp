import 'dart:io';
import 'dart:developer';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roboapp/const.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

Box utilBox = Hive.box(robobox);

requestPermission(Permission storage) async {
  var t = await storage.request();
  print("${storage.toString()} :${(t.isGranted)}");
  return t.isGranted;
}

Future<String?> getDownload() async {
  return Platform.isAndroid
      ? (await AndroidPathProvider.downloadsPath)
      : (await getDownloadsDirectory())?.path;
}

bool isDemo() => utilBox.get("plan").toString().startsWith("Demo");
bool isValid() {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateTime validityDate = dateFormat.parse(utilBox.get('validity'));
  final DateTime currentDate = DateTime.now();
  return (currentDate.isBefore(validityDate) ||
      currentDate.isAtSameMomentAs(validityDate));
}

Future<bool> increaseDailyCount() async {
  int date = DateTime.now().day;
  String key = 'usage_for_$date';
  int daily = utilBox.get(key) ?? 0;
  print("$key : $daily");
  if (daily <= 9) {
    await utilBox.put(key, ++daily);
    return false;
  } else {
    return true;
  }
}
