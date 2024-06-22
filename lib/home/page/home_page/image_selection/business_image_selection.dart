import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quickalert/quickalert.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
import 'package:roboapp/const.dart';
import 'package:roboapp/component/edit/general_edit/general_edit.dart';
import 'package:roboapp/home/home.dart';
import 'package:roboapp/home/page/home_page/image_selection/image_selection.dart';
import 'package:roboapp/utils.dart';

import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:roboapp/cache_confige.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BusinessImageSelection extends StatefulWidget {
  final bool isOtherCacheManager;
  const BusinessImageSelection({super.key, required this.isOtherCacheManager});

  @override
  State<BusinessImageSelection> createState() => _BusinessImageSelectionState();
}

final langProvider = StateProvider<String>((ref) => "0");

class _BusinessImageSelectionState extends State<BusinessImageSelection> {
  @override
  Widget build(BuildContext context) {
    Box box = Hive.box(robobox);
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Business Design"),
      ),
      body: FutureBuilder(
          future: get(Uri.parse('https://robo.itraindia.org/designnewapi/user/businesscategory')),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done && snap.hasData) {
              var cat = json.decode(snap.data!.body);
              log(cat.toString());
              return Consumer(builder: (context, ref, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: 150,
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: cat.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder(
                          future: get(Uri.parse("https://robo.itraindia.org/designnewapi/user/businesslist1?business_category=${cat[index]['id']}&res=1")),
                          builder: (context, conn) {
                            if (conn.connectionState == ConnectionState.done || conn.hasData) {
                              Map e = json.decode(conn.data!.body)[0];
                              log(cat[index]['category']);
                              return GestureDetector(
                                onTap: () async {
                                  // 0 means it is premium
                                  if (e['isFree'].toString().contains("0") && !isValid()) {
                                    if (mounted) {
                                      QuickAlert.show(
                                        barrierDismissible: false,
                                        context: context,
                                        type: QuickAlertType.warning,
                                        title: 'Upgrade plan',
                                        text: 'Upgrade plan to continue.',
                                        confirmBtnText: "Upgrade",
                                        onConfirmBtnTap: () {
                                          Navigator.popUntil(context, ModalRoute.withName('/'));
                                          ref.read(gIndex.notifier).state = 7;
                                        },
                                      );
                                    }
                                    return;
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        print(e);
                                        return ImageSelection(
                                          isOtherCacheManager: true,
                                          link: "https://robo.itraindia.org/designnewapi/user/businesslist?business_category=${e['categoryid']}",
                                          name: e['category'],
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: GridTile(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10), // Add BorderRadius here
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5), // Shadow color
                                              spreadRadius: 4, // Spread radius
                                              blurRadius: 5, // Blur radius
                                              offset: const Offset(0, 3), // Offset in x and y directions
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: '$baseImagelink${e['image']}',
                                              fit: BoxFit.cover,
                                              cacheManager: widget.isOtherCacheManager ? otherSelectionCacheManager : eventSelectionCacheManager,
                                              fadeOutDuration: Duration.zero,
                                            ),
                                            if (e['isFree'].toString().contains("1"))
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                top: 0,
                                                left: 0,
                                                child: Image.asset(
                                                  'assets/free.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            if (e['isFree'].toString().contains("0"))
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                left: 0,
                                                top: 0,
                                                child: Image.asset(
                                                  (e['type'].toString().contains('video')) ? 'assets/vlogo.png' : 'assets/premium.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            // if (e['type']
                                            //     .toString()
                                            //     .contains('video'))
                                            //   Positioned(
                                            //     bottom: 5,
                                            //     right: 5,
                                            //     child: Image.asset(
                                            //       'assets/vlogo.png',
                                            //       fit: BoxFit.contain,
                                            //       width: 26,
                                            //       height: 26,
                                            //     ),
                                            //   ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        cat[index]['category'],
                                        softWrap: true,
                                        style: const TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          });
                    },
                  ),
                );
              });
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
          }),
    );
  }
}
