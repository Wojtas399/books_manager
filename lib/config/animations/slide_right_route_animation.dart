import 'package:flutter/widgets.dart';

class SlideRightRouteAnimation<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideRightRouteAnimation({required this.page})
      : super(
          pageBuilder: (_, animation, secondaryAnimation) => page,
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.fastOutSlowIn;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}
