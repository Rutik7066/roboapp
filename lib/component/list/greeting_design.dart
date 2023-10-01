import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roboapp/cache_confige.dart';
import 'package:roboapp/home/page/home_page/image_selection/greet_image_selection.dart';
import 'package:roboapp/const.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class GreetingDesign extends StatefulWidget {
  final cat;
  final title;
  final catData;
  const GreetingDesign({super.key, required this.cat, required this.title, required this.catData});

  @override
  State<GreetingDesign> createState() => _GreetingDesignState();
}

class _GreetingDesignState extends State<GreetingDesign> {
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
              widget.catData.length,
              (index) {
                Map<String, dynamic> event = widget.catData[index];

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
                        child: GridTile(
                          child: event['folder'] == null
                              ? Shimmer(
                                  child: Container(
                                    color: Colors.grey.shade100,
                                    width: 100,
                                    height: 100,
                                  ),
                                )
                              : GestureDetector(
                                  child: CachedNetworkImage(
                                    imageUrl: Uri.parse("https://robo.itraindia.org/server/greeting/${event["folder"]}.png").toString(),
                                    fit: BoxFit.fill,
                                    width: 100,
                                    height: 100,
                                    fadeInDuration: Duration.zero,
                                    cacheManager: otherCacheManager,
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return GreetImageSelection(
                                        link: "${baseLink}greetingList&id=${event['id']}",
                                        name: event["name"],
                                      );
                                    }));
                                  },
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          event["name"],
                          softWrap: true,textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      )
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
