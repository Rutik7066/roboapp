import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:quickalert/quickalert.dart';
import 'package:roboapp/const.dart';
import 'package:ionicons/ionicons.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // return await PackageInfo.fromPlatform();
  String code = '';
  @override
  void initState() {
    PackageInfo.fromPlatform().then((value) {
      code = value.version;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Box box = Hive.box(robobox);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 50, // Set the desired radius for your circular avatar
                    backgroundImage: NetworkImage(
                      "https://robo.itraindia.org/server/logo/${box.get("business_image")}",
                    ), // Replace with your image URL
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${box.get('business_name')}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Padding( 
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Valid Till : ${box.get('validity')}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              width: 200,
              child: OutlinedButton.icon(
                onPressed: () async {
                    if (mounted) {
                    QuickAlert.show(
                      barrierDismissible: false,
                      context: context,
                      type: QuickAlertType.loading,
                      title: 'Loading',
                    );
                  }
                  var res = await get(Uri.parse("${baseLink}logoutclient&clid=${box.get("clid")}"));
                  if (res.statusCode == 200) {
                    await box.clear();
                    await box.put("introdone", true);
                    print(res.reasonPhrase);
                  } else {
                    if (mounted) {
                       Navigator.pop(context);
                      QuickAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Failed',
                        text: res.reasonPhrase,
                      );
                    }
                  }
                },
                icon: const Icon(Ionicons.log_out_outline),
                label: const Text("Log Out"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "App Version 5.0.0",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
