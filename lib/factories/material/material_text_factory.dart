import 'package:flutter/material.dart';

import '../../interfaces/factories/text_factory_interface.dart';

class MaterialTextFactory implements TextFactoryInterface {
  @override
  Widget createTitleText({
    required String text,
    required BuildContext context,
    Color? color,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4?.copyWith(color: color),
    );
  }
}
