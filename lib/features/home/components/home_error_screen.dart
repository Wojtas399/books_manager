import 'package:app/components/custom_button.dart';
import 'package:app/config/navigation.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeErrorScreen extends StatelessWidget {
  const HomeErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBackground,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _Title(),
          SizedBox(height: 16),
          _Message(),
          SizedBox(height: 32),
          _ExitButton(),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Wystąpił nieoczekiwany błąd z ładowaniem aplikacji :(',
      style: Theme.of(context).textTheme.headline5,
    );
  }
}

class _Message extends StatelessWidget {
  const _Message();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Spróbuj zalogować/zarejestrować się jeszcze raz. Jeśli błąd nie zniknie musisz uzbroić się w cierpliwość. Nieustannie pracujemy nad naprawianiem pojawiających się problemów. \nPrzepraszamy za niedogodności...',
      style: Theme.of(context)
          .textTheme
          .subtitle1
          ?.copyWith(color: Colors.black.withOpacity(0.5)),
    );
  }
}

class _ExitButton extends StatelessWidget {
  const _ExitButton();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: 'Wróć do ekranu logowania',
      onPressed: () => _onButtonPressed(context),
    );
  }

  Future<void> _onButtonPressed(BuildContext context) async {
    await SignOutUseCase(
      authInterface: context.read<AuthInterface>(),
    ).execute();
    Navigation.navigateToSignInScreen(context: context);
  }
}
