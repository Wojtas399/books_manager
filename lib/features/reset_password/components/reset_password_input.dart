import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../interfaces/factories/icon_factory.dart';
import '../../../interfaces/factories/widget_factory.dart';

class ResetPasswordInput extends StatelessWidget {
  const ResetPasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();
    final IconFactory iconFactory = context.read<IconFactory>();

    return widgetFactory.createTextFormField(
      placeholder: 'Adres email',
      icon: iconFactory.createEnvelopeIcon(),
    );
  }
}
