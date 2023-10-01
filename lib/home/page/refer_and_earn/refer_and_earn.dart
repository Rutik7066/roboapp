import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:roboapp/const.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:share_plus/share_plus.dart';
/*

 Get refferel details 
   https://robo.itraindia.org/server/apknewdesignclient.php?type=getearnings&clid=82

  {
    "earnings": [],
    "credit": "50.00",
    "debit": "0.00",
    "balance": "50.00"
  }

 */

class ReferAndEarn extends StatelessWidget {
  const ReferAndEarn({super.key});

  @override
  Widget build(BuildContext context) {
    Box box = Hive.box(robobox);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cbox = context.findRenderObject() as RenderBox?;
          Share.share(
            """
Let me recommend you this application
*ITRA ROBO* - मराठी सण-उत्सव, जयंती, पुण्यतिथी, सुविचार, प्रेरणादायी पोस्ट व्यावसायिक/ वैयक्तिक नावाने उपलब्ध
*Download Application* \n- https://play.google.com/store/apps/details?id=org.itraindia.roboapp
दोन दिवस वापरासाठी अगदी मोफत
*Enter Referal Code :- ITRACL${box.get("clid")}*
""",
            subject: "Let me recommend you this application",
            sharePositionOrigin: cbox!.localToGlobal(Offset.zero) & cbox.size,
          );
        },
        icon: const Icon(Ionicons.share_social_outline),
        label: const Text("Share"),
      ),
      body: FutureBuilder(
          future: http.get(Uri.parse("${baseLink}getearnings&clid=${box.get("clid")}")),
          builder: (context, res) {
            if (res.connectionState == ConnectionState.done) {
              Map data = json.decode(res.data!.body);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepPurple.shade500),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "₹ ${data['credit']}",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple.shade500, fontSize: 20),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text("Credit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepPurple.shade500),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "₹ ${data['debit']}",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple.shade500, fontSize: 20),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text("Debit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepPurple.shade500),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "₹ ${data['balance']}",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple.shade500, fontSize: 20),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text("Balance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      "Earnning Report",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              );
            } else {
              return Shimmer(child: Column());
            }
          }),
    );
  }
}
