import 'dart:developer';
import 'dart:io';
import 'package:roboapp/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:quickalert/quickalert.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:roboapp/home/page/digital_visiting/digivisiting.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:roboapp/const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyTheme extends ConsumerStatefulWidget {
  const BuyTheme({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyThemeState();
}

class _BuyThemeState extends ConsumerState<BuyTheme> {
  List<RecordModel> selecteTheme = [];
  @override
  Widget build(BuildContext context) {
    final alltheme = ref.watch(theme);
    final user = ref.watch(userData);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy new theme"),
      ),
      body: alltheme.when(
        error: (e, e2) => Center(child: Text(e.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (themeData) {
          return user.when(
            error: (e, e2) => Center(child: Text(e.toString())),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (userdata) {
              themeData.removeWhere((element) {
                log(element.data['name'].toString());
                return (userdata!.data['purchased_theme']).contains(element.data['name']);
              });
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                          crossAxisCount: 1,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          children: themeData
                              .map((e) => InkWell(
                                    onTap: () {
                                      if (selecteTheme.contains(e)) {
                                        setState(() {
                                          selecteTheme.removeWhere((element) => e == element);
                                        });
                                      } else {
                                        setState(() {
                                          selecteTheme.add(e);
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(5)),
                                      child: GridTile(
                                          header: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: FilterChip(
                                                  label: Text(selecteTheme.contains(e) ? "Selected" : "Select"),
                                                  selected: selecteTheme.contains(e),
                                                  onSelected: (v) {
                                                    if (selecteTheme.contains(e)) {
                                                      setState(() {
                                                        selecteTheme.removeWhere((element) => e == element);
                                                      });
                                                    } else {
                                                      setState(() {
                                                        selecteTheme.add(e);
                                                      });
                                                    }
                                                  }),
                                            )
                                          ]),
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
                                  ))
                              .toList()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FilledButton.icon(
                        onPressed: () async {
                          if (selecteTheme.isEmpty) {
                            QuickAlert.show(
                              barrierDismissible: false,
                              
                              context: context,
                              type: QuickAlertType.warning,
                              text: "Select one theme to buy.",
                            );
                            return;
                          }

                          int priceOfSelecedTheme = 0;
                          for (var i = 0; i < selecteTheme.length; i++) {
                            priceOfSelecedTheme = priceOfSelecedTheme + int.parse(selecteTheme[i].data['price']);
                          }

                          Box box = Hive.box(robobox);
                          Razorpay razorpay = Razorpay();
                          var options = {
                            'key': key_id,
                            'currency': 'INR',
                            'amount': (priceOfSelecedTheme) * 100,
                            'name': 'ITRA ROBO',
                            'description': 'Purchasing Theme',
                            'retry': {'enabled': true, 'max_count': 1},
                            'send_sms_hash': true,
                            "allow_rotation": true,
                            'theme.color': '#651FFF',
                            'prefill': {'contact': box.get('business_mobile'), 'email': box.get('business_email')},
                          };
                          razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                          razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) async {
                            /*
                            * Payment Success Response contains three values:
                            * 1. Order ID
                            * 2. Payment ID
                            * 3. Signature
                            * */

                            try {
                              userdata!.data['payment_history'].add({
                                'orderId': response.orderId,
                                'paymentId': response.paymentId,
                                'signature': response.signature,
                              });

                              for (var i = 0; i < selecteTheme.length; i++) {
                                userdata.data['purchased_theme'].add(selecteTheme[i].data['name']);
                              }

                              await pb.collection('profile').update(userdata!.id, body: userdata.data);
                              if (mounted) {
                                Navigator.pop(context);
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  type: QuickAlertType.success,
                                  title: "Congratulations",
                                  widget: const Text('Theme Added Successfully'),
                                );
                              }
                            } on Exception catch (e) {
                              log("error: $e");
                              Navigator.pop(context);

                              QuickAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: QuickAlertType.error,
                                title: "Failed",
                                text: e.toString(),
                              );
                            }
                          });
                          try {
                            razorpay.open(options);
                          } catch (e) {
                            if (mounted) {
                              Navigator.pop(context);
                              QuickAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: QuickAlertType.error,
                                title: "Failed to start Gateway",
                                text: "Check internet connection.",
                              );
                            }
                          }
                        },
                        icon: const Icon(Ionicons.cart_outline),
                        label: const Text("Buy now")),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */

    QuickAlert.show(
      barrierDismissible: false,
      context: context,
      type: QuickAlertType.error,
      title: "Payment Failed",
      text: "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}",
    );
  }
}
