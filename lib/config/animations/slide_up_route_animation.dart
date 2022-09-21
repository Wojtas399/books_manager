import 'slide_route_animation.dart';

class SlideUpRouteAnimation<T> extends SlideRouteAnimation<T> {
  SlideUpRouteAnimation({
    required super.page,
    super.dx = 0,
    super.dy = 1,
  });
}
