import 'package:app/extensions/dialogs_build_context_extension.dart';
import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocListenerComponent<Bloc extends StateStreamable<State>,
    State extends BlocState, Info, Error> extends StatelessWidget {
  final Widget child;
  final void Function(State state)? onStateChanged;
  final void Function(Info info)? onCompletionInfo;
  final void Function(Error error)? onError;

  const BlocListenerComponent({
    super.key,
    required this.child,
    this.onStateChanged,
    this.onCompletionInfo,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<Bloc, State>(
      listener: (BuildContext context, State state) {
        _emitStateChange(state);
        _manageBlocStatus(state.status, context);
      },
      child: child,
    );
  }

  void _emitStateChange(State newState) {
    final void Function(State state)? onStateChanged = this.onStateChanged;
    if (onStateChanged != null) {
      onStateChanged(newState);
    }
  }

  void _manageBlocStatus(BlocStatus blocStatus, BuildContext context) {
    if (blocStatus is BlocStatusLoading) {
      _manageLoadingStatus(context);
    } else if (blocStatus is BlocStatusComplete) {
      _manageCompleteStatus(blocStatus, context);
    } else if (blocStatus is BlocStatusError) {
      _manageErrorStatus(blocStatus, context);
    } else if (blocStatus is BlocStatusLoggedUserNotFound) {
      _manageLoggedUserNotFoundStatus(context);
    } else if (blocStatus is BlocStatusLossOfInternetConnection) {
      _manageLossOfInternetConnection(context);
    } else if (blocStatus is BlocStatusTimeoutException) {
      _manageTimeoutException(context);
    }
  }

  void _manageLoadingStatus(BuildContext context) {
    context.showLoadingDialog();
  }

  void _manageCompleteStatus(
    BlocStatusComplete completeStatus,
    BuildContext context,
  ) {
    _closeLoadingDialog(context);
    final Info? info = completeStatus.info;
    final Function(Info info)? onCompletionInfo = this.onCompletionInfo;
    if (info != null && onCompletionInfo != null) {
      onCompletionInfo(info);
    }
  }

  void _manageErrorStatus(
    BlocStatusError errorStatus,
    BuildContext context,
  ) {
    _closeLoadingDialog(context);
    final Error? error = errorStatus.error;
    final Function(Error error)? onError = this.onError;
    if (error != null && onError != null) {
      onError(error);
    }
  }

  Future<void> _manageLoggedUserNotFoundStatus(BuildContext context) async {
    _closeLoadingDialog(context);
    context.showInfoDialog(
      title: 'Brak zalogowanego użytkownika',
      info:
          'Wystąpił nieoczekiwany problem ze znalezieniem zalogowanego użytkownika. Zaloguj się ponownie i przeprowadź operację od początku.',
    );
    context.navigateBackToSignInScreen();
  }

  void _manageLossOfInternetConnection(BuildContext context) {
    _closeLoadingDialog(context);
    context.showInfoDialog(
      title: 'Brak połączenia internetowego',
      info:
          'Niestety nie można wykonać tej operacji, ponieważ nie wykryto połączenia z internetem...',
    );
  }

  void _manageTimeoutException(BuildContext context) {
    _closeLoadingDialog(context);
    context.showInfoDialog(
      title: 'Przekroczony czas wykonania operacji',
      info:
          'Operacja ładuje się zbyt długo. Sprawdź połączenie internetowe i spróbuj ponownie...',
    );
  }

  void _closeLoadingDialog(BuildContext context) {
    context.closeLoadingDialog();
  }
}
