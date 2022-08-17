import '../factories/cupertino_widget_factory.dart';
import '../factories/material_widget_factory.dart';
import '../interfaces/widget_factory.dart';

class WidgetFactoryProvider {
  static WidgetFactory providerCupertinoWidgetFactory() {
    return CupertinoWidgetFactory();
  }

  static WidgetFactory provideMaterialWidgetFactory() {
    return MaterialWidgetFactory();
  }
}
