import 'package:app/data/data_sources/local_db/auth_local_db_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/data/local_db/mock_shared_preferences_service.dart';

void main() {
  final sharedPreferencesService = MockSharedPreferencesService();
  late AuthLocalDbService service;

  setUp(() {
    service = AuthLocalDbService(
      sharedPreferencesService: sharedPreferencesService,
    );
  });

  tearDown(() {
    reset(sharedPreferencesService);
  });

  test(
    'load logged user id, should return logged user id loaded from shared preferences',
    () async {
      const String expectedLoggedUserId = 'u1';
      sharedPreferencesService.mockLoadLoggedUserId(
        loggedUserId: expectedLoggedUserId,
      );

      final String? loggedUserId = await service.loadLoggedUserId();

      expect(loggedUserId, expectedLoggedUserId);
    },
  );

  test(
    'save logged user id, should call method responsible for saving logged user id in shared preferences',
    () async {
      const String loggedUserId = 'u1';
      sharedPreferencesService.mockSaveLoggedUserId();

      await service.saveLoggedUserId(loggedUserId: loggedUserId);

      verify(
        () => sharedPreferencesService.saveLoggedUserId(
          loggedUserId: loggedUserId,
        ),
      ).called(1);
    },
  );

  test(
    'remove logged user id, should call method responsible for removing logged user id',
    () async {
      sharedPreferencesService.mockRemoveLoggedUserId();

      await service.removeLoggedUserId();

      verify(
        () => sharedPreferencesService.removeLoggedUserId(),
      ).called(1);
    },
  );
}
