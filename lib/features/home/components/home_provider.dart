import 'package:app/providers/data_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeProvider extends StatelessWidget {
  final Widget child;

  const HomeProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => DataProvider.provideBookInterface(),
        ),
      ],
      child: child,
    );
  }
}
