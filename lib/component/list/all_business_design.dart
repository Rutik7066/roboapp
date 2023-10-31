import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:roboapp/const.dart';
import 'package:roboapp/home/page/home_page/image_selection/business_image_selection.dart';
import 'package:roboapp/home/page/home_page/image_selection/image_selection.dart';

import 'package:roboapp/cache_confige.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AllBusinessDesign extends StatefulWidget {
  final cat;
  final title;
  final catData;
  const AllBusinessDesign(
      {super.key,
      required this.cat,
      required this.title,
      required this.catData});

  @override
  State<AllBusinessDesign> createState() => _AllBusinessDesignState();
}

class _AllBusinessDesignState extends State<AllBusinessDesign> {
  @override
  Widget build(BuildContext context) {
    print(widget.catData);
    Box box = Hive.box(robobox);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {
                  //Example -> https://robo.itraindia.org/designnewapi/user/businesslist?business_category=CYBER%20CAFE
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const BusinessImageSelection(
                        isOtherCacheManager: true);
                  }));
                },
                child: const Text("View All")),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ...widget.catData.sublist(0, 5).map((event) {
                print("----Event----");
                print(event);
                print("----End----");
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FutureBuilder(
                      future: get(Uri.parse(
                          "https://robo.itraindia.org/designnewapi/user/businesslist1?business_category=${event['id']}&res=1")),
                      builder: (context, connection) {
                        if (connection.connectionState ==
                                ConnectionState.done ||
                            connection.hasData) {
                          Map bus = json.decode(connection.data!.body)[0];
                          print("----Bus----");
                          print(bus);
                          print(
                              "https://robo.itraindia.org/server/images/${bus["image"]}");
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      10), // Add BorderRadius here
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.5), // Shadow color
                                      spreadRadius: 4, // Spread radius
                                      blurRadius: 5, // Blur radius
                                      offset: const Offset(
                                          0, 3), // Offset in x and y directions
                                    ),
                                  ],
                                ),
                                child: GridTile(
                                  child: bus['image'] == null
                                      ? Shimmer(
                                          child: Container(
                                            color: Colors.grey.shade100,
                                            width: 100,
                                            height: 100,
                                          ),
                                        )
                                      : GestureDetector(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://robo.itraindia.org/server/images/${bus["image"]}",
                                            fit: BoxFit.fill,
                                            width: 100,
                                            height: 100,
                                            cacheManager: otherCacheManager,
                                            fadeInDuration: Duration.zero,
                                          ),
                                           onTap: () {
                                            //Example -> https://robo.itraindia.org/designnewapi/user/generallist
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ImageSelection(
                                        isOtherCacheManager: true,
                                        link: "https://robo.itraindia.org/designnewapi/user/businesslist?business_category=${bus['categoryid']}",
                                        name: event["category"],
                                      );
                                            }));
                                          },
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  event["category"],
                                  softWrap: true,
                                 textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Container(
                            child: const Center(),
                          );
                        }
                      }),
                );
              }),
              ////
              Container(
              
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10), // Add BorderRadius here
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 4, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset:
                          const Offset(0, 3), // Offset in x and y directions
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    //Example -> https://robo.itraindia.org/designnewapi/user/generallist
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const BusinessImageSelection(
                        isOtherCacheManager: true,
                      );
                    }));
                  },
                  child: const GridTile(
                    child: SizedBox(
  width: 100,
  height: 100,
                      child: Center(
                        child: Text("View All"),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );

    ;
  }
}
