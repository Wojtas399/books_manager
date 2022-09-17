import 'dart:typed_data';

import 'package:app/config/animations/slide_left_route_animation.dart';
import 'package:app/config/animations/slide_right_route_animation.dart';
import 'package:app/config/animations/slide_up_route_animation.dart';
import 'package:app/config/routes.dart';
import 'package:app/features/book_preview/book_preview_arguments.dart';
import 'package:app/features/home/home.dart';
import 'package:app/features/reset_password/reset_password_screen.dart';
import 'package:app/features/sign_in/sign_in_screen.dart';
import 'package:app/features/sign_up/sign_up_screen.dart';
import 'package:app/providers/navigator_key_provider.dart';
import 'package:flutter/widgets.dart';

class Navigation {
  static void moveBack() {
    _getNavigatorState()?.pop();
  }

  static void navigateToSignInScreen({BuildContext? context}) {
    final BuildContext? buildContext =
        context ?? NavigatorKeyProvider.getContext();
    if (buildContext != null) {
      Navigator.of(buildContext).pushReplacement(
        SlideRightRouteAnimation(page: const SignInScreen()),
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
      SlideUpRouteAnimation(page: const ResetPasswordScreen()),
    );
  }

  static void navigateToHome({required BuildContext context}) {
    Navigator.of(context).pushReplacement(
      SlideLeftRouteAnimation(page: const Home()),
    );
  }

  static void backHome() {
    _getNavigatorState()?.popUntil(ModalRoute.withName(Routes.home));
  }

  static void navigateToSettings() {
    _getNavigatorState()?.pushNamed(Routes.settings);
  }

  static void navigateToBookCreator() {
    _getNavigatorState()?.pushNamed(Routes.bookCreator);
  }

  static void navigateToBookPreview({
    required String bookId,
    required Uint8List? imageData,
  }) {
    _getNavigatorState()?.pushNamed(
      Routes.bookPreview,
      arguments: BookPreviewArguments(bookId: bookId, imageData: imageData),
    );
  }

  static void navigateToBookEditor({required String bookId}) {
    _getNavigatorState()?.pushNamed(Routes.bookEditor, arguments: bookId);
  }

  static NavigatorState? _getNavigatorState() {
    return NavigatorKeyProvider.getState();
  }
}
