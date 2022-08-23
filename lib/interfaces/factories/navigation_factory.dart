import 'package:flutter/widgets.dart';

abstract class NavigationFactory {
  PageRoute createPageRoute({required Widget page});
}
