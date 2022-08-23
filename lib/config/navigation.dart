import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/home/home.dart';
import '../features/reset_password/reset_password_screen.dart';
import '../features/sign_up/sign_up_screen.dart';
import '../interfaces/factories/navigation_factory.dart';
import 'animations/slide_up_route_animation.dart';
import 'routes.dart';

class Navigation {
  static void navigateToSignUpScreen({required BuildContext context}) {
    Navigator.of(context).push(
      SlideUpRouteAnimation(
        page: const SignUpScreen(),
      ),
    );
  }

  static void navigateToResetPasswordScreen({required BuildContext context}) {
    Navigator.of(context).push(
      SlideUpRouteAnimation(
        page: const ResetPasswordScreen(),
      ),
    );
  }

  static void navigateToHome({required BuildContext context}) {
    final NavigationFactory navigationFactory =
        context.read<NavigationFactory>();
    Navigator.of(context).pushReplacement(
      navigationFactory.createPageRoute(
        page: const Home(),
      ),
    );
  }

  static void navigateToSettings({required BuildContext context}) {
    Navigator.of(context).pushNamed(Routes.settings);
  }
}
