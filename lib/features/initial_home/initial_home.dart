import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/initial_home_bloc.dart';
import 'components/initial_home_content.dart';

class InitialHome extends StatelessWidget {
  const InitialHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InitialHomeBlocProvider(
      child: InitialHomeContent(),
    );
  }
}

class _InitialHomeBlocProvider extends StatelessWidget {
  final Widget child;

  const _InitialHomeBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InitialHomeBloc(),
      child: child,
    );
  }
}
