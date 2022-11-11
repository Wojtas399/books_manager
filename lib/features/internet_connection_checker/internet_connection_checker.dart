import 'package:app/components/bloc_listener_component.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/features/internet_connection_checker/bloc/internet_connection_checker_bloc.dart';
import 'package:app/features/internet_connection_checker/no_internet_connection_screen.dart';
import 'package:app/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetConnectionChecker extends StatelessWidget {
  final Widget child;

  const InternetConnectionChecker({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _InternetConnectionCheckerBlocProvider(
      child: _InternetConnectionCheckerBlocListener(
        child: _Content(child: child),
      ),
    );
  }
}

class _InternetConnectionCheckerBlocProvider extends StatelessWidget {
  final Widget child;

  const _InternetConnectionCheckerBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InternetConnectionCheckerBloc(
        device: DeviceProvider.provide(),
      )..add(
          const InternetConnectionCheckerEventInitialize(),
        ),
      child: child,
    );
  }
}

class _InternetConnectionCheckerBlocListener extends StatelessWidget {
  final Widget child;

  const _InternetConnectionCheckerBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListenerComponent<InternetConnectionCheckerBloc,
        InternetConnectionCheckerState, InternetConnectionCheckerInfo, dynamic>(
      onCompletionInfo: (InternetConnectionCheckerInfo info) {
        _onCompletionInfo(info, context);
      },
      child: child,
    );
  }

  void _onCompletionInfo(
    InternetConnectionCheckerInfo info,
    BuildContext context,
  ) {
    if (info == InternetConnectionCheckerInfo.stillHasNotInternetConnection) {
      context.read<DialogInterface>().showInfoDialog(
            context: context,
            title: 'Brak połączenia z internetem',
            info:
                'Wciąż nie wykryto połączenia internetowego. Sprawdź ustawienia i spróbuj ponownie.',
          );
    }
  }
}

class _Content extends StatelessWidget {
  final Widget child;

  const _Content({required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isThereInternetConnection = context.select(
      (InternetConnectionCheckerBloc bloc) {
        return bloc.state.hasInternetConnection;
      },
    );

    if (isThereInternetConnection) {
      return child;
    }
    return const NoInternetConnectionScreen();
  }
}
