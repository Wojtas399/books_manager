import 'package:flutter/material.dart';

import '../../interfaces/factories/navigation_factory.dart';

class MaterialNavigationFactory extends NavigationFactory {
  @override
  PageRoute createPageRoute({required Widget page}) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
