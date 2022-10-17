import 'package:app/domain/use_cases/user/update_theme_settings_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateThemeSettingsUseCase extends Mock
    implements UpdateThemeSettingsUseCase {
  void mock({Object? throwable}) {
    if (throwable != null) {
      when(_execute).thenThrow(throwable);
    } else {
      when(_execute).thenAnswer((_) async => '');
    }
  }

  Future<void> _execute() {
    return execute(
      userId: any(named: 'userId'),
      isDarkModeOn: any(named: 'isDarkModeOn'),
      isDarkModeCompatibilityWithSystemOn: any(
        named: 'isDarkModeCompatibilityWithSystemOn',
      ),
    );
  }
}
