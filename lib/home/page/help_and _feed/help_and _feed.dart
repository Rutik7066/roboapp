import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

/*
  https://wa.me/message/MZVG2LLX6QMZC1
  tel:7888101811
  https://wa.me/message/ARQDGMJBMAPVC1
  http://play.google.com/store/apps/details?id=
 */

class HelpAndfeed extends StatelessWidget {
  const HelpAndfeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(crossAxisCount: 2, children: [
        Card(
          child: InkWell(
            onTap: () async => await launchUrlString("tel:7888101811", mode: LaunchMode.externalApplication),
            child: GridTile(
              child: Image.asset(
                'assets/1.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Card(
          child: InkWell(
            onTap: () async => await launchUrlString("https://wa.link/lk73dl", mode: LaunchMode.externalApplication),
            child: GridTile(
              child: Image.asset(
                'assets/2.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Card(
          child: InkWell(
            onTap: () async => await launchUrlString("https://play.google.com/store/apps/details?id=org.itraindia.roboapp", mode: LaunchMode.externalApplication),
            child: GridTile(
              child: Image.asset(
                'assets/3.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Card(
          child: InkWell(
            onTap: () async => await launchUrlString("https://wa.link/lk73dl", mode: LaunchMode.externalApplication),
            child: GridTile(
              child: Image.asset(
                'assets/4.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
