import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roboapp/cache_confige.dart';
import 'package:roboapp/const.dart';
import 'package:roboapp/home/page/home_page/image_selection/image_selection.dart';

import 'package:shimmer_animation/shimmer_animation.dart';

class UpcommingDesign extends StatefulWidget {
  final cat;
  final title;
  final catData;
  const UpcommingDesign({super.key, required this.cat, required this.title, required this.catData});

  @override
  State<UpcommingDesign> createState() => _UpcommingDesignState();
}

class _UpcommingDesignState extends State<UpcommingDesign> {
  List allData = [];

  @override
  void initState() {
    for (var i = 0; i < (widget.catData as List).length; i++) {
      List dateWiseEvent = widget.catData[i]['list'];
      allData.addAll(dateWiseEvent);
    }
    // log(allData.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.title.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: List.generate(
              allData.length,
              (index) {
                Map<String, dynamic> event = allData[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                        Container(  margin:
                                       const EdgeInsets.all(2),
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
                        child: Shimmer(
                          child: GridTile(
                            child: event['image'] == null
                                ? Container(
                                    color: Colors.grey.shade100,
                                    width: 100,
                                    height: 100,
                                  )
                                : GestureDetector(
                                    child: CachedNetworkImage(
                                      imageUrl: "https://robo.itraindia.org/server/events/${event["image"]}.png",
                                      key: Key("${event["image"]}.png"),
                                      fit: BoxFit.fill,
                                      width: 95,
                                      height: 95,
                                      cacheManager: eventCacheManager,
                                      fadeInDuration: Duration.zero,
                                    ),
                                    onTap: () {
                                      
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return ImageSelection(
                                          isOtherCacheManager: false,
                                          link: "${baseLink}specialdays&id=${event['eventid']}",
                                          name: event["name"],
                                        );
                                      }));
                                    },
                                  ),
                          ),
                        ),
                      ),
                      Text(event['date'], style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                      widget.cat == "todaydesign" || widget.cat == "upcomingdesign"
                          ? SizedBox(
                              width: 100,
                              child: Text(
                                event["name"] ?? '',
                                softWrap: true,textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          : Container(),
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
