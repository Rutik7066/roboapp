import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
import 'package:roboapp/const.dart';
import 'package:roboapp/component/edit/general_edit/general_edit.dart';
import 'package:roboapp/home/home.dart';
import 'package:roboapp/utils.dart';

import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:roboapp/cache_confige.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageSelection extends StatefulWidget {
  final String link;
  final String name;
  final bool isOtherCacheManager;
  const ImageSelection(
      {super.key,
      required this.name,
      required this.link,
      required this.isOtherCacheManager});

  @override
  State<ImageSelection> createState() => _ImageSelectionState();
}

final langProvider = StateProvider<String>((ref) => "0");

class _ImageSelectionState extends State<ImageSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: FutureBuilder(
          future: get(Uri.parse(widget.link)),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done &&
                snap.data != null) {
              var event = json.decode(snap.data!.body);
              log(event.toString());
              return Consumer( 
                builder: (context, ref, child) {
                  final lang = ref.watch(langProvider);
                  log(lang);
                  List design = lang.contains("0")
                      ? event
                      : (event as List)
                          .where((element) =>
                              element['languageid'].toString().contains(lang))
                          .toList();
                  design.sort((a, b) {
                    // priority is given to 'isFree' (descending order)
                    int compare = int.parse(b['isFree'])
                        .compareTo(int.parse(a['isFree']));

                    // if 'isFree' is the same, then priority is given to 'type' where value is 'video'
                    if (compare == 0) {
                      if (a['type'] == 'video' && b['type'] != 'video') {
                        compare = -1;
                      } else if (b['type'] == 'video' && a['type'] != 'video') {
                        compare = 1;
                      } else {
                        compare = 0;
                      }
                    }

                    return compare;
                  });
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FilterChip(
                              label: Text('All'),
                              selected: lang.contains("0"),
                              onSelected: (bool value) {
                                ref.read(langProvider.notifier).state = "0";
                              },
                            ),
                            FilterChip(
                              label: Text('Marathi'),
                              selected: lang.contains("1"),
                              onSelected: (bool value) {
                                ref.read(langProvider.notifier).state = "1";
                              },
                            ),
                            FilterChip(
                              label: Text('Hindi'),
                              selected: lang.contains("2"),
                              onSelected: (bool value) {
                                ref.read(langProvider.notifier).state = "2";
                              },
                            ),
                            FilterChip(
                              label: Text('English'),
                              selected: lang.contains("3"),
                              onSelected: (bool value) {
                                ref.read(langProvider.notifier).state = "3";
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            children: design.map((e) {
                              return GestureDetector(
                                onTap: () async {
                                  // 0 means it is premium
                                  // (widget.date != null && widget.date.toString().isNotEmpty)
                                  if (e['isFree'].toString().contains("0") &&
                                     
                                      !isValid()) {
                                    if (mounted) {
                                      QuickAlert.show(
                                        barrierDismissible: false,
                                        context: context,
                                        type: QuickAlertType.warning,
                                        title: 'Upgrade plan',
                                        text: 'Upgrade plan to continue.',
                                        confirmBtnText: "Upgrade",
                                        onConfirmBtnTap: () {
                                          Navigator.popUntil(context,
                                              ModalRoute.withName('/'));
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
                                        return GeneralEdit(
                                          // NOTE -> Even if the key is "image" it can be vidoe and image.
                                          // reffer to "type" value to know it's type.
                                          file: e["type"]
                                                  .toString()
                                                  .contains('video')
                                              ? '$baseVideolink${e['src']}'
                                              : '$baseImagelink${e['image']}',
                                          type: e["type"].toString().isEmpty
                                              ? "image"
                                              : e["type"],
                                          date: e["date"],
                                          isFree: e['isFree']
                                              .toString()
                                              .contains("1"),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: GridTile(
                                  child: Container(
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
                                          offset: Offset(0,
                                              3), // Offset in x and y directions
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              '$baseImagelink${e['image']}',
                                          fit: BoxFit.cover,
                                          cacheManager:
                                              widget.isOtherCacheManager
                                                  ? otherSelectionCacheManager
                                                  : eventSelectionCacheManager,
                                          fadeOutDuration: Duration.zero,
                                        ),
                                        if (e['isFree']
                                            .toString()
                                            .contains("1"))
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            top: 0,
                                            left: 0,
                                            child: Image.asset(
                                              'assets/free.png',
                                              fit: BoxFit.contain,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                        if (e['isFree']
                                            .toString()
                                            .contains("0"))
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            left: 0,
                                            top: 0,
                                            child: Image.asset(
                                              'assets/premium.png',
                                              fit: BoxFit.contain,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                        if (e['type']
                                            .toString()
                                            .contains('video'))
                                          Positioned(
                                            bottom: 5,
                                            right: 5,
                                            child: Image.asset(
                                              'assets/vlogo.png',
                                              fit: BoxFit.contain,
                                              width: 26,
                                              height: 26,
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
          }),
    );
  }
}
