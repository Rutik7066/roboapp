import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Frame07 extends StatefulWidget {
  final Map<String, dynamic> data;
  const Frame07({super.key, required this.data});
/* {
              "image": "assets/logo.png",
              "businessname": "businessname",
              "mobile": "mobile",
              "email": "email",
              "address": "address",
              "businessdetails": "businessdetails",
            } */
  @override
  State<Frame07> createState() => _Frame07State();
}

class _Frame07State extends State<Frame07> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print("Frame: width $width");

    return SizedBox(
      width: width,
      height: width,
      child: Stack(
        children: [
          // Frame
          if (widget.data["show_frame"])
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 0,
              child: Image.asset(
                "assets/frame/frame_d07.png",
                fit: BoxFit.fill,
              ),
            ),
          // Details

          Align(
            alignment: const AlignmentDirectional(0.0, -0.96),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.data["businessname"] ?? "",
                  style: TextStyle(fontFamily: widget.data["textstyle"], fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-0.35, 0.63),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Image.asset(
                    'assets/gmail_icon.png',
                    width: 14,
                    height: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    widget.data["email"] ?? "",
                    style: TextStyle(fontFamily: widget.data["textstyle"], fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.71, 0.69),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Ionicons.call_sharp,
                  size: 10,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    "+91-${widget.data["mobile"]}",
                    style: TextStyle(fontFamily: widget.data["textstyle"], fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-1.0, 0.83),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.data["businessdetails"] ?? "",
                  style: TextStyle(
                    fontFamily: widget.data["textstyle"],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: const AlignmentDirectional(-1.0, 0.98),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.data["address"] ?? "",
                  style: TextStyle(
                    fontFamily: widget.data["textstyle"],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
