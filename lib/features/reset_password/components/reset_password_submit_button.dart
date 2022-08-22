import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../interfaces/factories/widget_factory_interface.dart';

class ResetPasswordSubmitButton extends StatelessWidget {
  const ResetPasswordSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactoryInterface widgetFactory =
        context.read<WidgetFactoryInterface>();
    return widgetFactory.createButton(
      label: 'Wyślij',
      onPressed: () {},
    );
  }
}
