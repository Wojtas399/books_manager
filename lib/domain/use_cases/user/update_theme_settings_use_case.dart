import 'package:app/domain/interfaces/user_interface.dart';

class UpdateThemeSettingsUseCase {
  late final UserInterface _userInterface;

  UpdateThemeSettingsUseCase({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Future<void> execute({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) async {
    await _userInterface.updateUser(
      userId: userId,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
  }
}
