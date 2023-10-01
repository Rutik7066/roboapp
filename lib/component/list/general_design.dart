import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roboapp/cache_confige.dart';
import 'package:roboapp/home/page/home_page/image_selection/image_selection.dart';

import 'package:shimmer_animation/shimmer_animation.dart';

class GeneralDesign extends StatefulWidget {
  final cat;
  final title;
  final catData;
  const GeneralDesign({super.key, required this.cat, required this.title, required this.catData});

  @override
  State<GeneralDesign> createState() => _GeneralDesignState();
}

class _GeneralDesignState extends State<GeneralDesign> {
  @override
  Widget build(BuildContext context) {
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
                  //Example -> https://robo.itraindia.org/designnewapi/user/generallist
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ImageSelection(
                         isOtherCacheManager: true,
                      link: "https://robo.itraindia.org/designnewapi/user/generallist",
                      name: widget.catData[0]["name"],
                    );
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
            children: List.generate(
              widget.catData.length,
              (index) {
                Map<String, dynamic> event = widget.catData[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                       decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10), // Add BorderRadius here
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // Shadow color
        spreadRadius: 4, // Spread radius
        blurRadius: 5, // Blur radius
        offset: Offset(0, 3), // Offset in x and y directions
      ),
    ],
  ),
                        child: GridTile(
                          child: event['image'] == null
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
                                    "https://robo.itraindia.org/server/images/${event["image"]}.png",
                                    fit: BoxFit.fill,
                                    width: 100,
                                    height: 100,
                                   fadeInDuration: Duration.zero,
                                    cacheManager: otherCacheManager,
                                  ),
                                  onTap: () {
                                    //Example -> https://robo.itraindia.org/designnewapi/user/generallist
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return ImageSelection(
                                        isOtherCacheManager: true,
                                        link: "https://robo.itraindia.org/designnewapi/user/generallist",
                                        name: event["name"],
                                      );
                                    }));
                                  },
                                ),
                        ),
                      ),
                      // widget.cat == "todaydesign" || widget.cat == "upcomingdesign"
                      //     ? SizedBox(
                      //         width: 100,
                      //         child: Text(
                      //           event["name"],
                      //           softWrap: true,
                      //           style: const TextStyle(fontSize: 13),
                      //         ),
                      //       )
                      //     : Container()
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
