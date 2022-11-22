import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/initialize_books_of_user_use_case.dart';
import 'package:app/features/home/components/home_provider.dart';
import 'package:app/features/home/components/home_router.dart';
import 'package:app/features/home/components/home_user_settings_listener.dart';
import 'package:app/features/home/home_cubit.dart';
import 'package:app/features/internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeProvider(
      child: _HomeBlocProvider(
        child: HomeUserSettingsListener(
          child: InternetConnectionChecker(
            child: HomeRouter(),
          ),
        ),
      ),
    );
  }
}

class _HomeBlocProvider extends StatelessWidget {
  final Widget child;

  const _HomeBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit(
        getLoggedUserIdUseCase: GetLoggedUserIdUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        initializeBooksOfUserUseCase: InitializeBooksOfUserUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
      )..initialize(),
      child: child,
    );
  }
}
