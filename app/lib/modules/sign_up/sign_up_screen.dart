import 'package:app/common/animations/rout_scale_animations.dart';
import 'package:app/common/ui/dialogs.dart';
import 'package:app/common/ui/snack_bars.dart';
import 'package:app/config/themes/button_theme.dart';
import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/models/operation_status.dart';
import 'package:app/core/app.dart';
import 'package:app/modules/sign_up/sign_up_bloc.dart';
import 'package:app/modules/sign_up/sign_up_event.dart';
import 'package:app/modules/sign_up/sing_up_state.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/app_bars/none_elevation_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/constants/theme.dart';
import 'package:app/modules/sign_up/elements/input.dart';
import 'elements/avatars.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _inputs = SignUpInputs();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NoneElevationAppBar(
        text: 'REJESTRACJA',
        textColor: AppColors.DARK_GREEN,
        backgroundColor: AppColors.LIGHT_GREEN,
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => SignUpBloc(
          authBloc: context.read<AuthBloc>(),
        ),
        child: Container(
          color: HexColor(AppColors.LIGHT_GREEN),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20),
              child: _registerForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerForm() {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        final signUpStatus = state.signUpStatus;
        if (signUpStatus is OperationLoading) {
          Dialogs.showLoadingDialog();
        } else if (signUpStatus is OperationSuccessful) {
          Navigator.pushAndRemoveUntil(context, ScaleRoute(page: App()),
              (Route<dynamic> route) => false);
        } else if (signUpStatus is OperationFailed) {
          Navigator.of(context).pop();
          SnackBars.showSnackBar(
            'Ups... Coś poszło nie tak. Spróbuj ponownie poźniej.',
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _inputs.username(),
            SizedBox(height: 25),
            _inputs.email(),
            SizedBox(height: 25),
            _inputs.password(),
            SizedBox(height: 25),
            _inputs.passwordConfirmation(),
            SizedBox(height: 25),
            SignUpAvatars(),
            SizedBox(height: 25),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    bool _isDisabled = true;

    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        _isDisabled = state.isDisabledButton;
      },
      builder: (context, state) {
        return ElevatedButton(
          child: Text('REJESTRUJ'),
          onPressed: _isDisabled
              ? null
              : () {
                  context.read<SignUpBloc>().add(
                        SignUpSubmitted(
                          username: state.username,
                          email: state.email,
                          password: state.password,
                          avatarType: state.avatarType,
                          customAvatarPath: state.customAvatarPath,
                        ),
                      );
                },
          style: ButtonStyles.bigButton(
            color: AppColors.DARK_GREEN2,
            context: context,
          ),
        );
      },
    );
  }
}
