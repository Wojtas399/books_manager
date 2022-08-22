import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../interfaces/factories/icon_factory_interface.dart';
import '../../../interfaces/factories/widget_factory_interface.dart';

class ResetPasswordInput extends StatelessWidget {
  const ResetPasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactoryInterface widgetFactory =
        context.read<WidgetFactoryInterface>();
    final IconFactoryInterface iconFactory =
        context.read<IconFactoryInterface>();
    return widgetFactory.createTextFormField(
      placeholder: 'Adres email',
      icon: iconFactory.createEnvelopeIcon(),
    );
  }
}
