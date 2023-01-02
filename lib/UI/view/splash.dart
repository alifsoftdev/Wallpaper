import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:wellpaper/UI/view/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSplashScreen(
      duration: 3000,
      splash:Center(
        child: Image.asset(
          'assets/logo.png',
          width: 350,
        ),
      ),
      nextScreen:Home(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Color(0xff03062F),
    ));
  }
}
