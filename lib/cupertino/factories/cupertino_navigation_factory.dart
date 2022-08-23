import 'package:flutter/cupertino.dart';

import '../../interfaces/factories/navigation_factory.dart';

class CupertinoNavigationFactory implements NavigationFactory {
  @override
  PageRoute createPageRoute({required Widget page}) {
    return CupertinoPageRoute(builder: (_) => page);
  }
}
