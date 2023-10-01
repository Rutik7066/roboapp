import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roboapp/component/edit/general_edit/general_edit.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class GeneralText extends StatefulWidget {
  final int? trackingIndex;
  const GeneralText({this.trackingIndex, super.key});

  @override
  State<GeneralText> createState() => _GeneralTextState();
}

class _GeneralTextState extends State<GeneralText> {
  final font = StateProvider<String>((ref) {
    return "Hind-Regular";
  });

  double _top = 24;
  double _left = 24;
  double textSize = 20;
  String text = 'Text';
  Color textColor = Colors.black;
  Color pickerColor = Colors.black;
  bool show = true;
  @override
  Widget build(BuildContext context) {
    return show
        ? Positioned(
            top: _top,
            left: _left,
            child: GestureDetector(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.2),
                            offset: const Offset(0, -4), // Adjust the offset to control the shadow position
                            blurRadius: 6, // Adjust the blurRadius to control the size of the shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Seleted text $text'),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Enter the text"),
                                      onChanged: (v) {
                                        setState(() {
                                          text = v;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StatefulBuilder(builder: (context, state) {
                                return Slider(
                                  min: 10,
                                  max: 100,
                                  value: textSize,
                                onChanged: (value) {
                                    textSize = value;
                                    state(() {});
                                    setState(() {});
                                  },
                                );
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FilledButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Pick a color!'),
                                              content: SingleChildScrollView(
                                                child: ColorPicker(
                                                  pickerColor: pickerColor,
                                                  onColorChanged: (value) {
                                                    setState(() {
                                                      textColor = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: const Text('Done'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Text("Change Color"),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          final t = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Select Font'),
                                              content: Consumer(
                                                builder: (context, ref, child) {
                                                  return SingleChildScrollView(
                                                    child: ListBody(
                                                      children: fontFamilies.map((fontFamily) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            ref.read(font.notifier).state = fontFamily;
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
                                                        );
                                                      }).toList(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                            ),
                                          );
                                          log(t.toString());
                                        },
                                        child: const Text("Change Font"),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Consumer(
                              builder: (context, ref, child) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilledButton(
                                    onPressed: () {
                                      log(widget.trackingIndex.toString());
                                      setState(() {
                                        show = false;
                                      });
                                    },
                                    child: const Text("Remove")),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              onScaleUpdate: (details) {
                setState(() {
                  _left += details.focalPointDelta.dx;
                  _top += details.focalPointDelta.dy;
                });
                log("Image left : $_left, top : $_top");
              },
              child: Consumer(
                builder: (context, ref, child) {
                  return Text(
                    text,
                    style: TextStyle(
                      fontFamily: ref.watch(font),
                      fontSize: textSize,
                      color: textColor,
                    ),
                  );
                },
              ),
            ),
          )
        : Container();
  }
}
