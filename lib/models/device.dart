import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class Device {
  Stream<bool> get internetConnectionListener$;

  Future<bool> hasInternetConnection();
}

class Smartphone extends Device {
  @override
  Stream<bool> get internetConnectionListener$ =>
      InternetConnectionChecker().onStatusChange.map(
        (InternetConnectionStatus internetStatus) {
          return internetStatus == InternetConnectionStatus.connected;
        },
      );

  @override
  Future<bool> hasInternetConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }
}
