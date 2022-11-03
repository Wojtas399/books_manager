import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class Device {
  Future<bool> hasInternetConnection();
}

class Smartphone extends Device {
  @override
  Future<bool> hasInternetConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }
}
