import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:roboapp/const.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quickalert/quickalert.dart';
/*
 * Update Data
 * Logo -
 * Busines Name - 
 * Business Address -
 * Mobile Number -
 * Email -
 * Business Details  -
 * Business category 
 * And Update locally ! 
 */

class BrandInfo extends StatefulWidget {
  const BrandInfo({super.key});

  @override
  State<BrandInfo> createState() => _BrandInfoState();
}

class _BrandInfoState extends State<BrandInfo> {
  //
  GlobalKey formKey = GlobalKey<FormState>();
  //
  TextEditingController businessName = TextEditingController();
  TextEditingController businessAddress = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController businessDetails = TextEditingController();
  //
  String? selecteeBusinessId; // id
  String selctedBusinessLabel = ""; // label
  late String? oldLogo;

  @override
  void initState() {
    var box = Hive.box(robobox);

    oldLogo = box.get('business_image');
    // Geting id of business category
    selctedBusinessLabel = box.get("bus_cat", defaultValue: "Business Category");
    businessName.text = box.get("business_name", defaultValue: '');
    email.text = box.get("business_email", defaultValue: "");
    selecteeBusinessId = box.get("business_category", defaultValue: null);
    mobileNumber.text = box.get("business_mobile", defaultValue: '');
    businessDetails.text = box.get("business_details", defaultValue: '');
    businessAddress.text = box.get("business_address", defaultValue: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(robobox).listenable(),
      builder: (context, box, child) {
        log("Business Image  ${box.get("business_image")} ${box.get("business_image") != null} and  ${box.get("business_image").toString().isNotEmpty}");

        return Scaffold(
          body: Form(
            key: formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 0.5,
                                color: Colors.deepPurple.shade500,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: box.get("business_image") != null && box.get("business_image").toString().isNotEmpty ? Image.network('https://robo.itraindia.org/server/logo/${box.get("business_image")}') : const Icon(Ionicons.add, size: 20),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Note: Logo should be less than 1 mb.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () async {
                                      final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                                      if (result != null) {
                                        final File file = File(result.files.single.path!);
                                        final url = Uri.parse('https://robo.itraindia.org/server/client.php?type=updatelogo');
                                        final request = http.MultipartRequest('POST', url);
                                        request.fields['uploaded_file'] = file.path;
                                        final multipartFile = await http.MultipartFile.fromPath('uploaded_file', file.path);
                                        request.files.add(multipartFile);
                                        try {
                                          final streamedResponse = await request.send();
                                          final response = await http.Response.fromStream(streamedResponse);
                                          if (response.statusCode == 200) {
                                            box.put("business_image", result.files.single.name);
                                          } else {
                                            print('Error uploading file. Status code: ${response.statusCode}');
                                          }
                                        } catch (e) {
                                          print('Error uploading file: $e');
                                        }
                                      } else {
                                        // User canceled the file picking.
                                      }
                                    },
                                    icon: const Icon(Ionicons.cloud_upload_outline),
                                    label: const Text("Upload Logo"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: businessName,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Ionicons.cart_outline,
                            color: Colors.deepPurple.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade500,
                            ),
                          ),
                          labelText: "Business Name",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Ionicons.mail_open_outline,
                            color: Colors.deepPurple.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade500,
                            ),
                          ),
                          labelText: "Email",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: mobileNumber,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Ionicons.call_outline,
                            color: Colors.deepPurple.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade500,
                            ),
                          ),
                          labelText: "Mobile",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: businessDetails,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Ionicons.document_outline,
                            color: Colors.deepPurple.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade500,
                            ),
                          ),
                          labelText: "Business Details",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: businessAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Ionicons.map_outline,
                            color: Colors.deepPurple.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade500,
                            ),
                          ),
                          labelText: "Address",
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: http.get(Uri.parse("https://robo.itraindia.org/designnewapi/user/businesscategory")),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List data = json.decode(snapshot.data!.body);

                          return Container(
                            margin: const EdgeInsets.all(8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.deepPurple.shade500,
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: PopupMenuButton<String?>(
                              // icon: const Icon(Ionicons.cart_outline),
                              constraints: const BoxConstraints.expand(),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.deepPurple.shade500),
                              ),
                              onSelected: (value) async {
                                // log(value.toString());
                                selecteeBusinessId = value;
                                selctedBusinessLabel = data.firstWhere((e) => e["id"] == value)["category"];
                                setState(() {});
                              },
                              itemBuilder: (context) {
                                return data
                                    .map((e) => PopupMenuItem(
                                          value: e["id"].toString(),
                                          child: Text(e["category"]),
                                        ))
                                    .toList();
                              },
                              child: Text(selctedBusinessLabel),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton.icon(
                        onPressed: () async {
                          Uri url = Uri.parse("${baseLink}updatebusiness");
                          QuickAlert.show(
                            barrierDismissible: false,
                            context: context,
                            type: QuickAlertType.loading,
                            title: 'Loading',
                            text: 'Saving your data',
                          );

                          var request = http.MultipartRequest('POST', url);
                          request.fields['business_name'] = businessName.text;
                          request.fields['business_email'] = email.text;
                          request.fields['business_details'] = businessDetails.text;
                          request.fields['business_mobile'] = mobileNumber.text;
                          request.fields['business_address'] = businessAddress.text;
                          request.fields['business_details'] = businessDetails.text;
                          request.fields['business_category'] = selecteeBusinessId.toString();
                          request.fields['business_image'] = box.get("business_image", defaultValue: "");
                          request.fields['fileNewName'] = "No";
                          request.fields['clid'] = box.get("clid", defaultValue: "0").toString();

                          try {
                            print(request.fields);
                            print(url);

                            var response = await request.send();
                            var responseString = await response.stream.bytesToString();
                            var jsonObject = json.decode(responseString);

                            log(responseString);

                            if (response.statusCode == 200) {
                              await box.put("business_name", businessName.text);
                              await box.put("business_mobile", mobileNumber.text);
                              await box.put("business_email", email.text);
                              await box.put("business_address", businessAddress.text);
                              await box.put("business_details", businessDetails.text);
                              await box.put("business_category", selecteeBusinessId);
                              await box.put("business_image", jsonObject["business_image"]);
                              await box.put("bus_cat", selctedBusinessLabel);
                              if (mounted) {
                                Navigator.pop(context);
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  type: QuickAlertType.success,
                                  text: 'Saved Successfully.',
                                );
                              }
                            } else if (jsonObject["status"] == "failed") {
                              if (mounted) {
                                Navigator.pop(context);
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: 'Oops...',
                                  text: 'Sorry, something went wrong',
                                );
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              Navigator.pop(context);
                              QuickAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Oops...',
                                text: 'Sorry, something went wrong',
                              );
                            }
                          }
                        },
                        icon: const Icon(Ionicons.save_outline),
                        label: const Text("Update"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
