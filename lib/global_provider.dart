import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'providers/dialog_provider.dart';
import 'providers/factory_provider.dart';
import 'providers/database_provider.dart';

class GlobalProvider extends StatelessWidget {
  final Widget child;

  const GlobalProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => FactoryProvider.provideWidgetFactory(),
        ),
        RepositoryProvider(
          create: (_) => FactoryProvider.provideIconFactory(),
        ),
        RepositoryProvider(
          create: (_) => FactoryProvider.provideNavigationFactory(),
        ),
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
