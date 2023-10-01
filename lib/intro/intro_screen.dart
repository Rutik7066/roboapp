import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:roboapp/const.dart';
import 'package:roboapp/main.dart';
import 'package:hive/hive.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    Key? key,
  }) : super(key: key);

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<ContentConfig> listContentConfig = [];

  @override
  void initState() {
    super.initState();

    listContentConfig.add(
      ContentConfig(
        pathImage: "assets/intro1L.jpg",
        widgetDescription: Image.asset("assets/intro1T.png"),
        backgroundColor: Colors.white,
      ),
    );
    listContentConfig.add(
      ContentConfig(
        pathImage: "assets/intro2L.jpg",
        widgetDescription: Image.asset("assets/intro2T.png", height: 150),
        backgroundColor: Colors.white,
      ),
    );
    listContentConfig.add(
      ContentConfig(
        pathImage: "assets/intro3L.jpg",
        widgetDescription: Image.asset("assets/intro3T.png"),
        backgroundColor: Colors.white,
      ),
    );
  }

  void onDonePress() async {
    var res = await Hive.openBox(robobox);
    res.put("introdone", true);
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: listContentConfig,
      onDonePress: onDonePress,
    );
  }
}
