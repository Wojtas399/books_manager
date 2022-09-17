import 'package:flutter/widgets.dart';

class FadeRouteAnimation extends PageRouteBuilder {
  final Widget page;

  FadeRouteAnimation({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          pageBuilder: (_, animation, secondaryAnimation) => page,
        );
}
