import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../interfaces/factories/icon_factory_interface.dart';
import '../../../interfaces/factories/widget_factory_interface.dart';

class SignUpInputs extends StatelessWidget {
  const SignUpInputs({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetFactory = context.read<WidgetFactoryInterface>();
    final iconFactory = context.read<IconFactoryInterface>();
    return Column(
      children: [
        widgetFactory.createTextFormField(
          placeholder: 'Nazwa użytkownika',
          icon: iconFactory.createAccountIcon(),
        ),
        const SizedBox(height: 24.0),
        widgetFactory.createTextFormField(
          placeholder: 'Adres email',
          icon: iconFactory.createEnvelopeIcon(),
        ),
        const SizedBox(height: 24.0),
        widgetFactory.createTextFormField(
          placeholder: 'Hasło',
          icon: iconFactory.createLockIcon(),
          isPassword: true,
        ),
        const SizedBox(height: 24.0),
        widgetFactory.createTextFormField(
          placeholder: 'Powtórz hasło',
          icon: iconFactory.createLockIcon(),
          isPassword: true,
        ),
      ],
    );
  }
}