import 'package:app/models/device.dart';
import 'package:mocktail/mocktail.dart';

class MockDevice extends Mock implements Device {
  void mockHasDeviceInternetConnection({required bool value}) {
    when(() => hasInternetConnection()).thenAnswer((_) async => value);
  }
}
