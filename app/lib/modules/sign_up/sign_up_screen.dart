import 'package:app/common/animations/rout_scale_animations.dart';
import 'package:app/common/ui/dialogs.dart';
import 'package:app/common/ui/snack_bars.dart';
import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/models/operation_status.model.dart';
import 'package:app/core/app.dart';
import 'package:app/modules/sign_up/elements/register_form.dart';
import 'package:app/modules/sign_up/sign_up_bloc.dart';
import 'package:app/modules/sign_up/sing_up_state.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/app_bars/none_elevation_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/constants/theme.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: _SignUpBlocProvider(
        child: _SignUpBlocStatusListener(
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class SignUpBlocConsumer extends StatelessWidget {
  final Function(SignUpState state) stateListener;
  final Widget Function(BuildContext context, SignUpState) builder;

  const SignUpBlocConsumer({
    required this.stateListener,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (_, state) => stateListener(state),
      builder: (context, state) => builder(context, state),
    );
  }
}

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return NoneElevationAppBar(
      text: 'REJESTRACJA',
      textColor: AppColors.DARK_GREEN,
      backgroundColor: AppColors.LIGHT_GREEN,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SignUpBlocProvider extends StatelessWidget {
  final Widget child;

  const _SignUpBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
        authBloc: context.read<AuthBloc>(),
      ),
      child: child,
    );
  }
}

class _SignUpBlocStatusListener extends StatelessWidget {
  final Widget child;

  const _SignUpBlocStatusListener({required this.child});

  @override
  Widget build(BuildContext context) {
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
      child: child,
    );
  }
}
