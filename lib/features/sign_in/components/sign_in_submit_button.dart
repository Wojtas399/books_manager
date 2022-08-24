import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_button.dart';
import '../bloc/sign_in_bloc.dart';

class SignInSubmitButton extends StatelessWidget {
  const SignInSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (SignInBloc bloc) => bloc.state.isButtonDisabled,
    );

    return CustomButton(
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
