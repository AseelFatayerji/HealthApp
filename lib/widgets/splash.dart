import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/widgets/navbar.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: SizedBox.expand(
          child: Image.asset(
            "assets/icon/Splash_Screen.gif",
            fit: BoxFit.cover,
          ),
        ),
      ),
      splashIconSize: double.infinity,
      backgroundColor: Colors.white,
      duration: 1900,
      nextScreen: Navbar(),
    );
  }
}
