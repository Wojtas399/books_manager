import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:app/domain/use_cases/user/get_user_use_case.dart';
import 'package:app/domain/use_cases/user/load_user_use_case.dart';
import 'package:app/features/home/bloc/home_bloc.dart';
import 'package:app/features/home/components/home_loading_screen.dart';
import 'package:app/features/home/components/home_provider.dart';
import 'package:app/features/home/components/home_router.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeProvider(
      child: _HomeBlocProvider(
        child: _HomeBlocListener(
          child: _HomeView(),
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
      create: (BuildContext context) => HomeBloc(
        getLoggedUserIdUseCase: GetLoggedUserIdUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        initializeUserDataUseCase: InitializeUserDataUseCase(
          userInterface: context.read<UserInterface>(),
          bookInterface: context.read<BookInterface>(),
        ),
        loadUserUseCase: LoadUserUseCase(
          userInterface: context.read<UserInterface>(),
        ),
        getUserUseCase: GetUserUseCase(
          userInterface: context.read<UserInterface>(),
        ),
      )..add(const HomeEventInitialize()),
      child: child,
    );
  }
}

class _HomeBlocListener extends StatelessWidget {
  final Widget child;

  const _HomeBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (BuildContext context, HomeState state) {
        _onStateChanged(state, context);
      },
      child: child,
    );
  }

  void _onStateChanged(HomeState state, BuildContext context) {
    final ThemeProvider themeProvider = context.read<ThemeProvider>();
    if (state.isDarkModeCompatibilityWithSystemOn) {
      themeProvider.turnOnSystemTheme();
    } else if (state.isDarkModeOn) {
      themeProvider.turnOnDarkTheme();
    } else {
      themeProvider.turnOnLightTheme();
    }
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          return const HomeLoadingScreen();
        } else if (blocStatus is BlocStatusComplete) {
          return const HomeRouter();
        }
        return const SizedBox();
      },
    );
  }
}
