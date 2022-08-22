import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> saveLoggedUserId({required String loggedUserId}) async {
    final preferences = await _getSharedPreferencesInstance();
    preferences.setString('loggedUserId', loggedUserId);
  }

  Future<String?> loadLoggedUserId() async {
    final preferences = await _getSharedPreferencesInstance();
    return preferences.getString('loggedUserId');
  }

  Future<SharedPreferences> _getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }
}