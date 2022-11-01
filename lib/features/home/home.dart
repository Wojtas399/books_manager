import 'package:app/features/home/components/home_provider.dart';
import 'package:app/features/home/components/home_router.dart';
import 'package:app/features/home/components/home_user_settings_listener.dart';
import 'package:app/features/home/home_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeProvider(
      child: _HomeBlocProvider(
        child: HomeUserSettingsListener(
          child: HomeRouter(),
        ),
      ),
    );
  }
}

class _HomeBlocProvider extends StatelessWidget {
  final Widget child;

  const _HomeBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit(),
      child: child,
    );
  }
}
