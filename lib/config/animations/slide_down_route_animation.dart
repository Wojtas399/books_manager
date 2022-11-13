import 'package:app/config/animations/slide_route_animation.dart';

class SlideDownRouteAnimation<T> extends SlideRouteAnimation<T> {
  SlideDownRouteAnimation({
    required super.page,
    super.dx = 0,
    super.dy = -1,
  });
}
