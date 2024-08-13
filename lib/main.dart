import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:tiktok/app/modules/video/controllers/video_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDiPSC2S47vFkptIjK1ZIAdE-Aqp0rMs6I",
          appId: "1:1008792838890:android:802af426f4e20cfff4ad93",
          messagingSenderId: "1008792838890",
          projectId: "tiktok-7065f",
          storageBucket: "tiktok-7065f.appspot.com"
          ));
          Get.put(VideoController());
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
