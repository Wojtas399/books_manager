import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../interfaces/factories/widget_factory.dart';
import '../bloc/reset_password_bloc.dart';

class ResetPasswordSubmitButton extends StatelessWidget {
  const ResetPasswordSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();

    return widgetFactory.createButton(
      label: 'Wyślij',
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<ResetPasswordBloc>().add(
          ResetPasswordEventSubmit(),
        );
  }
}
