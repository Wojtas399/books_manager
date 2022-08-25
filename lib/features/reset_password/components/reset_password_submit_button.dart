import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_button.dart';
import '../../../utils/utils.dart';
import '../bloc/reset_password_bloc.dart';

class ResetPasswordSubmitButton extends StatelessWidget {
  const ResetPasswordSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = context.select(
      (ResetPasswordBloc bloc) => bloc.state.isButtonDisabled,
    );

    return CustomButton(
      label: 'Wyślij',
      onPressed: isButtonDisabled ? null : () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    Utils.unfocusInputs();
    context.read<ResetPasswordBloc>().add(
          const ResetPasswordEventSubmit(),
        );
  }
}
