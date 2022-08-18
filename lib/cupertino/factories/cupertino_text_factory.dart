import 'package:flutter/cupertino.dart';

import '../../interfaces/factories/text_factory_interface.dart';

class CupertinoTextFactory extends TextFactoryInterface {
  @override
  Widget createTitleText({
    required String text,
    required BuildContext context,
    Color? color,
  }) {
    return Text(
      text,
      style: CupertinoTheme.of(context)
          .textTheme
          .navLargeTitleTextStyle
          .copyWith(color: color),
    );
  }

  @override
  Widget createSubtitleText({
    required String text,
    required BuildContext context,
  }) {
    return Text(
      text,
      style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
    );
  }
}
