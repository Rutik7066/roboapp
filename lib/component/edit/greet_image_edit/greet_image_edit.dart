// TODO: image size and text size

import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roboapp/component/edit/greet_image_edit/component/greet_text.dart';
import 'package:roboapp/home/home.dart';
import 'package:screen_protector/screen_protector.dart';

import 'package:roboapp/utils.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:roboapp/component/frame/Frame_01.dart';
import 'package:roboapp/component/frame/Frame_02.dart';
import 'package:roboapp/component/frame/Frame_03.dart';
import 'package:roboapp/component/frame/Frame_04.dart';
import 'package:roboapp/component/frame/Frame_05.dart';
import 'package:roboapp/component/frame/Frame_06.dart';
import 'package:roboapp/component/frame/Frame_07.dart';
import 'package:roboapp/component/frame/Frame_08.dart';
import 'package:roboapp/component/frame/Frame_09.dart';
import 'package:roboapp/component/frame/Frame_10.dart';
import 'package:roboapp/const.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:roboapp/cache_confige.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final selectedFontProvider = StateProvider<String>((ref) {
  return "Hind-Light";
});
final generalTextTrackingIndex = StateProvider.autoDispose<List<GreetText>>((ref) => []);

class GreetImageEdit extends StatefulWidget {
  final String image;
  final Map data;
  final bool isFree;
  const GreetImageEdit({super.key, required this.data, required this.isFree, required this.image});

  @override
  State<GreetImageEdit> createState() => _GreetImageEditState();
}

class _GreetImageEditState extends State<GreetImageEdit> {
  List<Map<String, dynamic>> frameList = [
    {"name": "frame_d01.png", "watermark": true, "widget": Image.asset('assets/frame/frame_d01.png', width: 80, height: 80)},
    {"name": "frame_d02.png", "watermark": true, "widget": Image.asset('assets/frame/frame_d02.png', width: 80, height: 80)},
    {"name": "frame_d03.png", "watermark": true, "widget": Image.asset('assets/frame/frame_d03.png', width: 80, height: 80)},
    {"name": "frame_d04.png", "watermark": true, "widget": Image.asset('assets/frame/frame_d04.png', width: 80, height: 80)},
    {"name": "frame_d08.png", "watermark": true, "widget": Image.asset('assets/frame/frame_d08.png', width: 80, height: 80)},
    {"name": "frame_d09.png", "watermark": true, "widget": Image.asset('assets/frame/frame_d09.png', width: 80, height: 80)},
    {"name": "frame_d10.png", "watermark": true, "widget": Image.asset('assets/frame/frame_d10.png', width: 80, height: 80)},
    {"name": "frame_d05.png", "watermark": true, "widget": Image.asset('assets/frame/frame_d05.png', width: 80, height: 80)},
    {"name": "frame_d06.png", "watermark": true, "widget": Image.asset('assets/frame/frame_d06.png', width: 80, height: 80)},
    {"name": "frame_d07.png", "watermark": true, "widget": Image.asset('assets/frame/frame_d07.png', width: 80, height: 80)},
  ];
  String selectedFrame = "frame_d10.png"; // Initially select the first frame
  List<Map<String, dynamic>> extraFrame = [];

  final List<String> fontFamilies = [
    'Acmes',
    'Baloo2-Bold',
    'Baloo2-ExtraBold',
    'Baloo2-Medium',
    'Baloo2-Regular',
    'Baloo2-SemiBold',
    'BreeSerif',
    'Courgette',
    'Hind-Bold',
    'Hind-Light',
    'Hind-Medium',
    'Hind-Regular',
    'Hind-SemiBold',
    'Khand',
    'Merienda',
    'Merriweather',
    'Mitr',
    'Roboto',
    'Viga',
  ];

  final GlobalKey _globalKey = GlobalKey();
  bool showFrame = true;

