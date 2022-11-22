import 'package:app/components/bloc_listener_component.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_all_books_of_user_use_case.dart';
import 'package:app/features/library/bloc/library_bloc.dart';
import 'package:app/features/library/components/library_content.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        getLoggedUserIdUseCase: GetLoggedUserIdUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        getAllBooksOfUserUseCase: GetAllBooksOfUserUseCase(
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
    return BlocListenerComponent<LibraryBloc, LibraryState, dynamic, dynamic>(
      child: child,
    );
  }
}
