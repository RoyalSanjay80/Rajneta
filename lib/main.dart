import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Pages/LocalizationService.dart';
import 'Pages/landingPage.dart';
import 'Pages/registrationPage.dart';
import 'Pages/splacePage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rajneta Election App',
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      translations: LocalizationService(),
      // Your translations
      home: Splacepage(),
    );
  }
}
