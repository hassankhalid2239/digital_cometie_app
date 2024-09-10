import 'dart:async';
import 'package:digital_cometie_app/Animations/fade_animation.dart';
import 'package:digital_cometie_app/Animations/fade_transitions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controller/auth_controller.dart';
import 'Auth/sign_up_screen.dart';
import 'main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  final _authController= Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    _authController.getUserData();
    isLogin();
  }
  void isLogin() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
                (route) => false);
      });
    } else {
      Future.delayed(const Duration(seconds: 2)).then((value)  {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
                (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: const Color(0xff003CBE),
          statusBarIconBrightness: Theme.of(context).brightness,
        ),
        elevation: 0,
        backgroundColor: const Color(0xff003CBE),
      ),
      backgroundColor: const Color(0xff003CBE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransAnimation(
              child: const Image(
                height: 250,
                width: 250,
                image: AssetImage('assets/images/logo.jpg'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FittedBox(
              child: FadeAnimation2(
                1,
                Text('WELCOME TO!',
                    style: GoogleFonts.lora(
                        fontWeight: FontWeight.w400,
                        fontSize: 35,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
