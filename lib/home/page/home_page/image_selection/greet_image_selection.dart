import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:roboapp/cache_confige.dart';
import 'package:roboapp/component/edit/greet_image_edit/greet_image_edit.dart';
import 'package:roboapp/home/home.dart';
import 'package:roboapp/utils.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:quickalert/quickalert.dart';

class GreetImageSelection extends StatefulWidget {
  final String link;
  final String name;
  const GreetImageSelection({super.key, required this.name, required this.link});

  @override
  State<GreetImageSelection> createState() => _GreetImageSelectionState();
}

class _GreetImageSelectionState extends State<GreetImageSelection> {
  final langProvider = StateProvider<String>((ref) => "0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: FutureBuilder(
          future: get(Uri.parse(widget.link)),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done && snap.data != null) {
              List event = json.decode(snap.data!.body);
              log(event.toString());
              return Consumer(
                builder: (context, ref, child) {
                  final lang = ref.watch(langProvider);
                  log(lang);
                  List design = lang.contains("0") ? event : event.where((element) => element['languageid'].toString().contains(lang)).toList();
                  design.sort((a, b) {
                    // priority is given to 'isFree' (descending order)
                    int compare = int.parse(b['isFree']).compareTo(int.parse(a['isFree']));

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
                              label: const Text('All'),
                              selected: lang.contains("0"),
                              onSelected: (bool value) {
                                ref.read(langProvider.notifier).state = "0";
                              },
                            ),
                            FilterChip(
                              label: const Text('Marathi'),
                              selected: lang.contains("1"),
                              onSelected: (bool value) {
                                ref.read(langProvider.notifier).state = "1";
                              },
                            ),
                            FilterChip(
                              label: const Text('Hindi'),
                              selected: lang.contains("2"),
                              onSelected: (bool value) {
                                ref.read(langProvider.notifier).state = "2";
                              },
                            ),
                            FilterChip(
                              label: const Text('English'),
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
                              print(e);
                              return GestureDetector(
                                onTap: () async {
                                  // 0 means it is premium
                                  if (e['isFree'].toString().contains("0")  && !isValid()) {
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
                                        return GreetImageEdit(
                                          data: e,
                                          image: 'https://robo.itraindia.org/server/greeting/${e['cat_id']}/${e['image']}.png',
                                          isFree: e['isFree'].toString().contains("1"),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
margin:
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
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: 'https://robo.itraindia.org/server/greeting/${e['cat_id']}/${e['image']}.png',
                                        fit: BoxFit.cover,
                                        fadeInDuration: Duration.zero,
                                        cacheManager: otherSelectionCacheManager,
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
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                      if (e['isFree'].toString().contains("0"))
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
                                    ],
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
