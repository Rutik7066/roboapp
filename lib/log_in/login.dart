import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
import 'package:roboapp/const.dart';
import 'package:roboapp/create_account/createaccount.dart';
import 'package:roboapp/home/home.dart';
import 'dart:io';
import 'package:quickalert/quickalert.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController number = TextEditingController();
  final TextEditingController otp1 = TextEditingController();
  final TextEditingController otp2 = TextEditingController();
  final TextEditingController otp3 = TextEditingController();
  final TextEditingController otp4 = TextEditingController();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  bool showOtp = false;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: media.size.width,
          height: media.size.height,
          child: Column(
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                height: media.size.width / 3,
                width: media.size.width / 3,
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  "Welcome",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  "Log in to your account.",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                width: media.size.width * 0.85,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    showOtp
                        ? Form(
                            key: formKey2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 68,
                                        width: 64,
                                        child: TextFormField(
                                          controller: otp1,
                                          onChanged: (v) {
                                            if (v.length == 1) {
                                              FocusScope.of(context).nextFocus();
                                            }
                                          },
                                          style: Theme.of(context).textTheme.headlineMedium,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 68,
                                        width: 64,
                                        child: TextFormField(
                                          controller: otp2,
                                          onChanged: (v) {
                                            if (v.length == 1) {
                                              FocusScope.of(context).nextFocus();
                                            }
                                          },
                                          style: Theme.of(context).textTheme.headlineMedium,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 68,
                                        width: 64,
                                        child: TextFormField(
                                          controller: otp3,
                                          onChanged: (v) {
                                            if (v.length == 1) {
                                              FocusScope.of(context).nextFocus();
                                            }
                                          },
                                          style: Theme.of(context).textTheme.headlineMedium,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 68,
                                        width: 64,
                                        child: TextFormField(
                                          controller: otp4,
                                          onChanged: (v) {
                                            if (v.length == 1) {
                                              FocusScope.of(context).nextFocus();
                                            }
                                          },
                                          style: Theme.of(context).textTheme.headlineMedium,
                                          decoration: const InputDecoration(border: OutlineInputBorder()),
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FilledButton(
                                    child: const Text("Log In"),
                                    onPressed: () async {
                                      print("started");
                                      if (formKey2.currentState!.validate()) {
                                        if (mounted) {
                                          QuickAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            type: QuickAlertType.loading,
                                            title: 'Loading',
                                            text: 'Fetching your data',
                                          );
                                        }
                                        final url = Uri.parse(logInLink);
                                        final otp = "${otp1.text}${otp2.text}${otp3.text}${otp4.text}";
                                        final req = MultipartRequest("POST", url);

                                        var packege = await PackageInfo.fromPlatform();

                                        Map<String, String> param = {
                                          "username": number.text,
                                          "password": otp,
                                          "osversion": Platform.operatingSystemVersion,
                                          "apilevel": Platform.operatingSystem,
                                          "device": (await DeviceInfoPlugin().androidInfo).brand,
                                          "model": (await DeviceInfoPlugin().androidInfo).model,
                                          "product": (await DeviceInfoPlugin().androidInfo).product,
                                          "manufacturer": (await DeviceInfoPlugin().androidInfo).manufacturer,
                                          'crversion': packege.buildNumber,
                                          'deviceid': (await DeviceInfoPlugin().androidInfo).id,
                                        };
                                        req.fields.addAll(param);
                                        final res = await req.send();
                                        final reqByte = await res.stream.toBytes();
                                        final resBodyUtf = utf8.decode(reqByte);
                                        Map<String, dynamic> resBody = json.decode(resBodyUtf);

                                        if (resBody["status"].toString().contains("success")) {
                                          log(resBody.toString());
                                          
                                          final Box box = Hive.box(robobox);
                                          box.put('isLogin', true);
                                          box.put('fragment', 'yes');
                                          box.put('plan', resBody['plan']);
                                          box.put('clid', int.parse(resBody["clid"]));
                                          box.put('validity', resBody["validity"]);
                                          box.put('mobile', resBody["mobile"]);
                                          box.put('email', resBody["email"]);
                                          box.put('business_name', resBody["business_name"]);
                                          box.put('business_mobile', resBody["business_mobile"]);
                                          box.put('business_email', resBody["business_email"]);
                                          box.put('business_address', resBody["business_address"]);
                                          box.put('business_image', resBody["business_image"]);
                                          box.put('business_category', resBody["business_category"]);
                                          box.put('isbusiness', resBody["isbusiness"]);
                                         if (mounted) {
                                            Navigator.pop(context);
                                            QuickAlert.show(
                                              barrierDismissible: false,
                                              context: context,
                                              type: QuickAlertType.success,
                                              text: 'Successfull.',
                                            );
                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return const Home();
                                            }));
                                          }
                                        } else if ((resBody["status"].toString().contains("loogedin"))) {
                                          if (mounted) {
                                            Navigator.pop(context);
                                            QuickAlert.show(
                                              barrierDismissible: false,
                                              context: context,
                                              type: QuickAlertType.error,
                                              title: 'Failed',
                                              text: 'Your Mobile Number is Alredy Login in Other Device, Please Contact ITRA ROBO Team.',
                                            );
                                          }
                                        } else {
                                          if (mounted) {
                                            Navigator.pop(context);

                                            QuickAlert.show(
                                              barrierDismissible: false,
                                              context: context,
                                              type: QuickAlertType.error,
                                              title: 'Failed',
                                              text: 'Please Enter Correct Details.',
                                            );
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          showOtp = false;
                                        });
                                      },
                                      child: const Text("Change Number")),
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Form(
                                key: formKey1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: number,
                                    validator: (v) {
                                      if (v == null || v.isEmpty || v.length != 10) {
                                        return 'Enter phone number.';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Ionicons.call_outline),
                                      border: OutlineInputBorder(),
                                      labelText: "Mobile Number",
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilledButton(
                                  child: const Text("Get OTP"),
                                  onPressed: () async {
                                    if (formKey1.currentState!.validate()) {
                                      formKey1.currentState!.save();

                                      if (mounted) {
                                        QuickAlert.show(
                                          barrierDismissible: false,
                                          context: context,
                                          type: QuickAlertType.loading,
                                          title: 'Loading',
                                          text: 'Fetching your data',
                                        );
                                      }
                                      final url = Uri.parse(getOtpLink);
                                      final req = MultipartRequest("POST", url);
                                      // Sending Number with Key UserName.
                                      // Bug with Backend code.
                                      req.fields.addAll({"username": number.text});
                                      var res = await req.send();
                                      if (res.statusCode >= 200 && res.statusCode < 300) {
                                        final resBodyByte = await res.stream.toBytes();
                                        final resBodyUtf = utf8.decode(resBodyByte);
                                        Map<String, dynamic> resBody = json.decode(resBodyUtf);
                                        if (resBody['status'].toString().contains("success")) {
                                          if (mounted) {
                                            Navigator.pop(context);
                                            QuickAlert.show(
                                              barrierDismissible: false,
                                              context: context,
                                              type: QuickAlertType.success,
                                              text: 'OTP Sent Successfully!',
                                              onConfirmBtnTap: () => log('OTP Sent Successfully!'),
                                            );
                                            Timer(const Duration(milliseconds: 1000), () {
                                              Navigator.pop(context);
                                              setState(() {
                                                showOtp = true;
                                              });
                                            });
                                          }
                                        } else if (resBody['status'].toString().contains("loogedin")) {
                                          //Your Mobile Number is Alredy Login in Other Device, Please Contact ITRA ROBO Team
                                          if (mounted) {
                                            Navigator.pop(context);

                                            QuickAlert.show(
                                              barrierDismissible: false,
                                              context: context,
                                              type: QuickAlertType.error,
                                              title: 'Failed',
                                              text: 'Your Mobile Number is Alredy Login in Other Device, Please Contact ITRA ROBO Team.',
                                            );
                                          }
                                        } else {
                                          //Please Enter Correct Details
                                          if (mounted) {
                                            Navigator.pop(context);

                                            QuickAlert.show(
                                              barrierDismissible: false,
                                              context: context,
                                              type: QuickAlertType.error,
                                              title: 'Failed',
                                              text: 'Please Enter Correct Details.',
                                            );
                                          }
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Or"),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text("Don't have account."),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const CreateAccount();
                            }));
                          },
                          child: const Text("Create Account")),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
