import 'package:app/components/bloc_listener_component.dart';
import 'package:app/config/navigation.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/add_book_use_case.dart';
import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:app/features/book_creator/components/book_creator_content.dart';
import 'package:app/features/home/bloc/home_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookCreatorScreen extends StatelessWidget {
  const BookCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BookCreatorBlocProvider(
      child: _BookCreatorBlocListener(
        child: BookCreatorContent(),
      ),
    );
  }
}

class _BookCreatorBlocProvider extends StatelessWidget {
  final Widget child;

  const _BookCreatorBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookCreatorBloc(
        getLoggedUserIdUseCase: GetLoggedUserIdUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        addBookUseCase: AddBookUseCase(
          bookInterface: context.read<BookInterface>(),
        ),
      ),
      child: child,
    );
  }
}

class _BookCreatorBlocListener extends StatelessWidget {
  final Widget child;

  const _BookCreatorBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListenerComponent<BookCreatorBloc, BookCreatorState,
        BookCreatorBlocInfo, dynamic>(
      onCompletionInfo: (BookCreatorBlocInfo info) => _manageBlocInfo(
        info,
        context,
      ),
      child: child,
    );
  }

  void _manageBlocInfo(BookCreatorBlocInfo info, BuildContext context) {
    switch (info) {
      case BookCreatorBlocInfo.bookHasBeenAdded:
        _onBookHasBeenAdded(context);
        break;
    }
  }

  void _onBookHasBeenAdded(BuildContext context) {
    context.read<DialogInterface>().showSnackBar(
          message: 'Pomyślnie dodano książkę',
        );
    Navigation.backHome();
    context.read<HomeBloc>().add(
          const HomeEventChangePage(pageIndex: 1),
        );
  }
}
