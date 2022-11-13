part of 'internet_connection_checker_bloc.dart';

abstract class InternetConnectionCheckerEvent {
  const InternetConnectionCheckerEvent();
}

class InternetConnectionCheckerEventInitialize
    extends InternetConnectionCheckerEvent {
  const InternetConnectionCheckerEventInitialize();
}

class InternetConnectionCheckerEventConnectionStatusChanged
    extends InternetConnectionCheckerEvent {
  final bool hasInternetConnection;

  const InternetConnectionCheckerEventConnectionStatusChanged({
    required this.hasInternetConnection,
  });
}

class InternetConnectionCheckerEventCheckInternetConnection
    extends InternetConnectionCheckerEvent {
  const InternetConnectionCheckerEventCheckInternetConnection();
}
