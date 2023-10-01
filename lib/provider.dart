import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:roboapp/const.dart';
import 'dart:developer';

final pb = PocketBase('http://ec2-13-200-79-156.ap-south-1.compute.amazonaws.com:5001');

final userData = FutureProvider<RecordModel?>((ref) async {
  Box box = Hive.box(robobox);

  try {
    RecordModel data = await pb.collection('profile').getFirstListItem('clid = "${box.get('clid')}"');
    log(data.toJson().toString());
    return data;
  } catch (e) {
    return null;
  }
});

final theme = FutureProvider<List<RecordModel>>((ref) async {
  List<RecordModel> data = await pb.collection('theme').getFullList();
  log(data.toString());
  return data;
});
