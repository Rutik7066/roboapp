import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roboapp/const.dart';
import 'package:roboapp/create_account/createaccount.dart';
import 'package:roboapp/home/home.dart';
import 'package:roboapp/intro/intro_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Lisitnening to the background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
}

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox(robobox);
  box.toMap().forEach((key, value) {
    log("$value", name: "$key");
  });

  // await box.clear();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  log((await messaging.getToken()).toString());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    PermissionStatus permisson = await Permission.storage.request();
  log("Permission storage => ${permisson.isGranted}");

  NotificationSettings settings = await messaging.requestPermission();
  log('User granted permission: ${settings.authorizationStatus}');
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(ProviderScope(observers: [Logger()], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'ITRA ROBO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.deepPurple.shade600,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(contentPadding: EdgeInsets.all(4)),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ),
      home: ValueListenableBuilder(
        valueListenable: Hive.box(robobox).listenable(),
        builder: (context, box, widget) {
          var introdone = box.get("introdone", defaultValue: false);
          var isLogedIn = box.get("isLogin", defaultValue: false);
          return isLogedIn
              ? const Home()
              : introdone
                  ? const CreateAccount()
                  : const IntroScreen();
        },
      ),
    );
  }
}

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('[${provider.name ?? provider.runtimeType}] value: $newValue');
  }
}
