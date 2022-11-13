import 'package:app/models/device.dart';
import 'package:mocktail/mocktail.dart';

class MockDevice extends Mock implements Device {
  void mockInternetConnectionListener({required bool hasInternetConnection}) {
    when(
      () => internetConnectionListener$,
    ).thenAnswer((_) => Stream.value(hasInternetConnection));
  }

  void mockHasInternetConnection({required bool value}) {
    when(
      () => hasInternetConnection(),
    ).thenAnswer((_) async => value);
  }
}
