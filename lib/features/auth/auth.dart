import 'package:app/features/auth/auth_router.dart';
import 'package:app/features/internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return const InternetConnectionChecker(
      child: AuthRouter(),
    );
  }
}
