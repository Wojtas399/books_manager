import 'dart:async';

import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:app/models/device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_connection_checker_event.dart';
part 'internet_connection_checker_state.dart';

class InternetConnectionCheckerBloc extends CustomBloc<
    InternetConnectionCheckerEvent, InternetConnectionCheckerState> {
  late final Device _device;
  StreamSubscription<bool>? _internetConnectionListener;

  InternetConnectionCheckerBloc({
    required Device device,
    BlocStatus status = const BlocStatusInitial(),
    bool hasInternetConnection = true,
  }) : super(
          InternetConnectionCheckerState(
            status: status,
            hasInternetConnection: hasInternetConnection,
          ),
        ) {
    _device = device;
    on<InternetConnectionCheckerEventInitialize>(_initialize);
    on<InternetConnectionCheckerEventConnectionStatusChanged>(
      _connectionStatusChanged,
    );
    on<InternetConnectionCheckerEventCheckInternetConnection>(
      _checkInternetConnection,
    );
  }

  @override
  Future<void> close() {
    _internetConnectionListener?.cancel();
    _internetConnectionListener = null;
    return super.close();
  }

  void _initialize(
    InternetConnectionCheckerEventInitialize event,
    Emitter<InternetConnectionCheckerState> emit,
  ) {
    _internetConnectionListener ??= _device.internetConnectionListener$.listen(
      (bool hasInternetConnection) {
        add(
          InternetConnectionCheckerEventConnectionStatusChanged(
            hasInternetConnection: hasInternetConnection,
          ),
        );
      },
    );
  }

  void _connectionStatusChanged(
    InternetConnectionCheckerEventConnectionStatusChanged event,
    Emitter<InternetConnectionCheckerState> emit,
  ) {
    emit(state.copyWith(
      hasInternetConnection: event.hasInternetConnection,
    ));
  }

  Future<void> _checkInternetConnection(
    InternetConnectionCheckerEventCheckInternetConnection event,
    Emitter<InternetConnectionCheckerState> emit,
  ) async {
    emitLoadingStatus(emit);
    await Future.delayed(
      const Duration(seconds: 3),
    );
    final bool hasInternetConnection = await _device.hasInternetConnection();
    if (hasInternetConnection == false &&
        state.hasInternetConnection == false) {
      emitInfo<InternetConnectionCheckerInfo>(
        emit,
        InternetConnectionCheckerInfo.stillHasNotInternetConnection,
      );
    } else {
      emit(state.copyWith(
        hasInternetConnection: hasInternetConnection,
      ));
    }
  }
}
