import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/custom_text_field_component.dart';
import '../bloc/reset_password_bloc.dart';

class ResetPasswordInput extends StatelessWidget {
  const ResetPasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Adres email',
      iconData: MdiIcons.email,
      onChanged: (String email) => _onEmailChanged(email, context),
    );
  }

  void _onEmailChanged(String email, BuildContext context) {
    context.read<ResetPasswordBloc>().add(
          ResetPasswordEventEmailChanged(email: email),
        );
  }
}
