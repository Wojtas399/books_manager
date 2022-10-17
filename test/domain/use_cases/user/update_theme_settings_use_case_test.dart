import 'package:app/domain/use_cases/user/update_theme_settings_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_user_interface.dart';

void main() {
  final userInterface = MockUserInterface();
  final useCase = UpdateThemeSettingsUseCase(userInterface: userInterface);

  test(
    'should call method responsible for updating user theme settings',
    () async {
      const String userId = 'u1';
      const bool isDarkModeOn = true;
      const bool isDarkModeCompatibilityWithSystemOn = false;
      userInterface.mockUpdateUserThemeSettings();

      useCase.execute(
        userId: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );

      verify(
        () => userInterface.updateUserThemeSettings(
          userId: userId,
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
        ),
      ).called(1);
    },
  );
}
