import 'package:flutter/widgets.dart';

import '../features/home/home.dart';
import '../features/reset_password/reset_password_screen.dart';
import '../features/sign_in/sign_in_screen.dart';
import '../features/sign_up/sign_up_screen.dart';
import '../providers/navigator_key_provider.dart';
import 'animations/slide_left_route_animation.dart';
import 'animations/slide_right_route_animation.dart';
import 'animations/slide_up_route_animation.dart';
import 'routes.dart';

class Navigation {
  static void navigateToSignInScreen() {
    final BuildContext? buildContext = _getNavigatorContext();
    if (buildContext != null) {
      Navigator.of(buildContext).pushReplacement(
        SlideRightRouteAnimation(
          page: const SignInScreen(),
        ),
      );
    }
  }

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
    Navigator.of(context).pushReplacement(
      SlideLeftRouteAnimation(
        page: const Home(),
      ),
    );
  }

  static void backHome() {
    final BuildContext? buildContext = _getNavigatorContext();
    if (buildContext != null) {
      Navigator.of(buildContext).popUntil(
        ModalRoute.withName(Routes.home),
      );
    }
  }

  static void navigateToSettings() {
    final BuildContext? buildContext = _getNavigatorContext();
    if (buildContext != null) {
      Navigator.of(buildContext).pushNamed(Routes.settings);
    }
  }

  static void navigateToBookCreator() {
    final BuildContext? buildContext = _getNavigatorContext();
    if (buildContext != null) {
      Navigator.of(buildContext).pushNamed(Routes.bookCreator);
    }
  }

  static BuildContext? _getNavigatorContext() {
    return NavigatorKeyProvider.getContext();
  }
}
