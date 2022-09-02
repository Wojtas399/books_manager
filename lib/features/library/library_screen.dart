import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/custom_bloc_listener.dart';
import '../../domain/use_cases/auth/get_logged_user_id_use_case.dart';
import '../../domain/use_cases/book/get_books_by_user_id_use_case.dart';
import '../../domain/use_cases/book/load_all_books_by_user_id_use_case.dart';
import '../../interfaces/auth_interface.dart';
import '../../interfaces/book_interface.dart';
import 'bloc/library_bloc.dart';
import 'components/library_content.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LibraryBlocProvider(
      child: _LibraryBlocListener(
        child: LibraryContent(),
      ),
    );
  }
}

class _LibraryBlocProvider extends StatelessWidget {
  final Widget child;

  const _LibraryBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LibraryBloc(
        loadAllBooksByUserIdUseCase: LoadAllBooksByUserIdUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
        getLoggedUserIdUseCase: GetLoggedUserIdUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        getBooksByUserIdUseCase: GetBooksByUserIdUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
      )..add(const LibraryEventInitialize()),
      child: child,
    );
  }
}

class _LibraryBlocListener extends StatelessWidget {
  final Widget child;

  const _LibraryBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomBlocListener<LibraryBloc, LibraryState, dynamic, dynamic>(
      child: child,
    );
  }
}