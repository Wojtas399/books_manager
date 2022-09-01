import 'package:app/data/data_sources/local_db/shared_preferences/shared_preferences_service.dart';

class AuthLocalDbService {
  late final SharedPreferencesService _sharedPreferencesService;

  AuthLocalDbService({
    required SharedPreferencesService sharedPreferencesService,
  }) {
    _sharedPreferencesService = sharedPreferencesService;
  }

  Future<String?> loadLoggedUserId() async {
    return await _sharedPreferencesService.loadLoggedUserId();
  }

  Future<void> saveLoggedUserId({required String loggedUserId}) async {
    await _sharedPreferencesService.saveLoggedUserId(
      loggedUserId: loggedUserId,
    );
  }

  Future<void> removeLoggedUserId() async {
    await _sharedPreferencesService.removeLoggedUserId();
  }
}
