import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quickalert/quickalert.dart';
import 'package:roboapp/component/edit/custom_edit/custom_edit.dart';
import 'package:roboapp/home/home.dart';

import 'package:roboapp/utils.dart';

class SelectCreate extends StatefulWidget {
  const SelectCreate({super.key});

  @override
  State<SelectCreate> createState() => _SelectCreateState();
}

class _SelectCreateState extends State<SelectCreate> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => 
       Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Create Custom Post",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: OutlinedButton.icon(
                      onPressed: () async {
                        if (isDemo()) {
                          QuickAlert.show(
                            barrierDismissible: false,
                            context: context,
                            type: QuickAlertType.warning,
                            title: 'Upgrade plan',
                            text: 'Upgrade plan to use custom post.',
                             confirmBtnText: "Upgrade",
                            onConfirmBtnTap: () {
                              Navigator.popUntil(context, ModalRoute.withName('/'));
                              ref.read(gIndex.notifier).state = 7;
                            },
                          );
                          return;
                        }
                        FilePickerResult? res = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.video);
                        if (res != null) {
                          // Send type, file path to create page
                          String? path = res.files.first.path;
                          if (path != null && mounted) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return CustomEdit(
                                file: path,
                                type: "video",
                              );
                            }));
                          }
                        }
                      },
                      icon: const Icon(Ionicons.videocam_outline),
                      label: const Text("Select Video for Post")),
                ),
                Padding(
                 padding: const EdgeInsets.all(28.0),
                 child: OutlinedButton.icon(
                     onPressed: () async {
                       if (isDemo()) {
                         QuickAlert.show(
                           barrierDismissible: false,
                           context: context,
                           type: QuickAlertType.warning,
                           title: 'Upgrade plan',
                           text: 'Upgrade plan to use custom post.',
                            confirmBtnText: "Upgrade",
                           onConfirmBtnTap: () {
                                Navigator.popUntil(context, ModalRoute.withName('/'));
                             ref.read(gIndex.notifier).state = 7;
                           },
                         );
                         return;
                       }
                       FilePickerResult? res = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.image);
                       if (res != null) {
                         // Send type, file path to create page
                         String? path = res.files.first.path;
                         if (path != null && mounted) {
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) {
                               return CustomEdit(
                                 file: path,
                                 type: "image",
                               );
                             }),
                           );
                         }
                       }
                     },
                     icon: const Icon(Ionicons.image_outline),
                     label: const Text("Select Image for Post")),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
