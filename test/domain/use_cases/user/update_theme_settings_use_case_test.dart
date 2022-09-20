import 'package:app/domain/use_cases/user/update_theme_settings_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/interfaces/mock_user_interface.dart';

void main() {
  final userInterface = MockUserInterface();
  final useCase = UpdateThemeSettingsUseCase(userInterface: userInterface);

  test(
    'should call method responsible for updating user only with theme params',
    () async {
      const String userId = 'u1';
      const bool isDarkModeOn = true;
      const bool isDarkModeCompatibilityWithSystemOn = false;
      userInterface.mockUpdateUser();

      useCase.execute(
        userId: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );

      verify(
        () => userInterface.updateUser(
          userId: userId,
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
        ),
      ).called(1);
    },
  );
}
