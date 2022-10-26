import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:app/features/home/bloc/home_bloc.dart';
import 'package:app/features/home/components/home_loading_screen.dart';
import 'package:app/features/home/components/home_provider.dart';
import 'package:app/features/home/components/home_router.dart';
import 'package:app/features/home/components/home_user_settings_listener.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeProvider(
      child: _HomeBlocProvider(
        child: HomeUserSettingsListener(
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
          bookInterface: context.read<BookInterface>(),
          dayInterface: context.read<DayInterface>(),
        ),
      )..add(const HomeEventInitialize()),
      child: child,
    );
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
