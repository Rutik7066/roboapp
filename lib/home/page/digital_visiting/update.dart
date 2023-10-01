import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:quickalert/quickalert.dart';
import 'package:roboapp/home/page/digital_visiting/buy_theme.dart';
import 'package:roboapp/home/page/digital_visiting/share_theme.dart';
import 'package:roboapp/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:roboapp/const.dart';
import 'package:http/http.dart' as http;

class UpdateCard extends StatefulWidget {
  final RecordModel record;
  const UpdateCard({
    super.key,
    required this.record,
  });

  @override
  State<UpdateCard> createState() => _UpdateCardState();
}

class _UpdateCardState extends State<UpdateCard> {
  PlatformFile? newAvtar;
  List<PlatformFile> newImaged = [];
  String avtar = '';
  String name = '';
  String businessName = '';
  String businessDetails = '';
  String businessAddress = '';
  String contact = '';
  String whatsapp = '';
  String email = '';
  List<dynamic> images = [];

  getNewData(RecordModel record) {
    avtar = record.data['profile_pic'];
    name = record.data['name'];
    businessName = record.data['business_name'];
    businessDetails = record.data['business_details'];
    businessAddress = record.data['business_address'];
    contact = record.data['contact'];
    whatsapp = record.data['whatsapp'];
    email = record.data['email'];
    images = record.data['images'];
  }

