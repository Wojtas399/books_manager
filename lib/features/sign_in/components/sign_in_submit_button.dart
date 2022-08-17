import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../interfaces/factories/widget_factory_interface.dart';
import '../bloc/sign_in_bloc.dart';

class SignInSubmitButton extends StatelessWidget {
  const SignInSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetFactory = context.read<WidgetFactoryInterface>();
    final bool isDisabled = context.select(
      (SignInBloc bloc) => bloc.state.isButtonDisabled,
    );
    return widgetFactory.createButton(
      onPressed: isDisabled ? null : () => _onPressed(context),
      text: 'Zaloguj',
    );
  }

  void _onPressed(BuildContext context) {
    context.read<SignInBloc>().add(
          SignInEventSubmit(),
        );
  }
}
