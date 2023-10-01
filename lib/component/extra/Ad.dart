import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
import 'package:roboapp/cache_confige.dart';
import 'package:roboapp/const.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class Ad extends StatefulWidget {
  const Ad({super.key});

  @override
  State<Ad> createState() => _AdState();
}

class _AdState extends State<Ad> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: post(Uri.parse(adLink)),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            final List<Map<String, dynamic>> imgList = List<Map<String, dynamic>>.from(json.decode(snap.data?.body ?? ""));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  padEnds: false,
                  enableInfiniteScroll: true,
                  viewportFraction: 1,
                  height: 160,
                ),
                items: imgList
                    .map(
                      (item) => GestureDetector(
                        onTap: () async {
                          if (item['link'].toString().isNotEmpty) {
                            await launchUrl(Uri.parse(item["link"]), mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                              double width = constraints.maxWidth;
                              double height = constraints.maxHeight;
                              double aspectRatio = width / height;
                              log('width-> $width, height->$height,aspect ratio->$aspectRatio');
                              // width-> 350.8372915849355, height->152.0,aspect ratio->2.308140076216681
                              return CachedNetworkImage(
                                key: UniqueKey(),
                                imageUrl: "https://robo.itraindia.org/server/advertise/${item["image"]}.png",
                                fit: BoxFit.fill,
                                cacheManager: posterCacheManager,
                                fadeInDuration: Duration.zero,
                                errorWidget: (context, url, error) => const Icon(Ionicons.warning),
                              );
                            }),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          } else if (snap.connectionState == ConnectionState.waiting) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: Shimmer(
                    child: Container(
                  color: Colors.grey.shade100,
                  height: 160,
                )),
              ),
            );
          } else {
            return const Center(
              child: Text(
                "Something went wrong.!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            );
          }
        });
  }
}
