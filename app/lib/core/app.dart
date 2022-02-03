import 'package:app/core/user/user_query.dart';
import 'package:app/repositories/book_interface.dart';
import 'package:app/config/routes/app_routes.dart';
import 'package:app/constants/route_paths/app_route_path.dart';
import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/day/day_bloc.dart';
import 'package:app/core/day/day_query.dart';
import 'package:app/core/keys.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/injection/backend_provider.dart';
import 'package:app/repositories/day_interface.dart';
import 'package:app/repositories/user/user_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _UserInterfaceProvider(
      child: _UserBlocProvider(
        child: _UserQueryProvider(
          child: _BookInterfaceProvider(
            child: _BookBlocProvider(
              child: _BookQueryProvider(
                child: _DayInterfaceProvider(
                  child: _DayBlocProvider(
                    child: _DayQueryProvider(
                      child: _NavigatorServiceProvider(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserInterfaceProvider extends StatelessWidget {
  final Widget child;

  const _UserInterfaceProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => BackendProvider.provideUserInterface(),
      child: child,
    );
  }
}

class _UserBlocProvider extends StatelessWidget {
  final Widget child;

  const _UserBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<UserBloc>(
      create: (context) => UserBloc(
        userInterface: context.read<UserInterface>(),
      )..subscribeUserData(),
      child: child,
    );
  }
}

class _BookInterfaceProvider extends StatelessWidget {
  final Widget child;

  const _BookInterfaceProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => BackendProvider.provideBookInterface(),
      child: child,
    );
  }
}

class _BookBlocProvider extends StatelessWidget {
  final Widget child;

  const _BookBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<BookBloc>(
      create: (context) => BookBloc(
        bookInterface: context.read<BookInterface>(),
      )..subscribeBooks(),
      child: child,
      dispose: (_, value) => value.dispose(),
    );
  }
}

class _DayInterfaceProvider extends StatelessWidget {
  final Widget child;

  const _DayInterfaceProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => BackendProvider.provideDayInterface(),
      child: child,
    );
  }
}

class _DayBlocProvider extends StatelessWidget {
  final Widget child;

  const _DayBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<DayBloc>(
      create: (context) => DayBloc(
        dayInterface: context.read<DayInterface>(),
      )..subscribe(),
      child: child,
      dispose: (_, value) => value.dispose(),
    );
  }
}

class _UserQueryProvider extends StatelessWidget {
  final Widget child;

  const _UserQueryProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<UserQuery>(
      create: (context) => UserQuery(
        loggedUser$: context.read<UserBloc>().loggedUser$,
      ),
      child: child,
    );
  }
}

class _BookQueryProvider extends StatelessWidget {
  final Widget child;

  const _BookQueryProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<BookQuery>(
      create: (context) => BookQuery(
        allBooks: context.read<BookBloc>().allBooks$,
      ),
      child: child,
    );
  }
}

class _DayQueryProvider extends StatelessWidget {
  final Widget child;

  const _DayQueryProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<DayQuery>(
      create: (context) => DayQuery(
        allDays: context.read<DayBloc>().allDays$,
      ),
      child: child,
    );
  }
}

class _NavigatorServiceProvider extends StatelessWidget {
  const _NavigatorServiceProvider();

  @override
  Widget build(BuildContext context) {
    Keys keys = Keys();
    AppNavigatorService navigatorService = AppNavigatorService(keys: keys);

    return Provider(
      create: (_) => navigatorService,
      child: Navigator(
        key: keys.appGlobalKey,
        initialRoute: AppRoutePath.APP,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
