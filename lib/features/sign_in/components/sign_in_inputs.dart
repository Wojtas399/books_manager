import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../interfaces/factories/icon_factory_interface.dart';
import '../../../interfaces/factories/widget_factory_interface.dart';

class SignInInputs extends StatelessWidget {
  const SignInInputs({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetFactory = context.read<WidgetFactoryInterface>();
    final iconFactory = context.read<IconFactoryInterface>();
    return Column(
      children: [
        widgetFactory.createTextFormField(
          placeholder: 'Adres e-mail',
          icon: iconFactory.createAccountIcon(),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24.0),
        widgetFactory.createTextFormField(
          placeholder: 'Hasło',
          icon: iconFactory.createLockIcon(),
          isPassword: true,
        ),
      ],
    );
  }
}
