import 'package:app/common/animations/rout_scale_animations.dart';
import 'package:app/common/ui/dialogs.dart';
import 'package:app/common/ui/snack_bars.dart';
import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/core/app.dart';
import 'package:flutter/material.dart';
import 'package:app/config/themes/button_theme.dart';
import 'package:app/core/form_submission_status.dart';
import 'package:app/modules/sign_in/sign_in_bloc.dart';
import 'package:app/modules/sign_in/sign_in_actions.dart';
import 'package:app/modules/sign_in/sign_in_state.dart';
import 'package:app/widgets/text_fields/basic_text_form_field.dart';
import 'package:app/widgets/text_fields/password_text_form_field.dart';
import 'package:app/widgets/app_bars/none_elevation_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/constants/theme.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NoneElevationAppBar(
        text: 'LOGOWANIE',
        textColor: AppColors.DARK_GREEN,
        backgroundColor: AppColors.LIGHT_GREEN,
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => SignInBloc(
          authBloc: context.read<AuthBloc>(),
        ),
        child: Container(
          color: HexColor(AppColors.LIGHT_GREEN),
          child: Center(
            child: _loginFrom(),
          ),
        ),
      ),
    );
  }

  Widget _loginFrom() {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is FormSubmitting) {
          Dialogs.showLoadingDialog();
        } else if (formStatus is SubmissionSuccess) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            ScaleRoute(page: App()),
            (Route<dynamic> route) => false,
          );
        } else if (formStatus is SubmissionFailed) {
          Navigator.of(context).pop();
          SnackBars.showSnackBar(formStatus.exception.toString());
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _inputEmail(),
            SizedBox(height: 25),
            _inputPassword(),
            SizedBox(height: 25),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _inputEmail() {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Container(
          width: 300,
          child: BasicTextFormField(
            label: 'Adres e-mail',
            onChanged: (value) {
              context.read<SignInBloc>().add(
                    SignInEmailChanged(email: value),
                  );
            },
          ),
        );
      },
    );
  }

  Widget _inputPassword() {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Container(
          width: 300,
          child: PasswordTextFormField(
            label: 'Hasło',
            onChanged: (value) {
              context.read<SignInBloc>().add(
                    SignInPasswordChanged(password: value),
                  );
            },
          ),
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return ElevatedButton(
          child: Text('ZALOGUJ'),
          onPressed: state.isDisabledButton
              ? null
              : () {
                  context.read<SignInBloc>().add(
                        SignInSubmitted(
                          email: state.email,
                          password: state.password,
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
