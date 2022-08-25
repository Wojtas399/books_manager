import 'package:flutter/widgets.dart';

class SlideRouteAnimation extends PageRouteBuilder {
  final Widget page;
  final double dx;
  final double dy;

  SlideRouteAnimation({
    required this.page,
    required this.dx,
    required this.dy,
  }) : super(
          pageBuilder: (_, animation, secondaryAnimation) => page,
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final begin = Offset(dx, dy);
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
