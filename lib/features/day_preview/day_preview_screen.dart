import 'package:app/components/custom_bloc_listener.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/features/day_preview/bloc/day_preview_bloc.dart';
import 'package:app/features/day_preview/components/day_preview_content.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DayPreviewScreen extends StatelessWidget {
  final DayPreviewScreenArguments dayPreviewScreenArguments;

  const DayPreviewScreen({
    super.key,
    required this.dayPreviewScreenArguments,
  });

  @override
  Widget build(BuildContext context) {
    return _DayPreviewBlocProvider(
      date: dayPreviewScreenArguments.date,
      readBooks: dayPreviewScreenArguments.readBooks,
      child: const _DayPreviewBlocListener(
        child: DayPreviewContent(),
      ),
    );
  }
}

class DayPreviewScreenArguments extends Equatable {
  final DateTime date;
  final List<ReadBook> readBooks;

  const DayPreviewScreenArguments({
    required this.date,
    required this.readBooks,
  });

  @override
  List<Object> get props => [
        date,
        readBooks,
      ];
}

class _DayPreviewBlocProvider extends StatelessWidget {
  final Widget child;
  final DateTime date;
  final List<ReadBook> readBooks;

  const _DayPreviewBlocProvider({
    required this.child,
    required this.date,
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
          DayPreviewEventInitialize(date: date, readBooks: readBooks),
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
