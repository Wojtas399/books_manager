import 'package:app/components/custom_bloc_listener.dart';
import 'package:app/components/custom_scaffold.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/features/day_preview/bloc/day_preview_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DayPreviewScreen extends StatelessWidget {
  final List<ReadBook> readBooks;

  const DayPreviewScreen({super.key, required this.readBooks});

  @override
  Widget build(BuildContext context) {
    return _DayPreviewBlocProvider(
      readBooks: readBooks,
      child: const _DayPreviewBlocListener(
        child: CustomScaffold(
          body: Center(
            child: Text('Day preview dialog'),
          ),
        ),
      ),
    );
  }
}

class _DayPreviewBlocProvider extends StatelessWidget {
  final Widget child;
  final List<ReadBook> readBooks;

  const _DayPreviewBlocProvider({
    required this.child,
    required this.readBooks,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DayPreviewBloc(
        getLoggedUserIdUseCase: GetLoggedUserIdUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        getBookByIdUseCase: GetBookByIdUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
      )..add(
          DayPreviewEventInitialize(readBooks: readBooks),
        ),
      child: child,
    );
  }
}

class _DayPreviewBlocListener extends StatelessWidget {
  final Widget child;

  const _DayPreviewBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomBlocListener<DayPreviewBloc, DayPreviewState, dynamic,
        dynamic>(
      child: child,
    );
  }
}
