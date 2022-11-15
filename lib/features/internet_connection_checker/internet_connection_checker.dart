import 'package:app/components/bloc_listener_component.dart';
import 'package:app/config/animations/slide_down_route_animation.dart';
import 'package:app/extensions/dialogs_build_context_extension.dart';
import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:app/features/internet_connection_checker/bloc/internet_connection_checker_bloc.dart';
import 'package:app/features/internet_connection_checker/no_internet_connection_screen.dart';
import 'package:app/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
        child: child,
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

class _InternetConnectionCheckerBlocListener extends StatefulWidget {
  final Widget child;

  const _InternetConnectionCheckerBlocListener({required this.child});

  @override
  State<_InternetConnectionCheckerBlocListener> createState() =>
      _InternetConnectionCheckerBlocListenerState();
}

class _InternetConnectionCheckerBlocListenerState
    extends State<_InternetConnectionCheckerBlocListener> {
  bool isNoInternetConnectionScreenOpened = false;

  @override
  Widget build(BuildContext context) {
    return BlocListenerComponent<InternetConnectionCheckerBloc,
        InternetConnectionCheckerState, InternetConnectionCheckerInfo, dynamic>(
      onStateChanged: (InternetConnectionCheckerState state) {
        _onInternetConnectionChanged(state.hasInternetConnection, context);
      },
      onCompletionInfo: (InternetConnectionCheckerInfo info) {
        _onCompletionInfo(info, context);
      },
      child: widget.child,
    );
  }

  void _onInternetConnectionChanged(
    bool hasInternetConnection,
    BuildContext context,
  ) {
    if (hasInternetConnection && isNoInternetConnectionScreenOpened) {
      context.navigateBack();
      setState(() {
        isNoInternetConnectionScreenOpened = false;
      });
    } else if (!hasInternetConnection && !isNoInternetConnectionScreenOpened) {
      context.closeLoadingDialog();
      _navigateToNoInternetConnectionScreen(context);
      setState(() {
        isNoInternetConnectionScreenOpened = true;
      });
    }
  }

  void _onCompletionInfo(
    InternetConnectionCheckerInfo info,
    BuildContext context,
  ) {
    if (info == InternetConnectionCheckerInfo.stillHasNotInternetConnection) {
      context.showInfoDialog(
        title: 'Brak połączenia z internetem',
        info:
            'Wciąż nie wykryto połączenia internetowego. Sprawdź ustawienia i spróbuj ponownie.',
      );
    }
  }

  void _navigateToNoInternetConnectionScreen(BuildContext context) {
    Navigator.of(context).push(
      SlideDownRouteAnimation(
        page: Provider(
          create: (_) => context.read<InternetConnectionCheckerBloc>(),
          child: const NoInternetConnectionScreen(),
        ),
      ),
    );
  }
}
