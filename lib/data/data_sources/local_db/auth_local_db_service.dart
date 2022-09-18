import 'package:app/data/data_sources/local_db/shared_preferences/logged_user_shared_preferences_service.dart';

class AuthLocalDbService {
  late final LoggedUserSharedPreferencesService
      _loggedUserSharedPreferencesService;

  AuthLocalDbService({
    required LoggedUserSharedPreferencesService
        loggedUserSharedPreferencesService,
  }) {
    _loggedUserSharedPreferencesService = loggedUserSharedPreferencesService;
  }

  Future<String?> loadLoggedUserId() async {
    return await _loggedUserSharedPreferencesService.loadLoggedUserId();
  }

  Future<void> saveLoggedUserId({required String loggedUserId}) async {
    await _loggedUserSharedPreferencesService.saveLoggedUserId(
      loggedUserId: loggedUserId,
    );
  }

  Future<void> removeLoggedUserId() async {
    await _loggedUserSharedPreferencesService.removeLoggedUserId();
  }
}
