import 'package:app/core/keys.dart';
import 'package:flutter/cupertino.dart';

class AppNavigatorService {
  Keys _keys;

  AppNavigatorService({required Keys keys}): _keys = keys;

  pushNamed({required String path, Object? arguments}) {
    BuildContext? context = _keys.appGlobalKey.currentContext;
    if (context != null) {
      Navigator.pushNamed(context, path, arguments: arguments);
    }
  }
}