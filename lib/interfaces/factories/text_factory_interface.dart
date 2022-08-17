import 'package:flutter/widgets.dart';

abstract class TextFactoryInterface {
  Widget createTitleText({
    required String text,
    required BuildContext context,
    Color? color,
  });
}
