import 'dart:developer';
import 'package:roboapp/provider.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class ShareTheme extends ConsumerStatefulWidget {
  const ShareTheme({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShareThemeState();
}

class _ShareThemeState extends ConsumerState<ShareTheme> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userData);
    final alltheme = ref.watch(theme);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Digital Card"),
      ),
      body: user.when(
        error: (e, e2) => Center(child: Text(e.toString())),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        data: (userdata) {
          return alltheme.when(
            data: (themedata) {
              List<RecordModel> themetoshare = themedata.where((element) {
                log(element.data['name'].toString());
                return (userdata!.data['purchased_theme']).contains(element.data['name']);
              }).toList();
              return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: themetoshare.map((e) {
                    return InkWell(
                      onTap: () {
                        final cbox = context.findRenderObject() as RenderBox?;
                        Share.share(
                          "https://robo.itraindia.org/digicard?pro=${userdata!.id}&theme=${e.data["name"]}",
                          subject: "Hello ! this is my digital visiting card made by ITRA ROBO",
                          sharePositionOrigin: cbox!.localToGlobal(Offset.zero) & cbox.size,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(5)),
                        child: GridTile(
                            child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                'http://ec2-13-200-79-156.ap-south-1.compute.amazonaws.com:5001/api/files/theme/${e.id}/${e.data['image']}?thumb=50x50',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e.data['name']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("₹ ${e.data['price']}"),
                                )
                              ],
                            )
                          ],
                        )),
                      ),
                    );
                  }).toList());
            },
            error: (e, e2) => Center(child: Text(e.toString())),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
