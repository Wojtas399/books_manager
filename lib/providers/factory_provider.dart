import 'dart:io';

import '../cupertino/factories/cupertino_icon_factory.dart';
import '../cupertino/factories/cupertino_navigation_factory.dart';
import '../cupertino/factories/cupertino_widget_factory.dart';
import '../interfaces/factories/icon_factory.dart';
import '../interfaces/factories/navigation_factory.dart';
import '../interfaces/factories/widget_factory.dart';
import '../material/factories/material_icon_factory.dart';
import '../material/factories/material_navigation_factory.dart';
import '../material/factories/material_widget_factory.dart';

class FactoryProvider {
  static WidgetFactory provideWidgetFactory() {
    if (Platform.isIOS) {
      return CupertinoWidgetFactory();
    } else {
      return MaterialWidgetFactory();
    }
  }

  static IconFactory provideIconFactory() {
    if (Platform.isIOS) {
      return CupertinoIconFactory();
    }
    return MaterialIconFactory();
  }

  static NavigationFactory provideNavigationFactory() {
    if (Platform.isIOS) {
      return CupertinoNavigationFactory();
    }
    return MaterialNavigationFactory();
  }
}
