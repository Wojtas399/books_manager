import 'package:app/validators/password_validator.dart';
import 'package:mocktail/mocktail.dart';

class MockPasswordValidator extends Mock implements PasswordValidator {
  void mockIsValid({required bool isValid}) {
    when(
      () => this.isValid(any()),
    ).thenReturn(isValid);
  }
}
