import 'package:app/config/themes/button_theme.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/modules/sign_up/elements/inputs.dart';
import 'package:app/modules/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../sign_up_bloc.dart';
import '../sign_up_event.dart';
import '../sing_up_state.dart';
import 'avatars.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm();

  @override
  Widget build(BuildContext context) {
    return _GreenBackgroundWithScrollView(
      child: _RegisterForm(),
    );
  }
}

class _GreenBackgroundWithScrollView extends StatelessWidget {
  final Widget child;

  const _GreenBackgroundWithScrollView({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor(AppColors.LIGHT_GREEN),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: child,
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignUpUsernameInput(),
          SizedBox(height: 25),
          SignUpEmailInput(),
          SizedBox(height: 25),
          SignUpPasswordInput(),
          SizedBox(height: 25),
          SignUpPasswordConfirmationInput(),
          SizedBox(height: 25),
          SignUpAvatars(),
          SizedBox(height: 25),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    bool isDisabled = false;
    return SignUpBlocConsumer(
      stateListener: (state) {
        isDisabled = state.isDisabledButton;
      },
      builder: (context, state) {
        return ElevatedButton(
          child: Text('REJESTRUJ'),
          onPressed: isDisabled ? null : () => _submitForm(context, state),
          style: ButtonStyles.bigButton(
            color: AppColors.DARK_GREEN2,
            context: context,
          ),
        );
      },
    );
  }

  _submitForm(BuildContext context, SignUpState state) {
    context.read<SignUpBloc>().add(
          SignUpSubmitted(
            username: state.username,
            email: state.email,
            password: state.password,
            avatarType: state.avatarType,
            customAvatarPath: state.customAvatarPath,
          ),
        );
  }
}
