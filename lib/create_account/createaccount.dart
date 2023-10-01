import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:roboapp/const.dart';
import 'package:roboapp/log_in/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:hive/hive.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController name = TextEditingController();
  final TextEditingController number = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController reff = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Create Your Account",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: media.size.width * 0.85,
                padding: const EdgeInsets.all(8),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: name,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Enter your name.";
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(prefixIcon: Icon(Ionicons.person_outline), border: OutlineInputBorder(), labelText: "Name"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: number,
                            validator: (v) {
                              if (v == null || v.isEmpty || v.length != 10) {
                                return "Enter your number.";
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(prefixIcon: Icon(Ionicons.call_outline), border: OutlineInputBorder(), labelText: "Number"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: email,
                            validator: (v) {
                              if (v == null || v.isEmpty || !v.contains("@") || !v.contains(".")) {
                                return "Enter your email.";
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(prefixIcon: Icon(Ionicons.mail_outline), border: OutlineInputBorder(), labelText: "Email"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: reff,
                            validator: (v) {},
                            decoration: const InputDecoration(prefixIcon: Icon(Ionicons.share_social_outline), border: OutlineInputBorder(), labelText: "Refferal Code"),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FilledButton(
                                child: const Text("Sign up"),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (_) {
                                          return const ProDialog(reqResult: "Loading", message: '');
                                        });
                                    var url = Uri.parse(createAccountLink);
                                    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
                                    final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
                                    Map<String, String> body = {
                                      'mobile': number.value.text,
                                      'email': email.value.text,
                                      'name': name.value.text,
                                      'refer_code': reff.value.text,
                                      'osversion': await SystemChannels.platform.invokeMethod<String>('SystemNavigator.userAgent') ?? "",
                                      'apilevel': await DeviceInfoPlugin().androidInfo.then((androidInfo) => androidInfo.version.sdkInt.toString()),
                                      'device': await DeviceInfoPlugin().androidInfo.then((androidInfo) => androidInfo.brand),
                                      'model': await DeviceInfoPlugin().androidInfo.then((androidInfo) => androidInfo.model),
                                      'product': await DeviceInfoPlugin().androidInfo.then((androidInfo) => androidInfo.product),
                                      'manufacturer': await DeviceInfoPlugin().androidInfo.then((androidInfo) => androidInfo.manufacturer),
                                      'crversion': androidInfo.version.release,
                                      'deviceid': androidInfo.id,
                                    };

                                    var req = http.MultipartRequest('POST', url);
                                    req.fields.addAll(body);
                                    var res = await req.send();
                                    if (res.statusCode >= 200 && res.statusCode < 300) {
                                      final resBodyByte = await res.stream.toBytes();
                                      final resBodyUtf = utf8.decode(resBodyByte);
                                      log(resBodyUtf.toString());
                                      Map<String, dynamic> resBody = json.decode(resBodyUtf);
                                      if (resBody['status'].toString().contains("register")) {
                                        if (mounted) {
                                          Navigator.of(context).pop();
                                          showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (_) {
                                                return const ProDialog(
                                                  reqResult: "Failed",
                                                  message: 'Number Alredy Registered.',
                                                );
                                              });
                                        }
                                        return;
                                      }

                                      final Box box2 = await Hive.openBox(robobox);
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
                                        Navigator.of(context).pop();
                                        showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (_) {
                                              return const ProDialog(
                                                reqResult: "Succefull",
                                                message: 'Account created succefully.',
                                              );
                                            });
                                      }

                                      Timer(const Duration(seconds: 2), () {
                                        Navigator.of(context).pop();
                                      });
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return const Login();
                                      }));
                                    } else {
                                      if (mounted) {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (_) {
                                              return const ProDialog(
                                                reqResult: "Failed",
                                                message: 'Failed to create account.',
                                              );
                                            });
                                      }
                                    }
                                  }
                                })),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
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
                        const Text("Already have account."),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const Login();
                              }));
                            },
                            child: const Text("Log In"),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProDialog extends StatefulWidget {
  const ProDialog({
    super.key,
    required this.reqResult,
    required this.message,
  });

  final String reqResult;
  final String message;

  @override
  State<ProDialog> createState() => _ProDialogState();
}

class _ProDialogState extends State<ProDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // The background color
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.reqResult == "Loading")
              const CircularProgressIndicator()
            else if (widget.reqResult == "Succefull")
              const Icon(
                Ionicons.checkmark_circle_outline,
                color: Colors.green,
                size: 50,
              )
            else if (widget.reqResult == "Failed")
              const Icon(
                Ionicons.close_circle_outline,
                color: Colors.red,
                size: 50,
              ),
            const SizedBox(
              height: 15,
            ),
            if (widget.reqResult == "Loading") const Text("Loading...") else if (widget.reqResult == "Succefull") const Text("Account Created Succefully.") else if (widget.reqResult == "Failed") Text(widget.message),
          ],
        ),
      ),
    );
  }
}
