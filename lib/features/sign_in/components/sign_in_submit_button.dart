import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../interfaces/factories/widget_factory_interface.dart';

class SignInSubmitButton extends StatelessWidget {
  const SignInSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetFactory = context.read<WidgetFactoryInterface>();
    return widgetFactory.createButton(
      onPressed: () {},
      text: 'Zaloguj',
    );
  }
}