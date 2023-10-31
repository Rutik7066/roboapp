import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roboapp/utils.dart';
import 'package:roboapp/const.dart';
import 'package:http/http.dart' as http;
import 'package:roboapp/home/page/brand_info/brand_info.dart';
import 'package:roboapp/home/page/custom_frame/custom_frame.dart';
import 'package:roboapp/home/page/digital_visiting/digivisiting.dart';
import 'package:roboapp/home/page/upgrade_plan/upgrade_plan.dart';
import 'package:roboapp/home/page/help_and%20_feed/help_and%20_feed.dart';
import 'package:roboapp/home/page/home_page/home_page.dart';
import 'package:roboapp/home/page/create/select_create.dart';
import 'package:roboapp/home/page/profile/profile.dart';
import 'package:roboapp/home/page/refer_and_earn/refer_and_earn.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:quickalert/quickalert.dart';

final gIndex = StateProvider<int>((ref) => 0);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  List page = [
    {"name": "Home", "icon": Ionicons.home_outline, "widget": const HomePage()},
    {"name": "Brand Info", "icon": Ionicons.briefcase_outline, "widget": const BrandInfo()},
    {"name": "Create", "icon": Ionicons.add_outline, "widget": const SelectCreate()},
    {"name": "Refer & Earn", "icon": Ionicons.share_social_outline, "widget": const ReferAndEarn()},
    {"name": "Help & Feed", "icon": Ionicons.help_circle_outline, "widget": const HelpAndfeed()},
    {"name": "Profile", "icon": Ionicons.person, "widget": const Profile()},
    {"name": "Rate Us", "icon": Ionicons.star_outline, "widget": null},
    {"name": "Upgrade Plan", "icon": Ionicons.star_outline, "widget": const UpgradePlan()},
    {"name": "Custom Frame", "icon": Ionicons.layers_outline, "widget": const CustomFrame()},
    {"name": "Digital Visiting Card", "icon": Ionicons.card, "widget": const DigiVisiting()}
  ];

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((packageInfo) {
      log("appName ${packageInfo.appName}");
      log("packageName ${packageInfo.packageName}");
      log("version ${packageInfo.version}");
      log("current version  ${packageInfo.buildNumber}");
      int current = int.parse(packageInfo.buildNumber);
      http.get(Uri.parse('https://robo.itraindia.org/server/versionstatus.json')).then((value) {
        int latest = jsonDecode(value.body)['buildNumber'];
        log(latest.toString());
        if (current < latest) {
          QuickAlert.show(
            barrierDismissible: true,
            context: context,
            type: QuickAlertType.success,
            title: 'Update Available.',
            confirmBtnText: "Update Now",
            showCancelBtn: true,
            confirmBtnTextStyle: TextStyle(fontSize: 15, color: Colors.white),
            cancelBtnTextStyle: TextStyle(
              fontSize: 15
            ),
            onConfirmBtnTap: () {
              launchUrlString(
                "https://play.google.com/store/apps/details?id=org.itraindia.roboapp",
                mode: LaunchMode.externalApplication,
              );
            },
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Box box = Hive.box(robobox);
    print('Home Rendered');
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          key: key,
          backgroundColor: Colors.white,
          appBar: AppBar(
              primary: true,
              leading: IconButton(
                onPressed: () => key.currentState!.openDrawer(),
                icon: const Icon(Ionicons.menu_outline),
              ),
              title: const Text('ITRA ROBO'),
              centerTitle: (box.get('plan') == "Demo") ? false : true,
              automaticallyImplyLeading: false,
              actions: [
                if (box.get('plan') == "Demo" || !isValid())
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 35,
                      width: 150,
                      child: FilledButton(
                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow)),
                          child: Text(
                            "UPGRADE NOW",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            ref.read(gIndex.notifier).state = 7;
                          }),
                    ),
                  )
              ]),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                  accountName: Text(box.get("business_name", defaultValue: ""), softWrap: true, style: const TextStyle(fontWeight: FontWeight.bold)),
                  accountEmail: Text(box.get("business_email", defaultValue: ""), style: const TextStyle(fontWeight: FontWeight.bold)),
                  currentAccountPicture: CircleAvatar(
                    radius: 80,
                    backgroundImage: box.get("business_image").toString().isEmpty
                        ? null
                        : NetworkImage(
                            "https://robo.itraindia.org/server/logo/${box.get("business_image", defaultValue: "3812.png?v=5760")}",
                          ),
                  ),
                ),
                ListTile(
                  selected: page[ref.watch(gIndex)]['name'] == "Home",
                  leading: const Icon(Ionicons.home_outline),
                  title: const Text("Home"),
                  onTap: () {
                    ref.read(gIndex.notifier).state = 0;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  selected: page[ref.watch(gIndex)]['name'] == "Brand Info",
                  leading: const Icon(Ionicons.briefcase_outline),
                  title: const Text("Brand Info"),
                  onTap: () {
                    ref.read(gIndex.notifier).state = 1;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  selected: page[ref.watch(gIndex)]['name'] == "Custom Frame",
                  leading: const Icon(Ionicons.layers_outline),
                  title: const Text("Custom Frame"),
                  onTap: () {
                    ref.read(gIndex.notifier).state = 8;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  selected: page[ref.watch(gIndex)]['name'] == "Digital Visiting Card",
                  leading: const Icon(Ionicons.briefcase_outline),
                  title: const Text("Digital Visiting Card"),
                  onTap: () {
                    ref.read(gIndex.notifier).state = 9;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  selected: page[ref.watch(gIndex)]['name'] == "Refer & Earn",
                  leading: const Icon(Ionicons.share_social_outline),
                  title: const Text("Refer & Earn"),
                  onTap: () {
                    ref.read(gIndex.notifier).state = 3;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  selected: page[ref.watch(gIndex)]['name'] == "Help & Feed",
                  leading: const Icon(Ionicons.help_circle_outline),
                  title: const Text("Help & Feed"),
                  onTap: () {
                    ref.read(gIndex.notifier).state = 4;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  selected: page[ref.watch(gIndex)]['name'] == "Profile",
                  leading: const Icon(Ionicons.person),
                  title: const Text("Profile"),
                  onTap: () {
                    ref.read(gIndex.notifier).state = 5;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  selected: page[ref.watch(gIndex)]['name'] == "Rate Us",
                  leading: const Icon(Ionicons.star_outline),
                  title: const Text("Rate Us"),
                  onTap: () async {
                    //org.itraindia.roboapp
                    await launchUrlString(
                      "https://play.google.com/store/apps/details?id=org.itraindia.roboapp",
                    );
                  },
                ),
                if (box.get('plan') == "Demo")
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: OutlinedButton(
                      child: const Text(
                        "Upgrade Plan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                        ref.read(gIndex.notifier).state = 7;
                        Navigator.pop(context);
                      },
                    ),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: ref.read(gIndex.notifier).state < 5 ? ref.read(gIndex.notifier).state : 0,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.deepPurple.shade500,
                icon: const Icon(Ionicons.home_outline),
                label: "Home",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.deepPurple.shade500,
                icon: const Icon(Ionicons.briefcase_outline),
                label: "Brand Info",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.deepPurple.shade500,
                icon: const Icon(Ionicons.add_outline),
                label: "Create",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.deepPurple.shade500,
                icon: const Icon(Ionicons.share_social_outline),
                label: "Refer & Earn",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.deepPurple.shade500,
                icon: const Icon(Ionicons.help_circle_outline),
                label: "Help & Feed",
              ),
            ],
            onTap: (index) {
              ref.read(gIndex.notifier).state = index;
            },
          ),
          body: page.elementAt(ref.watch(gIndex))["widget"],
        );
      },
    );
  }
}
