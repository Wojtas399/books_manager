import 'package:app/constants/route_paths/start_route_path.dart';
import 'package:app/modules/sign_in/sign_in_screen.dart';
import 'package:app/modules/sign_up/sign_up_screen.dart';
import 'package:app/modules/start/start_screen.dart';
import 'package:flutter/material.dart';

class StartRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case StartRoutePath.START:
        return MaterialPageRoute(builder: (_) => StartScreen());
      case StartRoutePath.SIGN_IN:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case StartRoutePath.SIGN_UP:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      default:
        return MaterialPageRoute(builder: (_) => StartScreen());
    }
  }
}