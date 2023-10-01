import 'dart:convert';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:roboapp/const.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class UpgradePlan extends StatefulWidget {
  const UpgradePlan({super.key});

  @override
  State<UpgradePlan> createState() => _UpgradePlanState();
}

class _UpgradePlanState extends State<UpgradePlan> {
  late Map selectedPlan;
  Box box = Hive.box(robobox);

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

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */

    try {
      Map<String, String> param = {
        "clid": box.get("clid").toString(),
        "validity": selectedPlan['validity'],
        "plan": selectedPlan['plan'],
        "planid": selectedPlan['id'],
        "order_id": response.orderId.toString(),
        "txn_amount": selectedPlan['price'] + ".00",
        "txn_id": "",
        "banktxn_id": "",
        "respcode": response.paymentId.toString(),
      };
      log(response.orderId.toString());
      log(response.paymentId.toString());
      log(response.signature.toString());
      log(param.toString());
      var request = http.MultipartRequest('POST', Uri.parse('${baseLink}savePayment'));
      request.fields.addAll(param);
      http.StreamedResponse res = await request.send();

      if (res.statusCode == 200) {
        var byteData = await res.stream.bytesToString();
        final data = jsonDecode(byteData);
        log(data.toString());
        if (mounted) {
          QuickAlert.show(
            barrierDismissible: false,
            context: context,
            type: QuickAlertType.success,
            title: "Payment Successful",
          );
          await box.put("plan", selectedPlan['plan']);
          await box.put("validity", data["validity"]);
          setState(() {});
        }
      } else {
        if (mounted) {
          QuickAlert.show(
            barrierDismissible: false,
            context: context,
            type: QuickAlertType.error,
            title: "Plan Update Failed",
            text: res.toString(),
          );
        }
      }
    } on Exception catch (e) {
      log("error: ${e}");
      QuickAlert.show(
        barrierDismissible: false,
        context: context,
        type: QuickAlertType.error,
        title: "Plan Update Failed",
        text: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: http.get(Uri.parse('${baseLink}getplan')),
        builder: (context, rec) {
          if (rec.connectionState == ConnectionState.done && rec.hasData) {
            List planList = json.decode(rec.data!.body) as List;
            log(planList.toString());

            return Scaffold(
              body: Container(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Select suitable plan to grow your business',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // constraints: const BoxConstraints.expand(),

                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: false,
                            height: double.maxFinite,
                            enlargeCenterPage: true,
                          ),
                          items: [           
                            InkWell(
                              onTap: () {
                                var plan = planList.firstWhere((element) => element['id'].toString().compareTo("1") == 0);
                                payement(plan);
                              },
                              child: Image.asset(
                                'assets/plan/1499.png',
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height * 0.80,
                                width: MediaQuery.sizeOf(context).width - 16,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var plan = planList.firstWhere((element) => element['id'].toString().compareTo("13") == 0);
                                payement(plan);
                              },
                              child: Image.asset(
                                'assets/plan/1499-12-MONTH.png',
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height * 0.80,
                                width: MediaQuery.sizeOf(context).width - 16,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var plan = planList.firstWhere((element) => element['id'].toString().compareTo("2") == 0);
                                payement(plan);
                              },
                              child: Image.asset(
                                'assets/plan/1-MONTH-199.png',
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height * 0.80,
                                width: MediaQuery.sizeOf(context).width - 16,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var plan = planList.firstWhere((element) => element['id'].toString().compareTo("3") == 0);
                                payement(plan);
                              },
                              child: Image.asset(
                                'assets/plan/3-MONTHS-799.png',
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height * 0.80,
                                width: MediaQuery.sizeOf(context).width - 16,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var plan = planList.firstWhere((element) => element['id'].toString().compareTo("4") == 0);
                                payement(plan);
                              },
                              child: Image.asset(
                                'assets/plan/6-MONTH.png',
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height * 0.80,
                                width: MediaQuery.sizeOf(context).width - 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  void payement(e) {
    selectedPlan = e;
    Razorpay razorpay = Razorpay();
    var options = {
      'key': key_id,
      'currency': 'INR',
      'amount': (int.tryParse(e['price']) ?? 0) * 100,
      'name': 'ITRA ROBO',
      'description': e['plan'],
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      "allow_rotation": true,
      'theme.color': '#651FFF',
      'prefill': {'contact': box.get('business_mobile'), 'email': box.get('business_email')},
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    try {
      razorpay.open(options);
    } catch (e) {
      QuickAlert.show(
        barrierDismissible: false,
        context: context,
        type: QuickAlertType.error,
        title: "Failed to start Gateway",
        text: "Check internet connection.",
      );
    }
  }
}
