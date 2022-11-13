import 'dart:typed_data';

import 'package:app/config/routes.dart';
import 'package:app/features/book_preview/book_preview_arguments.dart';
import 'package:app/features/day_preview/day_preview_screen.dart';
import 'package:flutter/widgets.dart';

extension NavigatorBuildContextExtension on BuildContext {
  void navigateBack() {
    Navigator.pop(this);
  }

  void navigateBackToSignInScreen() {
    Navigator.pushReplacementNamed(this, Routes.signIn);
  }

  void navigateToSignUpScreen() {
    Navigator.pushNamed(this, Routes.signUp);
  }

  void navigateToResetPasswordScreen() {
    Navigator.pushNamed(this, Routes.resetPassword);
  }

  void navigateToHome() {
    Navigator.pushReplacementNamed(this, Routes.home);
  }

  void navigateBackToHome() {
    Navigator.popUntil(this, ModalRoute.withName(Routes.home));
  }

  void navigateToSettings() {
    Navigator.pushNamed(this, Routes.settings);
  }

  void navigateToBookCreator() {
    Navigator.pushNamed(this, Routes.bookCreator);
  }

  void navigateToBookPreview({
    required String bookId,
    required Uint8List? imageData,
  }) {
    Navigator.pushNamed(
      this,
      Routes.bookPreview,
      arguments: BookPreviewArguments(bookId: bookId, imageData: imageData),
    );
  }

  void navigateToBookEditor({required String bookId}) {
    Navigator.pushNamed(this, Routes.bookEditor, arguments: bookId);
  }

  void navigateToDayPreview({
    required DayPreviewScreenArguments dayPreviewScreenArguments,
  }) {
    Navigator.pushNamed(
      this,
      Routes.dayPreview,
      arguments: dayPreviewScreenArguments,
    );
  }
}
