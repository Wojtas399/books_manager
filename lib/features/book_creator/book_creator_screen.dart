import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/book_creator_bloc.dart';
import 'components/book_creator_content.dart';

class BookCreatorScreen extends StatelessWidget {
  const BookCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BookCreatorBlocProvider(
      child: BookCreatorContent(),
    );
  }
}

class _BookCreatorBlocProvider extends StatelessWidget {
  final Widget child;

  const _BookCreatorBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookCreatorBloc(),
      child: child,
    );
  }
}
