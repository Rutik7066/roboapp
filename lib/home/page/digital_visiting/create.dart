import 'dart:developer';
import 'dart:io';
import 'package:roboapp/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:quickalert/quickalert.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:roboapp/home/page/digital_visiting/digivisiting.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:roboapp/const.dart';
import 'package:http/http.dart' as http;

class CreateCard extends StatefulWidget {
  const CreateCard({
    super.key,
  });

  @override
  State<CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  PlatformFile? avtar;
  String name = '';
  String businessName = '';
  String businessDetails = '';
  String businessAddress = '';
  String contact = '';
  String whatsapp = '';
  String email = '';
  List<PlatformFile> images = [];
  String theme = '';
  RecordModel? selectedTheme;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                          child: avtar == null
                              ? const Icon(Ionicons.person_add_outline)
                              : Image.file(
                                  File(
                                    avtar!.path.toString(),
                                  ),
                                ),
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
                                FilePickerResult? res = await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                                  allowedExtensions: ['jpg', 'png'],
                                  type: FileType.custom,
                                );
                                if (res != null) {
                                  setState(() {
                                    avtar = res.files.first;
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
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Text(
                    "Business Image",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
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
                child: images.isEmpty
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
                              images = [...res.files.sublist(0, res.count > 5 ? 4 : res.files.length)];
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
                              children: [
                                ...images
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GridTile(
                                          child: Image.file(File(e.path.toString())),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                if (images.length < 4)
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
                                              images.add(file.files.first);
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                              onPressed: () => setState(() => images = []),
                              child: const Text("Clear All Image"),
                            ),
                          )
                        ],
                      ),
              ),
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Text(
                    "Select theme (Only one)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              height: 250,
              // color: Colors.grey.shade400,
              child: FutureBuilder<List<RecordModel>>(
                initialData: [],
                future: pb.collection('theme').getFullList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    theme = snapshot.data!.first.data['name'];
                    selectedTheme = snapshot.data!.first;
                  }
                  return CarouselSlider(
                    options: CarouselOptions(
                      padEnds: false,
                      viewportFraction: 1,
                      height: 250,
                    ),
                    items: snapshot.data!.map(
                      (e) {
                        return Row(
                          children: [
                            Expanded(
                              child: Image.network(
                                'http://ec2-13-200-79-156.ap-south-1.compute.amazonaws.com:5001/api/files/theme/${e.id}/${e.data['image']}?thumb=50x50',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Theme Name ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          e.data['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Theme Price ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "₹ ${e.data['price']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FilterChip(
                                        label: Text(theme.contains(e.data['name']) ? "Selected" : "Select"),
                                        selected: theme.contains(e.data['name']),
                                        onSelected: (v) {
                                          setState(() {
                                            theme = v ? e.data['name'] : "";
                                            selectedTheme = v ? e : null;
                                          });
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                onPressed: () async {
                  if (selectedTheme == null) {
                    QuickAlert.show(
                      barrierDismissible: false,
                      context: context,
                      type: QuickAlertType.warning,
                      text: "Select one theme to buy.",
                    );
                    return;
                  }
                  if (mounted) {
                    QuickAlert.show(
                      barrierDismissible: false,
                      context: context,
                      type: QuickAlertType.loading,
                    );
                  }
                  Box box = Hive.box(robobox);
                  Razorpay razorpay = Razorpay();
                  var options = {
                    'key': key_id,
                    'currency': 'INR',
                    'amount': (int.tryParse(selectedTheme!.data['price']) ?? 0) * 100,
                    'name': 'ITRA ROBO',
                    'description': 'Purchasing Theme',
                    'retry': {'enabled': true, 'max_count': 1},
                    'send_sms_hash': true,
                    "allow_rotation": true,
                    'theme.color': '#651FFF',
                    'prefill': {'contact': box.get('business_mobile'), 'email': box.get('business_email')},
                  };
                  razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                  try {
                    razorpay.open(options);
                  } catch (e) {
                    if (mounted) {
                      QuickAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: QuickAlertType.error,
                        title: "Failed to start Gateway",
                        text: "Check internet connection.",
                      );
                    }
                  }
                },
                child: const Text("Create Business Card"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */

    QuickAlert.show(
      barrierDismissible: false,
      context: context,
      type: QuickAlertType.error,
      title: "Payment Failed",
      text: "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}",
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */

    try {
      Box box = Hive.box(robobox);
      log('clid = "${box.get('clid')}"');
      final body = <String, dynamic>{
        "clid": box.get('clid').toString(),
        "email": email,
        "name": name,
        "business_name": businessName,
        "business_details": businessDetails,
        "business_address": businessAddress,
        "contact": contact,
        "whatsapp": whatsapp,
        "payment_history":[ {
          'orderId': response.orderId,
          'paymentId': response.paymentId,
          'signature': response.signature,
        }],
        "purchased_theme": [theme],
        "theme": [selectedTheme!.id]
      };
      List<http.MultipartFile> files = [];
      files.add(await http.MultipartFile.fromPath('profile_pic', avtar!.path!));
      for (var i = 0; i < images.length; i++) {
        files.add(await http.MultipartFile.fromPath('images', images[i].path!));
      }
      final record = await pb.collection('profile').create(body: body, files: files);
      if (mounted) {
        QuickAlert.show(
          barrierDismissible: false,
          context: context,
          type: QuickAlertType.success,
          title: "Payment Successful",
        );
      }
    } on Exception catch (e) {
      log("error: $e");
      QuickAlert.show(
        barrierDismissible: false,
        context: context,
        type: QuickAlertType.error,
        title: "Failed",
        text: e.toString(),
      );
    }
  }
}
