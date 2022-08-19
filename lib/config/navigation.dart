import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../features/home/home.dart';
import '../features/sign_up/sign_up_screen.dart';
import 'animations/slide_up_route_animation.dart';

class Navigation {
  static void navigateToSignUpScreen({required BuildContext context}) {
    Navigator.of(context).push(
      SlideUpRouteAnimation(
        page: const SignUpScreen(),
      ),
    );
  }

  static void navigateToHome({required BuildContext context}) {
    Navigator.of(context).pushReplacement(
      _getAppropriatePlatformRoute(const Home()),
    );
  }

  static PageRoute _getAppropriatePlatformRoute(Widget page) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (_) => page);
    }
    return MaterialPageRoute(builder: (_) => page);
  }
}
