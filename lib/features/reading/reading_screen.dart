import 'package:app/components/bloc_listener_component.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_user_books_in_progress_use_case.dart';
import 'package:app/features/reading/bloc/reading_bloc.dart';
import 'package:app/features/reading/components/reading_content.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ReadingBlocProvider(
      child: _ReadingBlocListener(
        child: ReadingContent(),
      ),
    );
  }
}

class _ReadingBlocProvider extends StatelessWidget {
  final Widget child;

  const _ReadingBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ReadingBloc(
        getLoggedUserIdUseCase: GetLoggedUserIdUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        getUserBooksInProgressUseCase: GetUserBooksInProgressUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
      )..add(const ReadingEventInitialize()),
      child: child,
    );
  }
}

class _ReadingBlocListener extends StatelessWidget {
  final Widget child;

  const _ReadingBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListenerComponent<ReadingBloc, ReadingState, dynamic, dynamic>(
      child: child,
    );
  }
}
