import 'package:app/components/custom_scaffold.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPreviewScreen extends StatelessWidget {
  final String bookId;

  const BookPreviewScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return _BookPreviewBlocProvider(
      child: CustomScaffold(
        body: Center(
          child: Text('Book $bookId preview'),
        ),
      ),
    );
  }
}

class _BookPreviewBlocProvider extends StatelessWidget {
  final Widget child;

  const _BookPreviewBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookPreviewBloc(),
      child: child,
    );
  }
}
