import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../interfaces/factories/widget_factory.dart';
import '../bloc/sign_in_bloc.dart';

class SignInSubmitButton extends StatelessWidget {
  const SignInSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();
    final bool isDisabled = context.select(
      (SignInBloc bloc) => bloc.state.isButtonDisabled,
    );

    return widgetFactory.createButton(
      label: 'Zaloguj',
      onPressed: isDisabled ? null : () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<SignInBloc>().add(
          SignInEventSubmit(),
        );
  }
}
