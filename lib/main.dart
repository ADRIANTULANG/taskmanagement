// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tm/services/getstorage_services.dart';
import 'package:tm/services/notification_services.dart';
import 'package:tm/src/chat_screen/controller/chat_controller.dart';
// import 'package:tm/services/notification_services.dart';

import 'src/splash_screen/view/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Get.put(StorageServices());
  await Get.put(NotificationServices());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      print("App is Detached");
    } else if (state == AppLifecycleState.paused) {
      print("App is Paused");
    } else if (state == AppLifecycleState.resumed) {
      print("App is Resumed");
      if (Get.find<StorageServices>().storage.read('id') != null) {
        if (Get.isRegistered<ChatController>() == true) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(Get.find<StorageServices>().storage.read('id'))
              .update({"isonline": true});
        }
      }
    } else if (state == AppLifecycleState.inactive) {
      print("App is Inactive");
      if (Get.find<StorageServices>().storage.read('id') != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(Get.find<StorageServices>().storage.read('id'))
            .update({"isonline": false});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Collab & Share',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: SplashView(),
      );
    });
  }
}