  // text
  String? text;
  double textSize = 20;
  double tLeft = 25;
  double tTop = 25;
  bool _isEditing = false;
  late TextEditingController _controller;
  // logo
  bool shouldShowLogo = false;
  double _left = 12;
  double _top = 12;
  double _scale = 1.0;
  double _previousScale = 1.0;
  // image
  File? image;
  double imageHeight = 100;
  double imageTop = 50;
  double imageLeft = 50;
  double i_scale = 1.0;
  double i_previousScale = 1.0;
  Box box = Hive.box(robobox);
  @override
  void dispose() {
      if (!(box.get("business_mobile").toString().compareTo('8855850979') == 0)) {
      ScreenProtector.protectDataLeakageOff();
       ScreenProtector.preventScreenshotOff();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
print("conpairing ${!(box.get("business_mobile").toString().compareTo('8855850979') == 0)}");
    if (!(box.get("business_mobile").toString().compareTo('8855850979') == 0)) {
      ScreenProtector.protectDataLeakageOn();
      ScreenProtector.preventScreenshotOn();
    }
    _controller = TextEditingController(text: text);
    dev.log(widget.data.toString());
    imageTop = double.parse(widget.data['image_x']) / 2;
    imageLeft = double.parse(widget.data['image_y']) / 2;
    http
        .get(Uri.parse(
      "https://robo.itraindia.org/server/apknewdesignclient.php?type=getframes&clid=${box.get("clid")}",
    ))
        .then((value) {
      Map<String, dynamic> data = json.decode(value.body);
      dev.log(data.toString());
      bool watermark = data['watermark'].toString().compareTo("No") == 0 ? false : true;
      isWaterMarked = watermark;
      for (var element in data['frames']) {
        frameList.add(
          {"name": element["frame"], "watermark": watermark, "widget": CachedNetworkImage(cacheManager: eventCacheManager, imageUrl: "https://robo.itraindia.org/server/frame/${element['frame']}.png", width: 80, height: 80)},
        );
        extraFrame.add(
          {"name": element["frame"], "watermark": watermark, "widget": CachedNetworkImage(cacheManager: eventCacheManager, imageUrl: "https://robo.itraindia.org/server/frame/${element['frame']}.png", width: 80, height: 80)},
        );
        selectedFrame = element["frame"];
      }
      setState(() {});
    });
   
  }

  Widget returnFrame(Map<String, dynamic> data, List<Map<String, dynamic>> extraFrame, String selected) {
    List list = [
      {"name": "frame_d01.png", "watermark": true, "widget": Frame01(data: data)},
      {"name": "frame_d02.png", "watermark": true, "widget": Frame02(data: data)},
      {"name": "frame_d03.png", "watermark": true, "widget": Frame03(data: data)},
      {"name": "frame_d04.png", "watermark": true, "widget": Frame04(data: data)},
      {"name": "frame_d08.png", "watermark": true, "widget": Frame08(data: data)},
      {"name": "frame_d09.png", "watermark": true, "widget": Frame09(data: data)},
      {"name": "frame_d10.png", "watermark": true, "widget": Frame10(data: data)},
      {"name": "frame_d05.png", "watermark": true, "widget": Frame05(data: data)},
      {"name": "frame_d06.png", "watermark": true, "widget": Frame06(data: data)},
      {"name": "frame_d07.png", "watermark": true, "widget": Frame07(data: data)},
      ...extraFrame
    ];
    return list.firstWhere((element) => element["name"] == selected)['widget'];
  }

  Color textColor = Colors.white;
  Color pickerColor = Colors.white;
  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  bool isWaterMarked = true;
  bool freeWaterMarked = false;
  @override
  Widget build(BuildContext context) {
    Box box = Hive.box(robobox);

    return Scaffold(
      appBar: AppBar(title: const Text('ITRA ROBO')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              child: RepaintBoundary(
                key: _globalKey,
                child: Stack(children: [
                  // SizedBox for gesture detector to work properly
                  SizedBox(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                  ),
                  if (image != null)
                    Positioned(
                      top: imageTop,
                      left: imageLeft,
                      child: Transform.scale(
                        scale: i_scale,
                        child: Image.file(
                          image!,
                          height: imageHeight,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  CachedNetworkImage(
                    imageUrl: widget.image,
                    fit: BoxFit.fill,
                    cacheManager: eventCacheManager,
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                  ),
                  if (isWaterMarked)
                    Positioned.fill(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Image.asset(
                        'assets/watermark.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  if (showFrame)
                    Consumer(
                      builder: (context, ref, child) {
                        Map<String, dynamic> busData = {
                          "businessname": box.get("business_name", defaultValue: ""),
                          "mobile": box.get("business_mobile", defaultValue: ""),
                          "email": box.get("business_email", defaultValue: ""),
                          "address": box.get("business_address", defaultValue: ""),
                          "businessdetails": box.get("business_details", defaultValue: ""),
                          "textstyle": ref.watch(selectedFontProvider),
                          "show_frame": true,
                        };
                        return Positioned.fill(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          top: 0,
                          child: returnFrame(busData, extraFrame, selectedFrame),
                        );
                      },
                    ),

                  if (text != null)
                    Positioned(
                      top: tTop,
                      left: tLeft,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          dev.log("X : ${details.delta.dx}, Y : ${details.delta.dy}");
                          tTop = max(0, tTop + details.delta.dy);
                          tLeft = max(0, tLeft + details.delta.dx);
                          // dev.log("X : $_top, Y : $_left");
                          setState(() {});
                        },
                        onLongPress: () async {
                          QuickAlert.show(
                            barrierDismissible: false,
                            context: context,
                            type: QuickAlertType.custom,
                            confirmBtnText: 'Save',
                            confirmBtnColor: Colors.deepPurple.shade500,
                            widget: Column(
                              children: [
                                TextFormField(
                                  initialValue: text.toString(),
                                  onChanged: (value) => text = value,
                                  maxLines: null, // Set maxLines to null for multiline
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                          title: const Text('Pick a color!'),
                                          content: SingleChildScrollView(
                                            child: ColorPicker(
                                              pickerColor: pickerColor,
                                              onColorChanged: changeColor,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              child: const Text('Done'),
                                              onPressed: () {
                                                setState(() => textColor = pickerColor);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Text("Change Color"),
                                  ),
                                )
                              ],
                            ),
                            onConfirmBtnTap: () {
                              Navigator.pop(context);
                              setState(() {});
                            },
                          );
                        },
                        child: Consumer(
                          builder: (context, ref, child) => Text(
                            text!,
                            style: TextStyle(
                              fontSize: textSize,
                              color: textColor,
                              height: 1,
                              fontFamily: ref.watch(selectedFontProvider),
                              // height: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (shouldShowLogo)
                    Positioned(
                      top: _top,
                      left: _left,
                      child: GestureDetector(
                        onScaleStart: (details) {
                          _previousScale = _scale;
                        },
                        onScaleUpdate: (details) {
                          setState(() {
                            _scale = _previousScale * details.scale;
                            _left += details.focalPointDelta.dx;
                            _top += details.focalPointDelta.dy;
                          });
                          dev.log("scale : $_scale, left : $_left, top : $_top");
                        },
                        child: Transform.scale(
                          scale: _scale,
                          child: Image.network(
                            "https://robo.itraindia.org/server/logo/${box.get("business_image")}",
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                  if (image != null)
                    Positioned(
                      top: imageTop,
                      left: imageLeft,
                      child: GestureDetector(
                        onScaleStart: (ScaleStartDetails details) {
                          i_previousScale = i_scale;
                        },
                        onScaleUpdate: (ScaleUpdateDetails details) {
                          setState(() {
                            i_scale = i_previousScale * details.scale;
                            imageLeft += details.focalPointDelta.dx;
                            imageTop += details.focalPointDelta.dy;
                          });
                          dev.log("scale : $i_scale, left : $imageLeft, top : $imageTop");
                        },
                        child: Transform.scale(
                          scale: i_scale,
                          child: Container(
                            decoration: const BoxDecoration(backgroundBlendMode: BlendMode.dst, color: Colors.grey),
                            height: imageHeight,
                            width: imageHeight,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Consumer(
                              builder: (context, ref, child) {
                                return Stack(children: ref.watch(generalTextTrackingIndex));
                              },
                            ),
                          ),
                  // if (freeWaterMarked)
                  //   Positioned.fill(
                  //     bottom: 0,
                  //     left: 0,
                  //     right: 0,
                  //     top: 0,
                  //     child: Image.asset(
                  //       'assets/free.png',
                  //       fit: BoxFit.contain,
                  //       width: 100,
                  //       height: 100,
                  //     ),
                  //   ),
                ]),
              ),
            ),
            // Functionalty
            Container(
              color: Colors.grey.shade100,
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: frameList.reversed.map((e) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFrame = e['name'];
                          isWaterMarked = e['watermark'];
                          dev.log(selectedFrame);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        color: Colors.white,
                        child: e['widget'],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("Text"),
                      Slider(
                        value: textSize,
                        min: 0,
                        max: 100,
                        onChanged: (value) {
                          setState(() {
                            textSize = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text("Image"),
                      Slider(
                        value: imageHeight,
                        min: 0,
                        max: 200,
                        onChanged: (value) {
                          setState(() {
                            imageHeight = value;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Extra
                Expanded(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          showFrame = !showFrame;
                          setState(() {});
                        },
                        icon: Icon(Ionicons.image_outline, color: Colors.deepPurple.shade600),
                        constraints: const BoxConstraints.tightFor(
                          width: 48.0,
                          height: 48.0,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade50),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      const Text(
                        'Show/Hide Frame',
                        style: TextStyle(color: Colors.deepPurple, fontSize: 10),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          shouldShowLogo = !shouldShowLogo;
                          setState(() {});
                        },
                        icon: Icon(Ionicons.image_outline, color: Colors.deepPurple.shade600),
                        constraints: const BoxConstraints.tightFor(
                          width: 48.0,
                          height: 48.0,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade50),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      const Text(
                        'Show/Hide Logo',
                        style: TextStyle(color: Colors.deepPurple, fontSize: 10),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            File file = File(result.files.single.path.toString());
                            image = file;
                            setState(() {});
                          } else {
                            // User canceled the picker
                          }
                        },
                        icon: Icon(Ionicons.person_add_outline, color: Colors.deepPurple.shade600),
                        constraints: const BoxConstraints.tightFor(
                          width: 48.0,
                          height: 48.0,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade50),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      const Text(
                        'Add Image',
                        style: TextStyle(color: Colors.deepPurple, fontSize: 10),
                      )
                    ],
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        return IconButton(
                          onPressed: () async {
                            ref.read(generalTextTrackingIndex.notifier).state = [
                              ...ref.read(generalTextTrackingIndex.notifier).state,
                              GreetText(trackingIndex: ref.watch(generalTextTrackingIndex).length + 1),
                            ];
                          },
                          icon: Icon(Ionicons.text, color: Colors.deepPurple.shade600),
                          constraints: const BoxConstraints.tightFor(
                            width: 48.0,
                            height: 48.0,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade50),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Add Text',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 10),
                    )
                  ],
                ),
              ),
                Expanded(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => FontSelection(fontFamilies: fontFamilies),
                          );
                        },
                        icon: Icon(Ionicons.text_outline, color: Colors.deepPurple.shade600),
                        constraints: const BoxConstraints.tightFor(
                          width: 48.0,
                          height: 48.0,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade50),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      const Text(
                        'Change Font',
                        style: TextStyle(color: Colors.deepPurple, fontSize: 10),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) => Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            // if (isDemo() && !isValid()) {
                            //   QuickAlert.show(
                            //     barrierDismissible: false,
                            //     context: context,
                            //     type: QuickAlertType.warning,
                            //     title: 'Demo Expired.',
                            //     text: 'Upgrade plan to continue.',
                            //   );
                            //   return;
                            // }
                            bool dailyCount = await increaseDailyCount();
                            if (isDemo() && !dailyCount) {
                              if (mounted) {
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  type: QuickAlertType.warning,
                                  title: 'Daily Limit Exceeded.',
                                  text: 'Upgrade plan to increase limit.',
                                  confirmBtnText: "Upgrade",
                                  onConfirmBtnTap: () {
                                    Navigator.popUntil(context, ModalRoute.withName('/'));
                                    ref.read(gIndex.notifier).state = 7;
                                  },
                                );
                              }
                              return;
                            }
                            // freeWaterMarked = widget.isFree && isDemo() && !isValid();
                            // setState(() {});
                            RenderRepaintBoundary boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
                            ui.Image image = await boundary.toImage(pixelRatio: 10.0);

                            if (mounted) {
                              QuickAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: QuickAlertType.loading,
                                title: 'Loading',
                                text: 'Fetching your data',
                              );
                            }
                            ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                            if (byteData == null) return;
                            Uint8List pngBytes = byteData.buffer.asUint8List();
                            String? directory =  await getAppDir();
                            if (directory == null) return;
                            File imgFile = File("$directory/itra_${DateTime.now().microsecond}.png");
                            await imgFile.writeAsBytes(pngBytes);
                            var res = await ImageGallerySaver.saveImage(imgFile.readAsBytesSync(), quality: 60, name: "itra_${DateTime.now().microsecond}");
                            if (res['isSuccess'] == false && mounted) {
                              Navigator.pop(context);
                              QuickAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Oops...',
                                text: res.toString(),
                              );
                            }

                            if (mounted) {
                              Navigator.pop(context);
                              QuickAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Saved Successfully!',
                              );
                            }
                          },
                          icon: Icon(Ionicons.cloud_download_outline, color: Colors.deepPurple.shade600),
                          constraints: const BoxConstraints.tightFor(
                            width: 48.0,
                            height: 48.0,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade50),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                        ),
                        const Text(
                          'Download',
                          style: TextStyle(color: Colors.deepPurple, fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextButton.icon(
            //     label: const Text(
            //       'Download',
            //       style: TextStyle(color: Colors.deepPurple, fontSize: 10),
            //     ),
            //     onPressed: () async {
            //       RenderRepaintBoundary boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
            //       ui.Image image = await boundary.toImage(pixelRatio: 2.0);

            //       if (mounted) {
            //         QuickAlert.show(
            //           barrierDismissible: false,
            //           context: context,
            //           type: QuickAlertType.loading,
            //           title: 'Loading',
            //           text: 'Fetching your data',
            //         );
            //       }
            //       ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
            //       if (byteData == null) return;
            //       Uint8List pngBytes = byteData.buffer.asUint8List();
            //       String? directory = await getDownload();
            //       if (directory == null) return;
            //       File imgFile = File("$directory/itra_${DateTime.now().microsecond}.png");
            //       await imgFile.writeAsBytes(pngBytes);
            //       await GallerySaver.saveImage("$directory/itra_${DateTime.now().microsecond}.png");
            //       if (mounted) {
            //         QuickAlert.show(
            //           barrierDismissible: false,
            //           context: context,
            //           type: QuickAlertType.success,
            //           text: 'Saved Successfully!',
            //         );
            //       }
            //     },
            //     icon: Icon(Ionicons.cloud_download_outline, color: Colors.deepPurple.shade600),
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade50),
            //       shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class FontSelection extends StatefulWidget {
  final List<String> fontFamilies;
  const FontSelection({super.key, required this.fontFamilies});

  @override
  State<FontSelection> createState() => _FontSelectionState();
}

class _FontSelectionState extends State<FontSelection> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Font'),
      content: SingleChildScrollView(
        child: Consumer(
          builder: (context, ref, child) {
            return ListBody(
              children: widget.fontFamilies
                  .map((fontFamily) => GestureDetector(
                        onTap: () {
                          ref.read(selectedFontProvider.notifier).state = fontFamily;
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            fontFamily,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
