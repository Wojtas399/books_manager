import 'dart:io';

import '../cupertino/factories/cupertino_icon_factory.dart';
import '../cupertino/factories/cupertino_text_factory.dart';
import '../cupertino/factories/cupertino_widget_factory.dart';
import '../interfaces/factories/icon_factory_interface.dart';
import '../interfaces/factories/text_factory_interface.dart';
import '../interfaces/factories/widget_factory_interface.dart';
import '../material/factories/material_icon_factory.dart';
import '../material/factories/material_text_factory.dart';
import '../material/factories/material_widget_factory.dart';

class FactoryProvider {
  static WidgetFactoryInterface provideWidgetFactory() {
    if (Platform.isIOS) {
      return CupertinoWidgetFactory();
    } else {
      return MaterialWidgetFactory();
    }
  }

  static TextFactoryInterface provideTextFactory() {
    if (Platform.isIOS) {
      return CupertinoTextFactory();
    } else {
      return MaterialTextFactory();
    }
  }

  static IconFactoryInterface provideIconFactory() {
    if (Platform.isIOS) {
      return CupertinoIconFactory();
    }
    return MaterialIconFactory();
  }
}
