import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roboapp/component/edit/general_edit/general_edit.dart';

class GeneralImageFile extends StatefulWidget {
  final String path;
  const GeneralImageFile({required this.path, super.key});

  @override
  State<GeneralImageFile> createState() => _GeneralImageFileState();
}

class _GeneralImageFileState extends State<GeneralImageFile> {
  double _top = 12;
  double _left = 12;
  double scaleValue = 2;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _top,
      left: _left,
      child: GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 180,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Change Size"),
                      StatefulBuilder(builder: (context, state) {
                        return Slider(
                          min: 0,
                          max: 10,
                          value: scaleValue,
                          onChanged: (value) {
                            scaleValue = value;
                            state(() {});
                            setState(() {});
                          },
                        ); 
                      }),
                      Consumer(
                        builder: (context, ref, child) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilledButton(
                              onPressed: () {
                                List preList = ref.read(selectedImages.notifier).state;
                                preList.removeWhere((element) => element.toString().contains(widget.path));
                                ref.read(selectedImages.notifier).state = [...preList];
                              },
                              child: Text("Delete")),
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
        child: Transform.scale(
          scale: scaleValue,
          child: Image.file(
            File(widget.path),
            fit: BoxFit.contain,
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
