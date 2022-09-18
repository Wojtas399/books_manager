import 'package:app/data/data_sources/local_db/auth_local_db_service.dart';
import 'package:app/data/data_sources/local_db/shared_preferences/logged_user_shared_preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoggedUserSharedPreferencesService extends Mock
    implements LoggedUserSharedPreferencesService {}

void main() {
  final loggedUserSharedPreferencesService =
      MockLoggedUserSharedPreferencesService();
  late AuthLocalDbService service;

  setUp(() {
    service = AuthLocalDbService(
        loggedUserSharedPreferencesService: loggedUserSharedPreferencesService);
  });

  tearDown(() {
    reset(loggedUserSharedPreferencesService);
  });

  test(
    'load logged user id, should return logged user id loaded from shared preferences',
    () async {
      const String expectedId = 'u1';
      when(
        () => loggedUserSharedPreferencesService.loadLoggedUserId(),
      ).thenAnswer((_) async => expectedId);

      final String? loggedUserId = await service.loadLoggedUserId();

      expect(loggedUserId, expectedId);
    },
  );

  test(
    'save logged user id, should call method responsible for saving logged user id in shared preferences',
    () async {
      const String loggedUserId = 'u1';
      when(
        () => loggedUserSharedPreferencesService.saveLoggedUserId(
          loggedUserId: loggedUserId,
        ),
      ).thenAnswer((_) async => '');

      await service.saveLoggedUserId(loggedUserId: loggedUserId);

      verify(
        () => loggedUserSharedPreferencesService.saveLoggedUserId(
          loggedUserId: loggedUserId,
        ),
      ).called(1);
    },
  );

  test(
    'remove logged user id, should call method responsible for removing logged user id',
    () async {
      when(
        () => loggedUserSharedPreferencesService.removeLoggedUserId(),
      ).thenAnswer((_) async => '');

      await service.removeLoggedUserId();

      verify(
        () => loggedUserSharedPreferencesService.removeLoggedUserId(),
      ).called(1);
    },
  );
}
