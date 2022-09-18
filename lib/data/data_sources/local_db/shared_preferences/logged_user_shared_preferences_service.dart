import 'package:shared_preferences/shared_preferences.dart';

class LoggedUserSharedPreferencesService {
  final String _loggedUserIdKey = 'loggedUserId';

  Future<void> saveLoggedUserId({required String loggedUserId}) async {
    final preferences = await _getSharedPreferencesInstance();
    preferences.setString(_loggedUserIdKey, loggedUserId);
  }

  Future<String?> loadLoggedUserId() async {
    final preferences = await _getSharedPreferencesInstance();
    return preferences.getString(_loggedUserIdKey);
  }

  Future<void> removeLoggedUserId() async {
    final preferences = await _getSharedPreferencesInstance();
    preferences.remove(_loggedUserIdKey);
  }

  Future<SharedPreferences> _getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }
}
