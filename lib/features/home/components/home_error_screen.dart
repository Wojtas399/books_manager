import 'package:app/components/custom_button_component.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeErrorScreen extends StatelessWidget {
  const HomeErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBackground,
      padding: const EdgeInsets.all(24),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Spróbuj zalogować/zarejestrować się jeszcze raz. Jeśli błąd nie zniknie musisz uzbroić się w cierpliwość. Nieustannie pracujemy nad rozwiązywaniem pojawiających się problemów. \nPrzepraszamy za niedogodności...',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.black.withOpacity(0.5),
            height: 1.4,
          ),
    );
  }
}

class _ExitButton extends StatefulWidget {
  const _ExitButton();

  @override
  State<_ExitButton> createState() => _ExitButtonState();
}

class _ExitButtonState extends State<_ExitButton> {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: 'Wróć do ekranu logowania',
      onPressed: () => _onButtonPressed(),
    );
  }

  Future<void> _onButtonPressed() async {
    await SignOutUseCase(
      authInterface: context.read<AuthInterface>(),
      bookInterface: context.read<BookInterface>(),
    ).execute();
    if (mounted) {
      context.navigateBackToSignInScreen();
    }
  }
}
