import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:wellpaper/UI/const/appColor.dart';
import 'package:wellpaper/UI/const/appString.dart';
import 'package:wellpaper/UI/view/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //   apiKey: "AIzaSyBGn_FfI5r4gKbtIPc3Rsug2EQIlLEz3GQ",
  //   appId: "1:775399171427:web:7c53f0ad3421e5bcf19f56",
  //   messagingSenderId: "775399171427",
  //   projectId: "wallpaper-e3d68",
  // ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.appname,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColor.bg,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            iconSize: 30,
          )),
      home: Splash(),
    );
  }
}
