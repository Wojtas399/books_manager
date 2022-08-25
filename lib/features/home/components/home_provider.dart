import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../providers/database_provider.dart';

class HomeProvider extends StatelessWidget {
  final Widget child;

  const HomeProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => DatabaseProvider.provideBookInterface(),
        ),
      ],
      child: child,
    );
  }
}
