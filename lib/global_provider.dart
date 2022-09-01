import 'package:app/providers/data_provider.dart';
import 'package:app/providers/dialog_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          create: (_) => DataProvider.provideAuthInterface(),
        ),
      ],
      child: child,
    );
  }
}
