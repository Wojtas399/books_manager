import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/navigation.dart';
import '../interfaces/dialog_interface.dart';
import '../models/bloc_state.dart';
import '../models/bloc_status.dart';

class CustomBlocListener<Bloc extends StateStreamable<State>,
    State extends BlocState, Info, Error> extends StatelessWidget {
  final Widget child;
  final void Function(Info info)? onCompletionInfo;
  final void Function(Error error)? onError;

  const CustomBlocListener({
    super.key,
    required this.child,
    this.onCompletionInfo,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<Bloc, State>(
      listener: (BuildContext context, BlocState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          _manageLoadingStatus(context);
        } else if (blocStatus is BlocStatusComplete<Info>) {
          _manageCompleteStatus(blocStatus, context);
        } else if (blocStatus is BlocStatusError<Error>) {
          _manageErrorStatus(blocStatus, context);
        } else if (blocStatus is BlocStatusLoggedUserNotFound) {
          _manageLoggedUserNotFoundStatus(context);
        } else if (blocStatus is BlocStatusLossOfInternetConnection) {
          _manageLossOfInternetConnection(context);
        } else if (blocStatus is BlocStatusTimeoutException) {
          _manageTimeoutException(context);
        }
      },
      child: child,
    );
  }

  void _manageLoadingStatus(BuildContext context) {
    context.read<DialogInterface>().showLoadingDialog(
          context: context,
        );
  }

  void _manageCompleteStatus(
    BlocStatusComplete<Info> completeStatus,
    BuildContext context,
  ) {
    context.read<DialogInterface>().closeLoadingDialog(
          context: context,
        );
    final Info? info = completeStatus.info;
    final Function(Info info)? onCompletionInfo = this.onCompletionInfo;
    if (info != null && onCompletionInfo != null) {
      onCompletionInfo(info);
    }
  }

  void _manageErrorStatus(
    BlocStatusError<Error> errorStatus,
    BuildContext context,
  ) {
    context.read<DialogInterface>().closeLoadingDialog(
          context: context,
        );
    final Error? error = errorStatus.error;
    final Function(Error error)? onError = this.onError;
    if (error != null && onError != null) {
      onError(error);
    }
  }

  Future<void> _manageLoggedUserNotFoundStatus(BuildContext context) async {
    await context.read<DialogInterface>().showInfoDialog(
          title: 'Brak zalogowanego użytkownika',
          info:
              'Wystąpił nieoczekiwany problem ze znalezieniem zalogowanego użytkownika. W związku z tym za chwilę aplikacja przejdzie do ekranu logowania. Zaloguj się ponownie i przeprowadź operację od początku.',
        );
    Navigation.navigateToSignInScreen();
  }

  void _manageLossOfInternetConnection(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          title: 'Brak połączenia internetowego',
          info:
              'Niestety nie można wykonać tej operacji, ponieważ nie wykryto połączenia z internetem...',
        );
  }

  void _manageTimeoutException(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          title: 'Przekroczony czas wykonania operacji',
          info:
              'Operacja ładuje się zbyt długo. Sprawdź połączenie internetowe i spróbuj ponownie...',
        );
  }
}