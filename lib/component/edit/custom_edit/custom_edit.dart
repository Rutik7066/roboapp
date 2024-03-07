import 'package:flutter/material.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roboapp/component/edit/custom_edit/component/custom_image_file.dart';

import 'package:video_player/video_player.dart';
import 'package:roboapp/const.dart';
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
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:ionicons/ionicons.dart';
import 'package:roboapp/utils.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:roboapp/cache_confige.dart';
import 'package:file_picker/file_picker.dart';

final selectedFontProvider = StateProvider<String>((ref) {
  return "Hind-Regular";
});
final selectedImagesCustom = StateProvider((ref) => []);

class CustomEdit extends StatefulWidget {
  final String file;
  final String type;
  final String? date;
  const CustomEdit(
      {super.key, this.date, required this.file, required this.type});

  @override
  State<CustomEdit> createState() => _CustomEditState();
}

class _CustomEditState extends State<CustomEdit> {
  VideoPlayerController? videoPlayerController;

  @override
  void dispose() {
    if (!(box.get("business_mobile").toString().compareTo('8855850979') == 0)) {
      ScreenProtector.protectDataLeakageOff();
      ScreenProtector.preventScreenshotOff();
    }
    videoPlayerController?.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> frameList = [
    {
      "name": "frame_d01.png",
      "watermark": true,
      "widget": Image.asset('assets/frame/frame_d01.png', width: 80, height: 80)
    },
    {
      "name": "frame_d02.png",
      "watermark": true,
      "widget": Image.asset('assets/frame/frame_d02.png', width: 80, height: 80)
    },
    {
      "name": "frame_d03.png",
      "watermark": true,
      "widget": Image.asset('assets/frame/frame_d03.png', width: 80, height: 80)
    },
    {
      "name": "frame_d04.png",
      "watermark": true,
      "widget": Image.asset('assets/frame/frame_d04.png', width: 80, height: 80)
    },
    {
      "name": "frame_d08.png",
      "watermark": true,
      "widget": Image.asset('assets/frame/frame_d08.png', width: 80, height: 80)
    },
    {
      "name": "frame_d09.png",
      "watermark": true,
      "widget": Image.asset('assets/frame/frame_d09.png', width: 80, height: 80)
    },
    {
      "name": "frame_d10.png",
      "watermark": true,
      "widget": Image.asset('assets/frame/frame_d10.png', width: 80, height: 80)
    },
    {
      "name": "frame_d05.png",
      "watermark": true,
      "widget": Image.asset('assets/frame/frame_d05.png', width: 80, height: 80)
    },
    {
      "name": "frame_d06.png",
      "watermark": true,
      "widget": Image.asset('assets/frame/frame_d06.png', width: 80, height: 80)
    },
    {
      "name": "frame_d07.png",
      "watermark": true,
      "widget": Image.asset('assets/frame/frame_d07.png', width: 80, height: 80)
    },
  ];
  List<Map<String, dynamic>> extraFrame = [];

  String selectedFrame = "frame_d10.png"; // Initially select the first frame

  double _top = 12;
  double _left = 12;
  double _scale = 1.0;
  double _previousScale = 1.0;
  bool shouldShowLogo = false;
  final GlobalKey _globalKey = GlobalKey();
  Box box = Hive.box(robobox);

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

  @override
  void initState() {
    super.initState();
    print(
        "conpairing ${!(box.get("business_mobile").toString().compareTo('8855850979') == 0)}");
    if (!(box.get("business_mobile").toString().compareTo('8855850979') == 0)) {
      ScreenProtector.protectDataLeakageOn();
      ScreenProtector.preventScreenshotOn();
    }
    if (widget.type.contains('video')) {
      videoPlayerController = VideoPlayerController.file(File(widget.file));
      videoPlayerController!.addListener(() {
        setState(() {});
      });
      videoPlayerController!.setLooping(true);
      videoPlayerController!.initialize().then((_) => setState(() {}));
      videoPlayerController!.play();
    }
    http
        .get(Uri.parse(
      "https://robo.itraindia.org/server/apknewdesignclient.php?type=getframes&clid=${box.get("clid")}",
    ))
        .then((value) {
      Map<String, dynamic> data = json.decode(value.body);
      dev.log(data.toString());
      bool watermark =
          data['watermark'].toString().compareTo("No") == 0 ? false : true;

      for (var element in data['frames']) {
        frameList.add(
          {
            "name": element["frame"],
            "watermark": watermark,
            "widget": CachedNetworkImage(
                fadeInDuration: Duration.zero,
                cacheManager: eventCacheManager,
                imageUrl:
                    "https://robo.itraindia.org/server/frame/${element['frame']}.png",
                width: 80,
                height: 80)
          },
        );
        extraFrame.add(
          {
            "name": element["frame"],
            "watermark": watermark,
            "widget": CachedNetworkImage(
                fadeInDuration: Duration.zero,
                cacheManager: eventCacheManager,
                imageUrl:
                    "https://robo.itraindia.org/server/frame/${element['frame']}.png",
                width: 80,
                height: 80)
          },
        );
        selectedFrame = element["frame"];
      }
      setState(() {});
    });
  }

  Widget returnFrame(Map<String, dynamic> data,
      List<Map<String, dynamic>> extraFrame, String selected) {
    List list = [
      {
        "name": "frame_d01.png",
        "watermark": true,
        "widget": Frame01(data: data)
      },
      {
        "name": "frame_d02.png",
        "watermark": true,
        "widget": Frame02(data: data)
      },
      {
        "name": "frame_d03.png",
        "watermark": true,
        "widget": Frame03(data: data)
      },
      {
        "name": "frame_d04.png",
        "watermark": true,
        "widget": Frame04(data: data)
      },
      {
        "name": "frame_d08.png",
        "watermark": true,
        "widget": Frame08(data: data)
      },
      {
        "name": "frame_d09.png",
        "watermark": true,
        "widget": Frame09(data: data)
      },
      {
        "name": "frame_d10.png",
        "watermark": true,
        "widget": Frame10(data: data)
      },
      {
        "name": "frame_d05.png",
        "watermark": true,
        "widget": Frame05(data: data)
      },
      {
        "name": "frame_d06.png",
        "watermark": true,
        "widget": Frame06(data: data)
      },
      {
        "name": "frame_d07.png",
        "watermark": true,
        "widget": Frame07(data: data)
      },
      ...extraFrame
    ];
    return list.firstWhere((element) => element["name"] == selected)['widget'];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print("Stack: width $width");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('ITRA ROBO'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: width,
            height: width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (widget.type.contains('video'))
                  if (videoPlayerController!.value.isInitialized)
                    VideoPlayer(videoPlayerController!),
                RepaintBoundary(
                  key: _globalKey,
                  child: SizedBox(
                    width: width,
                    height: width,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        if (widget.type.contains('image'))
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Image.file(
                              File(widget.file),
                              fit: BoxFit.fill,
                              width: width,
                              height: width,
                            ),
                          ),
                        Consumer(
                          builder: (context, ref, child) {
                            Map<String, dynamic> busData = {
                              "businessname":
                                  box.get("business_name", defaultValue: ""),
                              "mobile":
                                  box.get("business_mobile", defaultValue: ""),
                              "email":
                                  box.get("business_email", defaultValue: ""),
                              "address":
                                  box.get("business_address", defaultValue: ""),
                              "businessdetails":
                                  box.get("business_details", defaultValue: ""),
                              "textstyle": ref.watch(selectedFontProvider),
                              "show_frame": true,
                            };
                            return Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              top: 0,
                              child: returnFrame(
                                  busData, extraFrame, selectedFrame),
                            );
                          },
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
                                dev.log(
                                    "scale : $_scale, left : $_left, top : $_top");
                              },
                              child: Transform.scale(
                                scale: _scale,
                                child: Image.network(
                                  "https://robo.itraindia.org/server/logo/${box.get("business_image")}",
                                  fit: BoxFit.contain,
                                  width: 100,
                                  height: 100,
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
                              List imageList = ref.watch(selectedImagesCustom);
                              return Stack(
                                children: [
                                  for (var i = 0; i < imageList.length; i++)
                                    CustomImageFile(
                                      path: imageList[i],
                                    )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                      });
                      print(selectedFrame);
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
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    shouldShowLogo = !shouldShowLogo;
                    setState(() {});
                  },
                  icon: Icon(Ionicons.image_outline,
                      color: Colors.deepPurple.shade600),
                  constraints: const BoxConstraints.tightFor(
                    width: 48.0,
                    height: 48.0,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurple.shade50),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                ),
                const Text(
                  'Show/Hide Logo',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 10),
                )
              ],
            ),
            Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return IconButton(
                      onPressed: () async {
                        FilePickerResult? res = await FilePicker.platform
                            .pickFiles(type: FileType.image);
                        if (res != null) {
                          ref
                              .read(selectedImagesCustom.notifier)
                              .state
                              .add(res.files[0].path!);
                          dev.log(ref
                              .read(selectedImagesCustom.notifier)
                              .state
                              .toSet()
                              .toString());
                          setState(() {});
                        }
                      },
                      icon: Icon(Ionicons.image_outline,
                          color: Colors.deepPurple.shade600),
                      constraints: const BoxConstraints.tightFor(
                        width: 48.0,
                        height: 48.0,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple.shade50),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                    );
                  },
                ),
                const Text(
                  'Add Image',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 10),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    final t = await showDialog(
                      context: context,
                      builder: (context) =>
                          FontSelection(fontFamilies: fontFamilies),
                    );
                    dev.log(t.toString());
                  },
                  icon: Icon(Ionicons.text_outline,
                      color: Colors.deepPurple.shade600),
                  constraints: const BoxConstraints.tightFor(
                    width: 48.0,
                    height: 48.0,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurple.shade50),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                ),
                const Text(
                  'Change Font',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 10),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    dev.log("Date:=> ${widget.date.toString().isNotEmpty}");
                    if (widget.type.contains('video')) {
                      await videoPlayerController!.pause();
                      await saveVideo();
                    } else if (widget.type.contains('image')) {
                      await saveImage();
                    }
                  },
                  icon: Icon(Ionicons.cloud_download_outline,
                      color: Colors.deepPurple.shade600),
                  constraints: const BoxConstraints.tightFor(
                    width: 48.0,
                    height: 48.0,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurple.shade50),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                ),
                const Text(
                  'Download',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 10),
                )
              ],
            ),
          ])
        ],
      ),
    );
  }

  Future<String?> saveImage() async {
    dev.log('Save Image');
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
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
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String? directory =  await getAppDir();
      File imgFile = File("$directory/itra_${DateTime.now().microsecond}.png");
      await imgFile.writeAsBytes(pngBytes);
      var res = await ImageGallerySaver.saveImage(imgFile.readAsBytesSync(),
          quality: 60, name: "itra_${DateTime.now().microsecond}");
      dev.log("image cap ended");
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

      if (mounted && widget.type.contains('image')) {
        Navigator.pop(context);
        QuickAlert.show(
          barrierDismissible: false,
          context: context,
          type: QuickAlertType.success,
          text: 'Saved Successfully.',
        );
      }
      return imgFile.path;
    } on Exception catch (e) {
      print(e);
      if (mounted && widget.type.contains('image')) {
        Navigator.pop(context);
        QuickAlert.show(
          barrierDismissible: false,
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: e.toString(),
        );
      }
      return null;
    }
  }

  Future<String?> getFrame() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 10.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    Uint8List pngBytes = byteData.buffer.asUint8List();
        String? directory = await getAppDir();
    File imgFile = File("$directory/itra_${DateTime.now().microsecond}.png");
    await imgFile.writeAsBytes(pngBytes);
    return imgFile.path;
  }

  Future<String?> downloadVideo() async {
    dev.log("video downloading started.");

    dev.log("sending video from local as bytes");
    return widget.file;
  }

  Future saveVideo() async {
    dev.log("svaing video");
    String loadingMessage = 'Saving your data';
    if (mounted) {
      QuickAlert.show(
        barrierDismissible: false,
        context: context,
        type: QuickAlertType.loading,
        title: 'Loading',
        text: loadingMessage,
      );
    }

    String? frame = await getFrame();
    String? video = await downloadVideo();
    dev.log("image : $frame");
    dev.log("video : $video");

    if (frame == null || video == null) {
      if (mounted) {
        Navigator.pop(context);
        QuickAlert.show(
          barrierDismissible: false,
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Failed to donwload video or image',
        );
      }
      return;
    }
//     if (Platform.isAndroid) {
      
//         String path =
//             "${(await getDownload())}/itra_${DateTime.now().microsecond}.mp4";
//         File outPutFile= File(path);
//         FFmpegKit.execute(getCommand(video, frame, outPutFile.path)).then((session) async{
//  final returnCode = await session.getReturnCode();
//         if (ReturnCode.isSuccess(returnCode)) {
//           bool? re = await GallerySaver.saveVideo(path);
//           if (mounted && !re!) {
//             Navigator.pop(context);
//             QuickAlert.show(
//               barrierDismissible: false,
//               context: context,
//               type: QuickAlertType.error,
//               title: 'Oops...',
//               text: 'Sorry, failed to save video in gallery',
//             );
//             return null;
//           }
//           if (mounted) {
//             Navigator.pop(context);
//             QuickAlert.show(
//               barrierDismissible: false,
//               context: context,
//               type: QuickAlertType.success,
//               text: 'Saved Successfully.',
//             );
//           }
//           dev.log('done');
//         } else if (ReturnCode.isCancel(returnCode)) {
//           if (mounted) {
//             Navigator.pop(context);
//             QuickAlert.show(
//               barrierDismissible: false,
//               context: context,
//               type: QuickAlertType.error,
//               title: 'Oops...',
//               text: 'Sorry, failed to save video.',
//             );
//             return null;
//           }
//         }
//         }).onError((error, stackTrace) {
//           print(stackTrace.toString());
//   if (mounted) {
//           Navigator.pop(context);
//           QuickAlert.show(
//             barrierDismissible: false,
//             context: context,
//             type: QuickAlertType.error,
//             title: 'Oops...',
//             text: error.toString(),
//           );
//         }
//         });
       
//     } else {
      final request = http.MultipartRequest(
          'POST', Uri.parse('https://videomerge-production.up.railway.app/merge-video'));
      request.headers
          .addAll({'Accept': '*/*', 'Content-Type': 'multipart/form-data'});
      request.files.add( await http.MultipartFile.fromPath("image", frame,
          contentType: MediaType('image', 'png')));
      request.files.add(await http.MultipartFile.fromPath('video', video,
          contentType: MediaType('video', 'mp4')));
      try {
        final streamedResponse = await request.send();
        dev.log("request sent and responcse recieved");
        if (streamedResponse.statusCode == 200) {
          try {
            final videoResponseBytes = await streamedResponse.stream.toBytes();
            print(videoResponseBytes);
            String path =
                "${(await getDownload())}/itra_${DateTime.now().microsecond}.mp4";
            final file = File(path);
            dev.log(path);
            await file.writeAsBytes(videoResponseBytes);
            var res = await GallerySaver.saveVideo(file.path);
            if (mounted && res == false) {
              Navigator.pop(context);
              QuickAlert.show(
                barrierDismissible: false,
                context: context,
                type: QuickAlertType.error,
                title: 'Oops...',
                text: 'Sorry, failed to save video in gallery',
              );
              return null;
            }
            await File(frame).delete();
            await File(video).delete();
            if (mounted) {
              Navigator.pop(context);
              QuickAlert.show(
                barrierDismissible: false,
                context: context,
                type: QuickAlertType.success,
                text: 'Saved Successfully.',
              );
            }
            dev.log('done');
          } on Exception catch (e) {
            dev.log('Error saving video code: $e');
            if (mounted) {
              Navigator.pop(context);
              QuickAlert.show(
                barrierDismissible: false,
                context: context,
                type: QuickAlertType.error,
                title: 'Oops...',
                text: e.toString(),
              );
            }
          }
        } else {
          final videoResponseBytes =
              await streamedResponse.stream.bytesToString();
          dev.log(
              'Failed proccessing video from backend ${streamedResponse.statusCode} : $videoResponseBytes');
          if (mounted) {
            Navigator.pop(context);
            QuickAlert.show(
              barrierDismissible: false,
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: videoResponseBytes,
            );
          }
        }
      } catch (e) {
        dev.log('Error sending video: $e');
        if (mounted) {
          Navigator.pop(context);
          QuickAlert.show(
            barrierDismissible: false,
            context: context,
            type: QuickAlertType.error,
            title: 'Oops...',
            text: e.toString(),
          );
        }
      }
    }
  }
// }

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
      content: Consumer(
        builder: (context, ref, child) => SingleChildScrollView(
          child: ListBody(
            children: widget.fontFamilies
                .map((fontFamily) => GestureDetector(
                      onTap: () {
                        ref.read(selectedFontProvider.notifier).state =
                            fontFamily;
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
          ),
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
