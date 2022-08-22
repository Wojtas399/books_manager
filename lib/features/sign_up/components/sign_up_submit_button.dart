import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../interfaces/factories/widget_factory.dart';
import '../bloc/sign_up_bloc.dart';

class SignUpSubmitButton extends StatelessWidget {
  const SignUpSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();
    final bool isDisabled = context.select(
      (SignUpBloc bloc) => bloc.state.isButtonDisabled,
    );

    return widgetFactory.createButton(
      label: 'Zarejestruj',
      onPressed: isDisabled ? null : () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventSubmit(),
        );
  }
}
