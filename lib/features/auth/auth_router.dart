import 'package:app/config/animations/slide_left_route_animation.dart';
import 'package:app/config/animations/slide_up_route_animation.dart';
import 'package:app/config/routes.dart';
import 'package:app/features/home/home.dart';
import 'package:app/features/reset_password/reset_password_screen.dart';
import 'package:app/features/sign_in/sign_in_screen.dart';
import 'package:app/features/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';

class AuthRouter extends StatelessWidget {
  const AuthRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: Routes.signIn,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.signUp:
        return SlideUpRouteAnimation(
          page: const SignUpScreen(),
        );
      case Routes.resetPassword:
        return SlideUpRouteAnimation(
          page: const ResetPasswordScreen(),
        );
      case Routes.home:
        return SlideLeftRouteAnimation(
          page: const Home(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        );
    }
  }
}
