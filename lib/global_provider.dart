import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'providers/database_provider.dart';
import 'providers/dialog_provider.dart';

class GlobalProvider extends StatelessWidget {
  final Widget child;

  const GlobalProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => DialogProvider.provideDialogInterface(),
        ),
        RepositoryProvider(
          create: (_) => DatabaseProvider.provideAuthInterface(),
        ),
      ],
      child: child,
    );
  }
}
