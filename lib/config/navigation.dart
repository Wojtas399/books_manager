import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../features/sign_up/sign_up_screen.dart';
import 'animations/slide_up_route_animation.dart';

class Navigation {
  static void navigateToSignUpScreen({required BuildContext context}) {
    Navigator.of(context).push(SlideUpRouteAnimation(
      page: const SignUpScreen(),
    ));
  }
}