  @override
  void initState() {
    getNewData(widget.record);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: OutlinedButton.icon(
                  icon: const Icon(Ionicons.cart),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyTheme()));
                  },
                  label: const Text("But theme"),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: OutlinedButton.icon(
                  icon: const Icon(Ionicons.share_social_outline),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ShareTheme()));

                    // String theme = "theme01";
                    // // Open alert box and get theme and add to share
                    // final cbox = context.findRenderObject() as RenderBox?;
                    // Share.share(
                    //   "https://robo.itraindia.org/digicard?pro=${widget.record.id}&theme=$theme",
                    //   subject: "Let me recommend you this application",
                    //   sharePositionOrigin: cbox!.localToGlobal(Offset.zero) & cbox.size,
                    // );
                  },
                  label: const Text("Share"),
                ),
              ),
            )
          ],
        ),
      ],
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text(
                      "Profile Image",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CircleAvatar(
                            radius: 60,
                            child: newAvtar == null
                                ? Image.network(
                                    'http://ec2-13-200-79-156.ap-south-1.compute.amazonaws.com:5001/api/files/profile/${widget.record.id}/$avtar',
                                  )
                                : Image.file(File(newAvtar!.path!)),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Max size 2 MB \nOnly .jpg allowed.",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FilledButton(
                                onPressed: () async {
                                  // Getting file and setit to newavtar then
                                  FilePickerResult? res = await FilePicker.platform.pickFiles(
                                    allowMultiple: false,
                                    allowedExtensions: ['jpg', 'png'],
                                    type: FileType.custom,
                                  );
                                  if (res != null) {
                                    setState(() {
                                      newAvtar = res.files.first;
                                    });
                                  }
                                },
                                child: const Text('Upload Cover')),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100, width: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (v) => name = v,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: businessName,
                  decoration: InputDecoration(
                    labelText: 'Business Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100, width: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (v) => businessName = v,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: contact,
                  onChanged: (v) => contact = v,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100, width: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: whatsapp,
                  onChanged: (v) => whatsapp = v,
                  decoration: InputDecoration(
                    labelText: 'Whatsapp Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100, width: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: email,
                  onChanged: (v) => email = v,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100, width: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 2,
                  minLines: 2,
                  initialValue: businessAddress,
                  onChanged: (v) => businessAddress = v,
                  decoration: InputDecoration(
                    labelText: 'Business address',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100, width: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 3,
                  minLines: 3,
                  initialValue: businessDetails,
                  onChanged: (v) => businessDetails = v,
                  decoration: InputDecoration(
                    labelText: 'Business Details',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100, width: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text(
                      "Business Image",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: TextButton(
                      child: const Text("Change all"),
                      onPressed: () async {
                        FilePickerResult? file = await FilePicker.platform.pickFiles(
                          allowedExtensions: ['jpg', 'png'],
                          allowMultiple: false,
                          type: FileType.custom,
                        );
                        if (file != null) {
                          setState(() {
                            newImaged.add(file.files.first);
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(5),
                    border: const Border.fromBorderSide(
                      BorderSide(
                        color: Colors.indigo,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: images.isEmpty && newImaged.isEmpty
                      ? InkWell(
                          onTap: () async {
                            FilePickerResult? res = await FilePicker.platform.pickFiles(
                              allowedExtensions: ['jpg', 'png'],
                              allowMultiple: true,
                              type: FileType.custom,
                            );
                            if (res != null) {
                              log(res.count.toString());
                              setState(() {
                                newImaged = [...res.files.sublist(0, res.count > 5 ? 4 : res.files.length)];
                              });
                            }
                          },
                          child: const Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Ionicons.add_circle),
                                Text("Add Image"),
                                Text("Note: Only 5 images allowed\nAll image should be less than 5 MB"),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 3,
                                children: newImaged.isEmpty
                                    ? [
                                        ...images
                                            .map(
                                              (e) => Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: GridTile(
                                                  child: Image.network(
                                                    'http://ec2-13-200-79-156.ap-south-1.compute.amazonaws.com:5001/api/files/profile/${widget.record.id}/$e',
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ]
                                    : [
                                        ...newImaged
                                            .map(
                                              (e) => Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: GridTile(
                                                  child: Image.file(File(e.path.toString())),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        if (newImaged.length < 4)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              elevation: 5,
                                              child: InkWell(
                                                onTap: () async {
                                                  FilePickerResult? file = await FilePicker.platform.pickFiles(
                                                    allowedExtensions: ['jpg', 'png'],
                                                    allowMultiple: false,
                                                    type: FileType.custom,
                                                  );
                                                  if (file != null) {
                                                    setState(() {
                                                      newImaged.add(file.files.first);
                                                    });
                                                  }
                                                },
                                                child: const GridTile(
                                                  child: Icon(Ionicons.add_circle),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FilledButton(
                  onPressed: () async {
                    try {
                      if (mounted) {
                        QuickAlert.show(
                          barrierDismissible: false,
                          context: context,
                          type: QuickAlertType.loading,
                        );
                      }
                      Box box = Hive.box(robobox);
                      log('clid = "${box.get('clid')}"');
                      final body = <String, dynamic>{
                        "clid": widget.record.data['clid'],
                        "email": email,
                        "name": name,
                        "business_name": businessName,
                        "business_details": businessDetails,
                        "business_address": businessAddress,
                        "contact": contact,
                        "whatsapp": whatsapp,
                        "payment_history": widget.record.data['payment_history'],
                        "purchased_theme": widget.record.data['purchased_theme'],
                        "images": widget.record.data['images'],
                        "profile_pic": widget.record.data['profile_pic'],
                      };
                      // When imlement delete and update functionalty then we can use MultipartFile.fromuri method

                      List<http.MultipartFile> files = [];
                      if (newAvtar != null) {
                        // Deleting previous profile_pic
                        body['profile_pic'] = null;
                        final record = await pb.collection('profile').update(widget.record.id, body: body);
                        // Adding new
                        body.remove("profile_pic");
                        log(record.toJson().toString());
                        files.add(await http.MultipartFile.fromPath('profile_pic', newAvtar!.path!, filename: newAvtar!.name));
                      }
                      if (newImaged.isNotEmpty) {
                        // Deleting previous images
                        body['images'] = null;
                        final record = await pb.collection('profile').update(widget.record.id, body: body);
                        // Adding new
                        body.remove("images");

                        for (var i = 0; i < newImaged.length; i++) {
                          files.add(await http.MultipartFile.fromPath('images', newImaged[i].path!, filename: newImaged[i].name));
                        }
                      }
                      // updating new data with new files
                      final record = await pb.collection('profile').update(widget.record.id, body: body, files: files);
                      log(record.toJson().toString());
                      if (mounted) {
                        Navigator.pop(context);
                        QuickAlert.show(
                          barrierDismissible: false,
                          context: context,
                          type: QuickAlertType.success,
                          title: "Payment Successful",
                        );
                      }
                      setState(() {});
                    } on Exception catch (e) {
                      log("error: $e");
                      Navigator.pop(context);

                      QuickAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: QuickAlertType.error,
                        title: "Failed",
                        text: e.toString(),
                      );
                    }
                  },
                  child: const Text("Update Business Card"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
