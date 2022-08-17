import 'package:app/common/animations/rout_scale_animations.dart';
import 'package:app/common/ui/dialogs.dart';
import 'package:app/common/ui/snack_bars.dart';
import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/core/app.dart';
import 'package:app/modules/sign_in/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:app/models/operation_status.model.dart';
import 'package:app/modules/sign_in/sign_in_bloc.dart';
import 'package:app/modules/sign_in/sign_in_state.dart';
import 'package:app/widgets/app_bars/none_elevation_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/config/themes/app_colors.dart';

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
            child: _SignInFormStatusListener(
              formKey: _formKey,
              child: SignInForm(
                formKey: _formKey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInFormStatusListener extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Widget child;

  const _SignInFormStatusListener({required this.formKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        final signInStatus = state.signInStatus;
        if (signInStatus is OperationLoading) {
          Dialogs.showLoadingDialog();
        } else if (signInStatus is OperationSuccessful) {
          _navigateToHome(context);
        } else if (signInStatus is OperationFailed) {
          _showErrorInfo(context, signInStatus.errorMessage);
        }
      },
      child: child,
    );
  }

  _navigateToHome(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      ScaleRoute(page: App()),
      (Route<dynamic> route) => false,
    );
  }

  _showErrorInfo(BuildContext context, String message) {
    Navigator.of(context).pop();
    SnackBars.showSnackBar(message);
  }
}
