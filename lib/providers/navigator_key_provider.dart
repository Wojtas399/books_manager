import 'package:flutter/widgets.dart';

class NavigatorKeyProvider {
  static GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  static void setNewNavigatorKey() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  static GlobalKey<NavigatorState> getKey() {
    return _navigatorKey;
  }

  static BuildContext? getContext() {
    return _navigatorKey.currentContext;
  }

  static NavigatorState? getState() {
    return _navigatorKey.currentState;
  }
}
