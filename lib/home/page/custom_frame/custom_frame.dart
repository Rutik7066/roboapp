import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quickalert/quickalert.dart';
import 'package:roboapp/const.dart';
import 'package:roboapp/cache_confige.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CustomFrame extends StatefulWidget {
  const CustomFrame({super.key});

  @override
  State<CustomFrame> createState() => _CustomFrameState();
}

// Uri.parse('${baseLink}getclientinfo&clid=${box.get("clid")}')
class _CustomFrameState extends State<CustomFrame> {
  Box box = Hive.box(robobox);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Ionicons.add),
        onPressed: () async {
          FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
            type: FileType.image,
          );
          if (pickedFile != null) {
            PlatformFile file = pickedFile.files[0];
            log(file.size.toString());
            if (file.size > 1 * 1024 * 1024) {
              if (mounted) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: "Select image less than 1MB",
                );
              }
              return;
            }
            if (mounted) {
              QuickAlert.show(
                barrierDismissible: false,
                context: context,
                type: QuickAlertType.loading,
              );
            }
            MultipartRequest req = MultipartRequest("POST", Uri.parse('https://robo.itraindia.org/server/admindesign.php?type=saveframe&clid=${box.get("clid")}'));
            req.files.add(await MultipartFile.fromPath('image', file.path!));
            req.fields.addAll({"clid": box.get("clid").toString()});
            StreamedResponse res = await req.send();
            var data = json.decode(await res.stream.bytesToString());
            if (data['status'].toString().contains("success")) {
              if (mounted) {
                Navigator.pop(context);
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                );
              }
              setState(() {});
            }
          }
        },
        label: const Text("Frame"),
      ),
      body: FutureBuilder(
        future: get(Uri.parse('${baseLink}getframes&clid=${box.get("clid")}')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            var data = json.decode(snapshot.data!.body);
            log(data.toString());
            List<dynamic> frame = data['frames'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: frame.map((e) {
                  return GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            title: const Text("Frame"),
                            content: Card(
                              child: Image.network(
                                "https://robo.itraindia.org/server/frame/${e['frame']}.png",
                              ),
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilledButton(
                                  onPressed: () async {
                                    var res = await get(Uri.parse('https://robo.itraindia.org/server/admindesign.php?type=deleteframe&id=${e["id"]}'));
                                    var data = json.decode(res.body);
                                    if (data['status'].toString().contains('success')) {
                                      setState(() {
                                        frame.remove(e);
                                      });
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: const Text("Delete Frame"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Back"),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2), // Shadow color
                            spreadRadius: 1, // Spread radius of the shadow
                            blurRadius: 5, // Blur radius of the shadow
                            offset: const Offset(0, 3), // Offset of the shadow
                          ),
                        ],
                      ),
                      child: GridTile(
                        child: CachedNetworkImage(
                          imageUrl: "https://robo.itraindia.org/server/frame/${e['frame']}.png",
                          fit: BoxFit.fill,
                          width: 100,
                          height: 100,
                          cacheManager: otherCacheManager,
                          fadeInDuration: Duration.zero,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
