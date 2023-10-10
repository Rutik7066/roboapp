import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:roboapp/component/list/all_business_design.dart';
import 'package:roboapp/const.dart';

import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:roboapp/component/list/general_design.dart';
import 'package:roboapp/component/list/greeting_design.dart';
import 'package:roboapp/component/list/motivational_design.dart';
import 'package:roboapp/component/list/today_design.dart';
import 'package:roboapp/component/list/business_design.dart';
import 'package:roboapp/component/list/upcomming_design.dart';
import 'package:roboapp/component/extra/Ad.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Box box = Hive.box(robobox);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: get(Uri.parse(
              'https://robo.itraindia.org/server/apknewdesignclient.php?type=alldesignlist&business_category=${box.get("business_category")}')),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done || snap.hasData) {
              Map<String, dynamic> data =
                  Map<String, dynamic>.from(json.decode(snap.data!.body));
              List category = [
                {"cat": "todaydesign", "title": "Today's Event"},
                {"cat": "upcomingdesign", "title": "Upcomming Event"},
                {"cat": "greetingdesign", "title": "Greetings"},
                {"cat": "businessdesign", "title": "My Business"},
                {"cat": "businessdesign", "title": "All Business Design"},
                {"cat": "motivationaldesign", "title": "Motivational"},
                {"cat": "generaldesign", "title": "Genaral"},
              ];
              for (var i = 0; i < category.length; i++) {
                if (data[category[i]['cat']].length == 0) {
                  category.removeAt(i);
                }
              }

              return ListView(
                // crossAxisCount: 1,
                // crossAxisSpacing: 0,
                // mainAxisSpacing: 0,
                // childAspectRatio: 1.85,
                // padding: const EdgeInsets.all(5),
                children: [
                  const Ad(),
                  TodayDesign(
                      cat: "todaydesign",
                      catData: data["todaydesign"],
                      title: "Today's Event"),
                  UpcommingDesign(
                      cat: "upcomingdesign",
                      catData: data["upcomingdesign"],
                      title: "Upcoming Event"),
                  if (box.get('bus_cat') != null)
                    BusinessDesign(
                        cat: "businessdesign",
                        catData: data["businessdesign"],
                        title: "My Business"),
                  FutureBuilder(
                      future: get(Uri.parse(
                          'https://robo.itraindia.org/designnewapi/user/businesscategory')),
                      builder: (context, connection) {
                        if (connection.connectionState ==
                                ConnectionState.done ||
                            connection.hasData) {
                          List obj = json.decode(connection.data!.body);
                          return AllBusinessDesign(
                              cat: "businessdesign",
                              catData: obj,
                              title: "All Business Design");
                        } else {
                          return Container();
                        }
                      }),
                  GreetingDesign(
                      cat: "greetingdesign",
                      catData: data["greetingdesign"],
                      title: "Greetings"),
                  MotivationalDesign(
                      cat: "motivationaldesign",
                      catData: data["motivationaldesign"],
                      title: "Motivational"),
                  GeneralDesign(
                      cat: "generaldesign",
                      catData: data["generaldesign"],
                      title: "Genaral"),
                  const SizedBox(height: 100)
                ],
              );
            } else {
              return GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(
                  16,
                  (index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GridTile(
                        child: Shimmer(
                          child: Container(
                            color: Colors.grey.shade200,
                            height: 100,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
